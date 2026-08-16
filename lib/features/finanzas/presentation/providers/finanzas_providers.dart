import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/data/mock/mock_finanzas_datasource.dart';
import '../../../../core/data/mock_backend.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../data/datasources/finanzas_datasource.dart';
import '../../data/datasources/finanzas_remote_datasource.dart';
import '../../data/repositories/finanzas_repository_impl.dart';
import '../../domain/entities/factura.dart';
import '../../domain/entities/pago.dart';
import '../../domain/repositories/finanzas_repository.dart';
import '../../domain/usecases/emitir_factura.dart';
import '../../domain/usecases/generar_nota_credito.dart';
import '../../domain/usecases/registrar_gasto_operativo.dart';
import '../../domain/usecases/registrar_pago.dart';
import '../../domain/usecases/revertir_pago.dart';

part 'finanzas_providers.g.dart';

@riverpod
FinanzasDataSource finanzasDataSource(FinanzasDataSourceRef ref) {
  if (AppConfig.useMockBackend) {
    return MockFinanzasDatasource(MockBackend.store);
  }
  return FinanzasRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
FinanzasRepository finanzasRepository(FinanzasRepositoryRef ref) {
  return FinanzasRepositoryImpl(ref.watch(finanzasDataSourceProvider));
}

@riverpod
RegistrarPago registrarPagoUseCase(RegistrarPagoUseCaseRef ref) {
  return RegistrarPago(ref.watch(finanzasRepositoryProvider));
}

@riverpod
EmitirFactura emitirFacturaUseCase(EmitirFacturaUseCaseRef ref) {
  return EmitirFactura(ref.watch(finanzasRepositoryProvider));
}

@riverpod
GenerarNotaCredito generarNotaCreditoUseCase(GenerarNotaCreditoUseCaseRef ref) {
  return GenerarNotaCredito(ref.watch(finanzasRepositoryProvider));
}

@riverpod
RevertirPago revertirPagoUseCase(RevertirPagoUseCaseRef ref) {
  return RevertirPago(ref.watch(finanzasRepositoryProvider));
}

@riverpod
RegistrarGastoOperativo registrarGastoOperativoUseCase(
  RegistrarGastoOperativoUseCaseRef ref,
) {
  return RegistrarGastoOperativo(ref.watch(finanzasRepositoryProvider));
}

@riverpod
Future<List<Pago>> pagosPorOrden(PagosPorOrdenRef ref, String idOrden) {
  return ref
      .watch(finanzasRepositoryProvider)
      .listarPagosPorOrden(idOrden)
      .then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}

@riverpod
Future<List<Pago>> todosLosPagos(TodosLosPagosRef ref) {
  return ref
      .watch(finanzasRepositoryProvider)
      .listarTodosLosPagos()
      .then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}

@riverpod
Future<List<Factura>> todasLasFacturas(TodasLasFacturasRef ref) {
  return ref
      .watch(finanzasRepositoryProvider)
      .listarFacturas()
      .then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}

@riverpod
Future<double> ingresosMensuales(IngresosMensualesRef ref) {
  return ref
      .watch(finanzasRepositoryProvider)
      .obtenerIngresosMensuales()
      .then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}

@riverpod
Future<double> valorInventario(ValorInventarioRef ref) {
  return ref
      .watch(finanzasRepositoryProvider)
      .obtenerValorInventario()
      .then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}

@riverpod
Future<double> gastosOperativosMes(GastosOperativosMesRef ref) {
  return ref
      .watch(finanzasRepositoryProvider)
      .obtenerGastosOperativosMes()
      .then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}
