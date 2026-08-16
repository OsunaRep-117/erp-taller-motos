import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:postgrest/postgrest.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/entities/usuario.dart';

/// Se lanza en web cuando el navegador va a redirigir a Google (no es fallo).
class GoogleRedirectPending implements Exception {
  const GoogleRedirectPending();
}

class AuthRemoteDatasource {
  final SupabaseClient client;
  const AuthRemoteDatasource(this.client);

  static String? ultimoErrorAcceso;

  Future<Usuario> iniciarSesion({
    required String email,
    required String password,
  }) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final authUser = response.user;
    if (authUser == null) {
      throw const AuthException('No se pudo iniciar sesión.');
    }

    return _resolverAccesoEmpleado(authUser);
  }

  Future<Usuario> iniciarSesionConGoogle() async {
    ultimoErrorAcceso = null;

    if (kIsWeb) {
      return _iniciarSesionConGoogleOAuth(Uri.base.origin);
    }
    return _iniciarSesionConGoogleNativo();
  }

  /// Android/iOS: selector nativo de cuenta Google (sin abrir navegador).
  Future<Usuario> _iniciarSesionConGoogleNativo() async {
    if (AppConfig.googleWebClientId.isEmpty) {
      throw const AuthException(
        'Falta GOOGLE_WEB_CLIENT_ID en .env (serverClientId para Google en móvil).',
      );
    }

    await client.auth.signOut(scope: SignOutScope.local);

    final googleSignIn = GoogleSignIn(
      serverClientId: AppConfig.googleWebClientId,
      scopes: const ['email', 'openid'],
    );

    try {
      await googleSignIn.signOut();
      try {
        await googleSignIn.disconnect();
      } catch (_) {}

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthException('Inicio de sesión con Google cancelado.');
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        throw const AuthException(
          'No se pudo obtener el ID Token de Google. '
          'Verifica GOOGLE_WEB_CLIENT_ID y la credencial Android (SHA-1) en Google Cloud.',
        );
      }

      final response = await client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: googleAuth.accessToken,
      );

      final authUser = response.user;
      if (authUser == null) {
        throw const AuthException('No se pudo autenticar con Google.');
      }

      return _resolverAccesoEmpleado(
        authUser,
        nombreGoogle:
            googleUser.displayName ?? authUser.email?.split('@').first,
      );
    } on PlatformException catch (e) {
      if (e.code == '10') {
        throw const AuthException(
          'Error 10: en Google Cloud crea credencial OAuth tipo Android con '
          'package com.upfim.erp_flutter y el SHA-1 de tu keystore debug.',
        );
      }
      if (e.code == 'popup_closed' || e.code == 'sign_in_canceled') {
        throw const AuthException('Inicio de sesión con Google cancelado.');
      }
      throw AuthException('Error de Google (${e.code}): ${e.message}');
    }
  }

  /// Web: redirect OAuth vía Supabase.
  Future<Usuario> _iniciarSesionConGoogleOAuth(String redirectTo) async {
    await client.auth.signOut(scope: SignOutScope.local);

    try {
      await client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: redirectTo,
        authScreenLaunchMode: kIsWeb
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
        queryParams: const {
          'prompt': 'select_account',
          'access_type': 'offline',
        },
      );
    } on AuthException catch (e) {
      throw AuthException(_mensajeGoogleConfig(e.message));
    }

    final authUser = client.auth.currentUser;
    if (authUser != null) {
      return _resolverAccesoEmpleado(authUser);
    }

    throw const GoogleRedirectPending();
  }

  Future<void> cerrarSesion() async {
    ultimoErrorAcceso = null;
    if (!kIsWeb && AppConfig.googleWebClientId.isNotEmpty) {
      try {
        await GoogleSignIn(
          serverClientId: AppConfig.googleWebClientId,
        ).signOut();
      } catch (_) {}
    }
    await client.auth.signOut(scope: SignOutScope.global);
  }

  Future<Usuario?> obtenerUsuarioActual() async {
    final authUser = client.auth.currentUser;
    if (authUser == null) return null;
    try {
      return await _resolverAccesoEmpleado(authUser);
    } on AuthException catch (e) {
      ultimoErrorAcceso = e.message;
      await client.auth.signOut();
      return null;
    }
  }

  Stream<Usuario?> observarEstadoAuth() async* {
    // Emitimos el estado actual de inmediato: onAuthStateChange no siempre
    // repite un evento retroactivo si la sesión ya estaba activa (ej. tras
    // un hot-restart o recarga de página), lo que dejaba el stream sin
    // emitir nada y las pantallas protegidas por rol cargando para siempre.
    yield await obtenerUsuarioActual();

    yield* client.auth.onAuthStateChange.asyncMap((data) async {
      final authUser = data.session?.user;
      if (authUser == null) return null;
      try {
        return await _resolverAccesoEmpleado(authUser);
      } on AuthException catch (e) {
        ultimoErrorAcceso = e.message;
        await client.auth.signOut();
        return null;
      }
    });
  }

  Future<Usuario> _resolverAccesoEmpleado(
    User authUser, {
    String? nombreGoogle,
  }) async {
    final meta = authUser.userMetadata;
    final nombre =
        nombreGoogle ??
        meta?['full_name'] as String? ??
        meta?['name'] as String? ??
        authUser.email?.split('@').first ??
        'Usuario';

    try {
      final data = await client.rpc(
        'resolver_acceso_empleado',
        params: {
          'p_user_id': authUser.id,
          'p_email': authUser.email ?? '',
          'p_nombre': nombre,
        },
      );

      if (data is! Map<String, dynamic>) {
        throw const AuthException('No se pudo resolver el acceso al ERP.');
      }

      if ((data['activo'] as bool?) != true) {
        throw const AuthException('Tu cuenta de empleado está desactivada.');
      }

      ultimoErrorAcceso = null;
      return Usuario(
        id: authUser.id,
        email: authUser.email ?? data['email'] as String,
        nombre: data['nombre'] as String,
        rol: Usuario.rolFromString(data['rol'] as String),
      );
    } on PostgrestException catch (e) {
      await client.auth.signOut();
      if (e.code == 'PGRST202' ||
          e.message.contains('resolver_acceso_empleado')) {
        throw const AuthException(
          'Falta la función resolver_acceso_empleado. '
          'Ejecuta supabase/migrations/003_empleados_invitados.sql en Supabase.',
        );
      }
      throw AuthException(e.message);
    }
  }

  static String _mensajeGoogleConfig(String raw) {
    if (raw.contains('missing OAuth secret') ||
        raw.contains('Unsupported provider')) {
      final redirect = kIsWeb ? Uri.base.origin : AppConfig.oauthRedirectUrl;
      return 'Configura Google en Supabase → Authentication → Providers → Google:\n'
          '• Client ID (Web): tu GOOGLE_WEB_CLIENT_ID\n'
          '• Client Secret: cópialo de Google Cloud → Credentials → OAuth Web\n\n'
          'Agrega $redirect en Redirect URLs de Supabase.';
    }
    return raw;
  }

  /// Convierte excepciones crudas en mensajes legibles para la UI.
  static String mensajeAmigable(Object error) {
    final texto = error.toString();
    if (error is AuthException) return error.message;
    if (texto.contains('people.googleapis.com') ||
        texto.contains('People API')) {
      return 'Activa People API en Google Cloud (proyecto 674051757213):\n'
          'https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=674051757213\n\n'
          'En web usamos OAuth de Supabase; si persiste, verifica Client Secret en Supabase → Google.';
    }
    if (texto.contains('missing OAuth secret')) {
      return _mensajeGoogleConfig(texto);
    }
    if (texto.contains('No tienes acceso al ERP')) {
      return 'Tu correo Google no está invitado o ya hay otro administrador.\n'
          'Pide al admin que te invite en Gestión de Personal con el mismo email '
          'con el que inicias sesión en Google.\n\n'
          'Nota: la invitación en el ERP no envía correo; solo pre-registra tu Gmail.';
    }
    if (texto.length > 280) {
      return 'Error de autenticación con Google. Revisa la consola del navegador '
          'y la configuración OAuth en Supabase y Google Cloud.';
    }
    return texto;
  }
}
