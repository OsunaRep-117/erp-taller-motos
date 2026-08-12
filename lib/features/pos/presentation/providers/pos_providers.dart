import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/data/mock/mock_pos_datasource.dart';
import '../../../../core/data/mock_backend.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../data/datasources/pos_datasource.dart';
import '../../data/datasources/pos_remote_datasource.dart';
import '../../data/repositories/pos_repository_impl.dart';
import '../../domain/repositories/pos_repository.dart';
import '../../domain/usecases/registrar_venta.dart';

part 'pos_providers.g.dart';

@riverpod
PosDataSource posDataSource(PosDataSourceRef ref) {
  if (AppConfig.useMockBackend) {
    return MockPosDatasource(MockBackend.store);
  }
  return PosRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
PosRepository posRepository(PosRepositoryRef ref) {
  return PosRepositoryImpl(ref.watch(posDataSourceProvider));
}

@riverpod
RegistrarVenta registrarVentaUseCase(RegistrarVentaUseCaseRef ref) {
  return RegistrarVenta(ref.watch(posRepositoryProvider));
}

@riverpod
Future<List<Map<String, dynamic>>> refaccionesPos(RefaccionesPosRef ref) {
  return ref.watch(posDataSourceProvider).listarRefaccionesPos();
}

@riverpod
Future<List<Map<String, dynamic>>> ventasPosHistorial(VentasPosHistorialRef ref) {
  return ref.watch(posDataSourceProvider).listarVentas();
}
