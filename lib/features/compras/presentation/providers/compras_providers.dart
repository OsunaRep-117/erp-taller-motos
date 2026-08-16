import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/data/mock/mock_compras_datasource.dart';
import '../../../../core/data/mock_backend.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../data/datasources/compras_datasource.dart';
import '../../data/datasources/compras_remote_datasource.dart';
import '../../data/repositories/compras_repository_impl.dart';
import '../../domain/entities/proveedor.dart';
import '../../domain/repositories/compras_repository.dart';
import '../../domain/usecases/orden_compra_usecases.dart';
import '../../domain/entities/orden_compra.dart';

part 'compras_providers.g.dart';

@riverpod
ComprasDataSource comprasDataSource(ComprasDataSourceRef ref) {
  if (AppConfig.useMockBackend) {
    return MockComprasDatasource(MockBackend.store);
  }
  return ComprasRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
ComprasRepository comprasRepository(ComprasRepositoryRef ref) {
  return ComprasRepositoryImpl(ref.watch(comprasDataSourceProvider));
}

@riverpod
Future<List<Proveedor>> proveedoresDisponibles(ProveedoresDisponiblesRef ref) {
  return ref
      .watch(comprasRepositoryProvider)
      .listarProveedores()
      .then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}

@riverpod
Future<List<Map<String, dynamic>>> entradasInventario(
  EntradasInventarioRef ref,
) {
  return ref
      .watch(comprasRepositoryProvider)
      .listarEntradas()
      .then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}

@riverpod
Future<List<OrdenCompra>> ordenesCompraList(OrdenesCompraListRef ref) {
  return ref
      .watch(comprasRepositoryProvider)
      .listarOrdenesCompra()
      .then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}

@riverpod
CrearOrdenCompra crearOrdenCompraUseCase(CrearOrdenCompraUseCaseRef ref) {
  return CrearOrdenCompra(ref.watch(comprasRepositoryProvider));
}

@riverpod
AprobarOrdenCompra aprobarOrdenCompraUseCase(AprobarOrdenCompraUseCaseRef ref) {
  return AprobarOrdenCompra(ref.watch(comprasRepositoryProvider));
}

@riverpod
RecibirOrdenCompra recibirOrdenCompraUseCase(RecibirOrdenCompraUseCaseRef ref) {
  return RecibirOrdenCompra(ref.watch(comprasRepositoryProvider));
}
