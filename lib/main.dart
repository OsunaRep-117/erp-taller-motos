import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/app_config.dart';
import 'core/config/env_loader.dart';
import 'core/data/mock_backend.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EnvLoader.load();

  if (AppConfig.useMockBackend) {
    MockBackend.initialize();
  } else {
    AppConfig.assertSupabaseConfig();
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
    // Validamos el acceso al ERP en segundo plano (no con await) para no
    // bloquear el arranque completo de la app si la RPC resolver_acceso_empleado
    // tarda o falla intermitentemente. El stream reactivo de authState ya
    // recoge el resultado final y el router reacciona a él normalmente.
    unawaited(
      AuthRemoteDatasource(Supabase.instance.client).obtenerUsuarioActual(),
    );
  }

  runApp(const ProviderScope(child: ErpTallerApp()));
}

class ErpTallerApp extends ConsumerWidget {
  const ErpTallerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: AppConfig.appName,
      theme: AppTheme.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
