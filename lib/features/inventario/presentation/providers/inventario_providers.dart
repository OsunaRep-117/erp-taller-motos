import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/data/mock/mock_inventario_datasource.dart';
import '../../../../core/data/mock_backend.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../data/datasources/inventario_datasource.dart';
import '../../data/datasources/inventario_remote_datasource.dart';
import '../../data/repositories/inventario_repository_impl.dart';
import '../../domain/entities/refaccion.dart';
import '../../domain/repositories/inventario_repository.dart';
import '../../domain/usecases/ajustar_inventario_manual.dart';
import '../../domain/usecases/confirmar_salida_inventario.dart';
import '../../domain/usecases/solicitar_refaccion_para_orden.dart';
import '../../../taller/presentation/providers/orden_trabajo_providers.dart';

part 'inventario_providers.g.dart';

@riverpod
InventarioDataSource inventarioDataSource(InventarioDataSourceRef ref) {
  if (AppConfig.useMockBackend) {
    return MockInventarioDatasource(MockBackend.store);
  }
  return InventarioRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
InventarioRepository inventarioRepository(InventarioRepositoryRef ref) {
  return InventarioRepositoryImpl(ref.watch(inventarioDataSourceProvider));
}

@riverpod
SolicitarRefaccionParaOrden solicitarRefaccionUseCase(
  SolicitarRefaccionUseCaseRef ref,
) {
  return SolicitarRefaccionParaOrden(
    ref.watch(inventarioRepositoryProvider),
    ref.watch(ordenTrabajoRepositoryProvider),
  );
}

@riverpod
ConfirmarSalidaInventario confirmarSalidaUseCase(
  ConfirmarSalidaUseCaseRef ref,
) {
  return ConfirmarSalidaInventario(ref.watch(inventarioRepositoryProvider));
}

@riverpod
AjustarInventarioManual ajustarInventarioUseCase(
  AjustarInventarioUseCaseRef ref,
) {
  return AjustarInventarioManual(ref.watch(inventarioRepositoryProvider));
}

@riverpod
Future<List<Refaccion>> refaccionesDisponibles(RefaccionesDisponiblesRef ref) {
  return ref
      .watch(inventarioRepositoryProvider)
      .listarRefacciones()
      .then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}

@riverpod
Future<List<Map<String, dynamic>>> reservasPorOrden(
  ReservasPorOrdenRef ref,
  String idOrden,
) {
  return ref
      .watch(inventarioRepositoryProvider)
      .listarReservasPorOrden(idOrden)
      .then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}

@riverpod
Future<List<Map<String, dynamic>>> consumosPorOrden(
  ConsumosPorOrdenRef ref,
  String idOrden,
) {
  return ref
      .watch(inventarioRepositoryProvider)
      .listarConsumosPorOrden(idOrden)
      .then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}

@riverpod
Future<Refaccion> refaccionPorSku(RefaccionPorSkuRef ref, String sku) {
  return ref
      .watch(inventarioRepositoryProvider)
      .obtenerPorSku(sku)
      .then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}
