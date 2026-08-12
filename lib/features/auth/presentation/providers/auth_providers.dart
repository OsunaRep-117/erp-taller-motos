import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/data/mock/mock_auth_datasource.dart';
import '../../../../core/data/mock_backend.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/mock_auth_repository_impl.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/cerrar_sesion.dart';
import '../../domain/usecases/iniciar_sesion.dart';
import '../../domain/usecases/iniciar_sesion_con_google.dart';
import '../../../../core/network/supabase_client_provider.dart';

part 'auth_providers.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  if (AppConfig.useMockBackend) {
    return MockAuthRepositoryImpl(MockAuthDatasource(MockBackend.store));
  }
  return AuthRepositoryImpl(AuthRemoteDatasource(ref.watch(supabaseClientProvider)));
}

@riverpod
IniciarSesion iniciarSesionUseCase(IniciarSesionUseCaseRef ref) {
  return IniciarSesion(ref.watch(authRepositoryProvider));
}

@riverpod
IniciarSesionConGoogle iniciarSesionConGoogleUseCase(IniciarSesionConGoogleUseCaseRef ref) {
  return IniciarSesionConGoogle(ref.watch(authRepositoryProvider));
}

@riverpod
CerrarSesion cerrarSesionUseCase(CerrarSesionUseCaseRef ref) {
  return CerrarSesion(ref.watch(authRepositoryProvider));
}

@riverpod
Stream<Usuario?> authState(AuthStateRef ref) {
  return ref.watch(authRepositoryProvider).observarEstadoAuth();
}
