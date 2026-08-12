import '../../../features/finanzas/data/datasources/finanzas_datasource.dart';
import '../../../features/finanzas/domain/entities/factura.dart';
import '../../../features/finanzas/domain/entities/pago.dart';
import 'mock_data_store.dart';

class MockFinanzasDatasource implements FinanzasDataSource {
  final MockDataStore store;
  const MockFinanzasDatasource(this.store);

  Future<void> registrarPago({
    required String idOrden,
    required double monto,
    required String metodoPago,
  }) async =>
      store.registrarPago(
        idOrden: idOrden,
        monto: monto,
        metodoPago: MetodoPago.values.byName(metodoPago),
      );

  Future<void> revertirPago(String idPago) async => store.revertirPago(idPago);

  Future<List<Pago>> listarPagosPorOrden(String idOrden) async {
    store.ensureSeeded();
    return store.pagos.where((p) => p.idOrden == idOrden).toList()
      ..sort((a, b) => b.fechaPago.compareTo(a.fechaPago));
  }

  Future<List<Pago>> listarTodosLosPagos() async {
    store.ensureSeeded();
    return List.from(store.pagos)..sort((a, b) => b.fechaPago.compareTo(a.fechaPago));
  }

  Future<Factura> emitirFactura({
    required String idOrden,
    required String rfcReceptor,
  }) async =>
      store.emitirFactura(idOrden: idOrden, rfcReceptor: rfcReceptor);

  Future<List<Factura>> listarFacturas() async {
    store.ensureSeeded();
    return List.from(store.facturas);
  }

  Future<void> generarNotaCredito({
    required String idFactura,
    required String motivo,
    required double monto,
  }) async =>
      store.generarNotaCredito(idFactura: idFactura, motivo: motivo, monto: monto);

  Future<double> obtenerIngresosMensuales() async {
    store.ensureSeeded();
    return store.obtenerIngresosMensuales();
  }

  Future<double> obtenerValorInventario() async {
    store.ensureSeeded();
    return store.obtenerValorInventario();
  }
}
