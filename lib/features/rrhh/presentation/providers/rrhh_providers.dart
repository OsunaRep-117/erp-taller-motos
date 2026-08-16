import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/data/mock/mock_rrhh_datasource.dart';
import '../../../../core/data/mock_backend.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/rrhh_datasource.dart';
import '../../data/datasources/rrhh_remote_datasource.dart';
import '../../data/repositories/rrhh_repository_impl.dart';
import '../../domain/entities/comision.dart';
import '../../domain/entities/empleado.dart';
import '../../domain/entities/empleado_invitacion.dart';
import '../../domain/repositories/rrhh_repository.dart';

part 'rrhh_providers.g.dart';

@riverpod
RrhhDataSource rrhhDataSource(RrhhDataSourceRef ref) {
  if (AppConfig.useMockBackend) {
    return MockRrhhDatasource(MockBackend.store);
  }
  return RrhhRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
RrhhRepository rrhhRepository(RrhhRepositoryRef ref) {
  return RrhhRepositoryImpl(ref.watch(rrhhDataSourceProvider));
}

@riverpod
Future<List<Comision>> comisionesVisibles(ComisionesVisiblesRef ref) async {
  final usuario = await ref.watch(authStateProvider.future);
  if (usuario == null) return [];

  final repository = ref.watch(rrhhRepositoryProvider);
  final result = usuario.esAdmin
      ? await repository.listarTodasLasComisiones()
      : await repository.listarComisionesDeMecanico(usuario.id);

  return result.fold((f) => throw Exception(f.mensaje), (r) => r);
}

@riverpod
Future<List<Empleado>> listaEmpleados(ListaEmpleadosRef ref) {
  return ref
      .watch(rrhhRepositoryProvider)
      .listarEmpleados()
      .then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}

@riverpod
Future<List<EmpleadoInvitacion>> invitacionesPendientes(
  InvitacionesPendientesRef ref,
) {
  return ref
      .watch(rrhhRepositoryProvider)
      .listarInvitacionesPendientes()
      .then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}
