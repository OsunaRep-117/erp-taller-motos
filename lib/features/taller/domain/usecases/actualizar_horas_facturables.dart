import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/orden_trabajo.dart';
import '../repositories/orden_trabajo_repository.dart';

/// Sección 5.1: los campos de mano de obra solo son editables mientras
/// la OT no esté en un estado inmutable (terminado/pagado/entregado).
class ActualizarHorasFacturables {
  final OrdenTrabajoRepository repository;
  const ActualizarHorasFacturables(this.repository);

  Future<Either<Failure, OrdenTrabajo>> call({
    required OrdenTrabajo orden,
    required double horas,
  }) {
    if (orden.esInmutable) {
      return Future.value(
        const Left(
          ReglaDeNegocioFailure(
            'Esta orden ya no admite cambios de mano de obra.',
          ),
        ),
      );
    }
    if (horas < 0) {
      return Future.value(
        const Left(ReglaDeNegocioFailure('Las horas no pueden ser negativas.')),
      );
    }
    return repository.actualizarHorasFacturables(
      idOrden: orden.id,
      horas: horas,
    );
  }
}
