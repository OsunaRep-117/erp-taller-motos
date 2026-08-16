import 'package:flutter/foundation.dart';
import 'env_loader.dart';

/// Configuración global de la app.
///
/// Orden de prioridad: `--dart-define` → `.env` en la raíz del proyecto → defaults.
///
/// Si tienes credenciales Supabase en `.env`, `flutter run` usa backend real
/// sin necesidad de elegir un perfil especial en VS Code.
class AppConfig {
  static String _resolve(
    String fromDefine,
    String key, {
    String defaultValue = '',
  }) {
    if (fromDefine.isNotEmpty) return fromDefine;
    return EnvLoader.get(key) ?? defaultValue;
  }

  /// Mock solo si no hay Supabase configurado y USE_MOCK no fuerza lo contrario.
  static bool get useMockBackend {
    const useMockFromDefine = String.fromEnvironment('USE_MOCK');
    if (useMockFromDefine.isNotEmpty) return useMockFromDefine == 'true';

    final useMockFromFile = EnvLoader.get('USE_MOCK');
    if (useMockFromFile != null && useMockFromFile.isNotEmpty) {
      return useMockFromFile == 'true';
    }

    if (supabaseConfigurado) return false;
    return true;
  }

  static String get supabaseUrl =>
      _resolve(const String.fromEnvironment('SUPABASE_URL'), 'SUPABASE_URL');

  static String get supabaseAnonKey => _resolve(
    const String.fromEnvironment('SUPABASE_ANON_KEY'),
    'SUPABASE_ANON_KEY',
  );

  static String get googleWebClientId => _resolve(
    const String.fromEnvironment('GOOGLE_WEB_CLIENT_ID'),
    'GOOGLE_WEB_CLIENT_ID',
  );

  /// Deep link OAuth móvil (minúsculas, sin guiones bajos — requisito de Google).
  /// Agrégalo en Supabase → Authentication → URL Configuration → Redirect URLs.
  static const oauthRedirectUrl = 'com.upfim.erpflutter://login-callback';

  static const appName = 'ERP Taller de Motocicletas';

  static const evidenciasBucket = 'evidencias-ot';

  /// PIN demo para devoluciones POS (§5.3).
  static const posAutorizacionPin = '8765';

  /// Constantes de negocio (deben coincidir con las RPC en Supabase).
  static const tarifaManoObraPorHora = 350.0;
  static const porcentajeComision = 0.08;

  static bool get supabaseConfigurado =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static bool get googleDisponible =>
      !useMockBackend &&
      supabaseConfigurado &&
      (kIsWeb || googleWebClientId.isNotEmpty);

  static void assertSupabaseConfig() {
    if (useMockBackend) return;
    if (!supabaseConfigurado) {
      throw StateError(
        'Faltan SUPABASE_URL y/o SUPABASE_ANON_KEY. '
        'Agrégalas en .env (copia de .env.example) o pásalas con --dart-define.',
      );
    }
  }
}
