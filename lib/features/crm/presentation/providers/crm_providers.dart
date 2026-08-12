import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/data/mock/mock_crm_datasource.dart';
import '../../../../core/data/mock_backend.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../data/datasources/crm_datasource.dart';
import '../../data/datasources/crm_remote_datasource.dart';
import '../../data/repositories/crm_repository_impl.dart';
import '../../domain/entities/cliente.dart';
import '../../domain/entities/motocicleta.dart';
import '../../domain/repositories/crm_repository.dart';
import '../../domain/usecases/actualizar_cliente.dart';
import '../../domain/usecases/actualizar_motocicleta.dart';
import '../../domain/usecases/crear_cliente.dart';
import '../../domain/usecases/crear_motocicleta.dart';

part 'crm_providers.g.dart';

@riverpod
CrmDataSource crmDataSource(CrmDataSourceRef ref) {
  if (AppConfig.useMockBackend) {
    return MockCrmDatasource(MockBackend.store);
  }
  return CrmRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
CrmRepository crmRepository(CrmRepositoryRef ref) {
  return CrmRepositoryImpl(ref.watch(crmDataSourceProvider));
}

@riverpod
CrearCliente crearClienteUseCase(CrearClienteUseCaseRef ref) {
  return CrearCliente(ref.watch(crmRepositoryProvider));
}

@riverpod
CrearMotocicleta crearMotocicletaUseCase(CrearMotocicletaUseCaseRef ref) {
  return CrearMotocicleta(ref.watch(crmRepositoryProvider));
}

@riverpod
ActualizarCliente actualizarClienteUseCase(ActualizarClienteUseCaseRef ref) {
  return ActualizarCliente(ref.watch(crmRepositoryProvider));
}

@riverpod
ActualizarMotocicleta actualizarMotocicletaUseCase(ActualizarMotocicletaUseCaseRef ref) {
  return ActualizarMotocicleta(ref.watch(crmRepositoryProvider));
}

@riverpod
Future<List<Cliente>> clientesDisponibles(ClientesDisponiblesRef ref) {
  return ref.watch(crmRepositoryProvider).listarClientes().then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}

@riverpod
Future<List<Motocicleta>> motocicletasCrm(MotocicletasCrmRef ref) {
  return ref.watch(crmRepositoryProvider).listarMotocicletas().then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}

@riverpod
Future<Cliente> clientePorId(ClientePorIdRef ref, String id) {
  return ref.watch(crmRepositoryProvider).obtenerClientePorId(id).then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}

@riverpod
Future<Motocicleta> motocicletaPorVin(MotocicletaPorVinRef ref, String vin) {
  return ref.watch(crmRepositoryProvider).obtenerMotocicletaPorVin(vin).then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}
