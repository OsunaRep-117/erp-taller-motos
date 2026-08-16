import '../../domain/entities/factura.dart';
import '../../domain/entities/gasto_operativo.dart';
import '../../domain/entities/pago.dart';

abstract class FinanzasDataSource {
  Future<void> registrarPago({
    required String idOrden,
    required double monto,
    required String metodoPago,
  });
  Future<void> revertirPago(String idPago);
  Future<List<Pago>> listarPagosPorOrden(String idOrden);
  Future<List<Pago>> listarTodosLosPagos();
  Future<Factura> emitirFactura({
    required String idOrden,
    required String rfcReceptor,
  });
  Future<List<Factura>> listarFacturas();
  Future<void> generarNotaCredito({
    required String idFactura,
    required String motivo,
    required double monto,
  });
  Future<double> obtenerIngresosMensuales();
  Future<double> obtenerValorInventario();
  Future<GastoOperativo> registrarGastoOperativo({
    required String concepto,
    required double monto,
    String? categoria,
  });
  Future<List<GastoOperativo>> listarGastosOperativos();
  Future<double> obtenerGastosOperativosMes();
}
