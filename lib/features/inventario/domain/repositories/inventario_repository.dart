import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/refaccion.dart';

abstract class InventarioRepository {
  Future<Either<Failure, List<Refaccion>>> listarRefacciones();

  Future<Either<Failure, Refaccion>> crearRefaccion({
    required String sku,
    required String nombre,
    required double precioCosto,
    required double precioVenta,
    required int stockMinimo,
  });

  Future<Either<Failure, Refaccion>> obtenerPorSku(String sku);

  Future<Either<Failure, List<Map<String, dynamic>>>> listarReservasPorOrden(
    String idOrden,
  );

  /// Regla Soft Allocation (Sección 5.2): reserva stock para una OT sin
  /// borrarlo físicamente. Falla si no hay stock disponible suficiente.
  Future<Either<Failure, void>> reservarParaOrden({
    required String idOrden,
    required String sku,
    required int cantidad,
    required double precioUnitarioVenta,
  });

  /// Registra el consumo real de refacciones que ya fueron utilizadas en la OT.
  Future<Either<Failure, void>> registrarConsumoParaOrden({
    required String idOrden,
    required String sku,
    required int cantidad,
    required double precioUnitario,
    String? nombre,
  });

  /// Al terminar la OT: descuenta stock_actual y libera stock_reservado
  /// para las refacciones ya usadas en esa orden.
  Future<Either<Failure, void>> confirmarSalidaPorOrden(String idOrden);

  /// Ajuste manual (Sección 5.2): solo Admin, requiere justificación.
  Future<Either<Failure, void>> ajustarInventarioManual({
    required String sku,
    required int cantidadAjuste,
    required String justificacion,
  });
}
