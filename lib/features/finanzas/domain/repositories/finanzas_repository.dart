import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/factura.dart';
import '../entities/pago.dart';

abstract class FinanzasRepository {
  /// Regla de negocio (Sección 6.9): la suma de pagos no puede superar
  /// el total de la orden. Se valida contra saldo_pendiente en la RPC.
  Future<Either<Failure, void>> registrarPago({
    required String idOrden,
    required double monto,
    required MetodoPago metodoPago,
  });

  /// Sección 6.9: un pago no se elimina, solo se revierte (Anexo B 3.4).
  Future<Either<Failure, void>> revertirPago(String idPago);

  Future<Either<Failure, List<Pago>>> listarPagosPorOrden(String idOrden);

  Future<Either<Failure, List<Pago>>> listarTodosLosPagos();

  Future<Either<Failure, List<Factura>>> listarFacturas();

  /// Sección 6.10: al asociar el folio_fiscal, la orden queda inmutable.
  Future<Either<Failure, Factura>> emitirFactura({
    required String idOrden,
    required String rfcReceptor,
  });

  /// Sección 6.11: revertir una factura exige una Nota de Crédito.
  Future<Either<Failure, void>> generarNotaCredito({
    required String idFactura,
    required String motivo,
    required double monto,
  });

  /// Reportes (Solo Admin)
  Future<Either<Failure, double>> obtenerIngresosMensuales();

  Future<Either<Failure, double>> obtenerValorInventario();
}
