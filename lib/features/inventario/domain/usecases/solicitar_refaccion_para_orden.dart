import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/inventario_repository.dart';

/// Regla de Soft Allocation (Sección 5.2 del documento maestro):
/// al aprobarse la cotización de una pieza, el stock no se borra,
/// pero el stock disponible para venta disminuye.
class SolicitarRefaccionParaOrden {
  final InventarioRepository repository;
  const SolicitarRefaccionParaOrden(this.repository);

  Future<Either<Failure, void>> call({
    required String idOrden,
    required String sku,
    required int cantidad,
  }) async {
    if (cantidad <= 0) {
      return const Left(ReglaDeNegocioFailure('La cantidad debe ser mayor a 0.'));
    }

    final refaccionResult = await repository.obtenerPorSku(sku);
    if (refaccionResult.isLeft()) {
      return refaccionResult.fold((f) => Left(f), (r) => throw StateError('unreachable'));
    }

    final refaccion = refaccionResult.getOrElse(() => throw StateError('unreachable'));

    if (refaccion.inactivo) {
      return const Left(ReglaDeNegocioFailure('Esta refacción está dada de baja.'));
    }
    if (refaccion.stockDisponible < cantidad) {
      return Left(ReglaDeNegocioFailure(
        'Stock insuficiente: disponible ${refaccion.stockDisponible}, solicitado $cantidad.',
      ));
    }

    return repository.reservarParaOrden(
      idOrden: idOrden,
      sku: sku,
      cantidad: cantidad,
      precioUnitarioVenta: refaccion.precioVenta,
    );
  }
}
