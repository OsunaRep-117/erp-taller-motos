import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/item_carrito.dart';
import '../repositories/pos_repository.dart';

/// Regla de negocio (Sección 5.3 del documento maestro): "el sistema
/// bloquea cualquier venta si el precio final es menor al costo".
/// Esa validación vive en la RPC del servidor (registrar_venta_mostrador),
/// porque el recepcionista no tiene acceso a precio_costo en el cliente
/// (Anexo B, Sección 4) — no hay forma honesta de validarlo aquí antes
/// de enviarlo.
class RegistrarVenta {
  final PosRepository repository;
  const RegistrarVenta(this.repository);

  Future<Either<Failure, String>> call(List<ItemCarrito> items, {String metodoPago = 'efectivo'}) {
    if (items.isEmpty) {
      return Future.value(const Left(ReglaDeNegocioFailure('El carrito está vacío.')));
    }
    return repository.registrarVenta(items, metodoPago: metodoPago);
  }
}
