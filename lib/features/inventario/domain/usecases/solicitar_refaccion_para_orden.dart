import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../taller/domain/repositories/orden_trabajo_repository.dart';
import '../repositories/inventario_repository.dart';

/// Regla de Soft Allocation (Sección 5.2): requiere presupuesto aprobado.
class SolicitarRefaccionParaOrden {
  final InventarioRepository inventarioRepository;
  final OrdenTrabajoRepository ordenRepository;

  const SolicitarRefaccionParaOrden(
    this.inventarioRepository,
    this.ordenRepository,
  );

  Future<Either<Failure, void>> call({
    required String idOrden,
    required String sku,
    required int cantidad,
  }) async {
    if (cantidad <= 0) {
      return const Left(
        ReglaDeNegocioFailure('La cantidad debe ser mayor a 0.'),
      );
    }

    final ordenResult = await ordenRepository.obtenerOrdenPorId(idOrden);
    if (ordenResult.isLeft()) {
      return ordenResult.fold(
        (f) => Left(f),
        (_) => throw StateError('unreachable'),
      );
    }
    final orden = ordenResult.getOrElse(() => throw StateError('unreachable'));

    if (!orden.presupuestoAprobado) {
      return const Left(
        ReglaDeNegocioFailure(
          'Debe aprobar el presupuesto antes de reservar refacciones.',
        ),
      );
    }

    final refaccionResult = await inventarioRepository.obtenerPorSku(sku);
    if (refaccionResult.isLeft()) {
      return refaccionResult.fold(
        (f) => Left(f),
        (_) => throw StateError('unreachable'),
      );
    }

    final refaccion = refaccionResult.getOrElse(
      () => throw StateError('unreachable'),
    );

    if (refaccion.inactivo) {
      return const Left(
        ReglaDeNegocioFailure('Esta refacción está dada de baja.'),
      );
    }
    if (refaccion.stockDisponible < cantidad) {
      return Left(
        ReglaDeNegocioFailure(
          'Stock insuficiente: disponible ${refaccion.stockDisponible}, solicitado $cantidad.',
        ),
      );
    }

    return inventarioRepository.reservarParaOrden(
      idOrden: idOrden,
      sku: sku,
      cantidad: cantidad,
      precioUnitarioVenta: refaccion.precioVenta,
    );
  }
}
