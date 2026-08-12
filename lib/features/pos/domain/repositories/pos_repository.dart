import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/item_carrito.dart';

abstract class PosRepository {
  /// Registra la venta completa como una sola operación atómica
  /// (Sección 5.3). Devuelve el id de la venta generada.
  Future<Either<Failure, String>> registrarVenta(List<ItemCarrito> items, {String metodoPago = 'efectivo'});
}
