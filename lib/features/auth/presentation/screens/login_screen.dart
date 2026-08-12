import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/data/mock_backend.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/xp_window.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _cargando = false;
  bool _obscurePassword = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(
      text: AppConfig.useMockBackend ? 'admin@taller.com' : '',
    );
    _passwordController = TextEditingController(
      text: AppConfig.useMockBackend ? 'admin123' : '',
    );
    _mostrarErrorAccesoPendiente();
  }

  void _mostrarErrorAccesoPendiente() {
    final pendiente = AuthRemoteDatasource.ultimoErrorAcceso;
    if (pendiente != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _error = pendiente);
        AuthRemoteDatasource.ultimoErrorAcceso = null;
      });
    }
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _cargando = true;
      _error = null;
    });

    final resultado = await ref.read(iniciarSesionUseCaseProvider)(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    resultado.fold(
      (failure) => setState(() {
        _error = failure.mensaje;
        _cargando = false;
      }),
      (_) => setState(() => _cargando = false),
    );
  }

  Future<void> _iniciarSesionConGoogle() async {
    if (AppConfig.useMockBackend) {
      MockBackend.store.configurarGoogleSimulado(
        email: _emailController.text.trim().isEmpty
            ? 'admin@taller.com'
            : _emailController.text.trim(),
        nombre: 'Usuario Google',
      );
    } else if (!AppConfig.supabaseConfigurado) {
      setState(() => _error = 'Falta configuración de Supabase en .env.');
      return;
    } else if (!kIsWeb && AppConfig.googleWebClientId.isEmpty) {
      setState(() => _error = 'Falta GOOGLE_WEB_CLIENT_ID en .env (requerido en Android).');
      return;
    }

    setState(() {
      _cargando = true;
      _error = null;
    });

    final resultado = await ref.read(iniciarSesionConGoogleUseCaseProvider)();

    if (!mounted) return;

    resultado.fold(
      (failure) {
        if (failure.mensaje.startsWith('Redirigiendo a Google')) return;
        setState(() {
          _error = failure.mensaje;
          _cargando = false;
        });
      },
      (_) => setState(() => _cargando = false),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final esMock = AppConfig.useMockBackend;
    final googleHabilitado = esMock ||
        (AppConfig.supabaseConfigurado && (kIsWeb || AppConfig.googleWebClientId.isNotEmpty));

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: XpColors.desktop),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: XpWindow(
            title: AppConfig.appName,
            maxWidth: 440,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!esMock)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: Text(
                        'Conectado a Supabase',
                        style: TextStyle(fontSize: 12, color: Colors.green.shade900),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Text(
                    esMock
                        ? 'Modo demo local'
                        : 'Inicia sesión para continuar',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.email_outlined, size: 20),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Ingresa tu correo';
                      if (!v.contains('@')) return 'Correo inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _iniciarSesion(),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Ingresa tu contraseña';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_error != null) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        _error!,
                        style: TextStyle(color: Colors.red.shade900, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  FilledButton(
                    onPressed: _cargando ? null : _iniciarSesion,
                    child: _cargando
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Iniciar sesión'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('O', style: TextStyle(color: Colors.grey.shade600)),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _cargando || !googleHabilitado ? null : _iniciarSesionConGoogle,
                    icon: const _GoogleIcon(size: 20),
                    label: const Text('Continuar con Google'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    esMock
                        ? 'Demo: admin@taller.com / admin123'
                        : kIsWeb
                            ? 'Google (web): redirect OAuth vía Supabase.\n'
                                'Invitación: usa el mismo Gmail invitado en RRHH '
                                '(no se envía correo automático).'
                            : 'Google (Android): selector de cuenta dentro de la app.\n'
                                'Requiere credencial OAuth Android + SHA-1 en Google Cloud.',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  if (!googleHabilitado && !esMock)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        kIsWeb
                            ? 'Configura SUPABASE_URL y SUPABASE_ANON_KEY en .env'
                            : 'Configura Supabase y GOOGLE_WEB_CLIENT_ID en .env',
                        style: const TextStyle(fontSize: 11, color: Colors.orange),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Icono Google local (evita CORS en web).
class _GoogleIcon extends StatelessWidget {
  final double size;
  const _GoogleIcon({this.size = 24});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleIconPainter()),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -0.4, 3.5, true, Paint()..color = const Color(0xFF4285F4));
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 2.8, 1.2, true, Paint()..color = const Color(0xFF34A853));
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 4.0, 1.0, true, Paint()..color = const Color(0xFFFBBC05));
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 5.0, 1.0, true, Paint()..color = const Color(0xFFEA4335));
    canvas.drawCircle(center, radius * 0.55, Paint()..color = Colors.white);
    canvas.drawRect(
      Rect.fromCenter(center: Offset(center.dx + radius * 0.05, center.dy), width: radius * 0.95, height: radius * 0.22),
      Paint()..color = const Color(0xFF4285F4),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
