import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/data/mock/mock_citas_datasource.dart';
import '../../../../core/data/mock_backend.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../data/datasources/citas_datasource.dart';
import '../../data/datasources/citas_remote_datasource.dart';
import '../../data/repositories/citas_repository_impl.dart';
import '../../domain/entities/cita.dart';
import '../../domain/repositories/citas_repository.dart';
import '../../domain/usecases/agendar_cita.dart';
import '../../domain/usecases/cancelar_cita.dart';
import '../../domain/usecases/completar_cita.dart';
import '../../domain/usecases/confirmar_cita.dart';
import '../../../taller/presentation/providers/orden_trabajo_providers.dart';

part 'citas_providers.g.dart';

@riverpod
CitasDataSource citasDataSource(CitasDataSourceRef ref) {
  if (AppConfig.useMockBackend) {
    return MockCitasDatasource(MockBackend.store);
  }
  return CitasRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
CitasRepository citasRepository(CitasRepositoryRef ref) {
  return CitasRepositoryImpl(ref.watch(citasDataSourceProvider));
}

@riverpod
AgendarCita agendarCitaUseCase(AgendarCitaUseCaseRef ref) {
  return AgendarCita(ref.watch(citasRepositoryProvider));
}

@riverpod
ConfirmarCita confirmarCitaUseCase(ConfirmarCitaUseCaseRef ref) {
  return ConfirmarCita(ref.watch(citasRepositoryProvider));
}

@riverpod
CancelarCita cancelarCitaUseCase(CancelarCitaUseCaseRef ref) {
  return CancelarCita(ref.watch(citasRepositoryProvider));
}

@riverpod
CompletarCita completarCitaUseCase(CompletarCitaUseCaseRef ref) {
  return CompletarCita(
    ref.watch(citasRepositoryProvider),
    ref.watch(crearOrdenTrabajoUseCaseProvider),
  );
}

@riverpod
Future<List<Cita>> citasAgenda(CitasAgendaRef ref) {
  return ref
      .watch(citasRepositoryProvider)
      .listarCitas()
      .then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}
