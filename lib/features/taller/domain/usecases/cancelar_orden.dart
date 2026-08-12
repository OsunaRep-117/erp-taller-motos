import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/orden_trabajo.dart';
import '../repositories/orden_trabajo_repository.dart';

class CancelarOrden {
  final OrdenTrabajoRepository repository;
  const CancelarOrden(this.repository);

  Future<Either<Failure, OrdenTrabajo>> call({
    required String idOrden,
    required String motivo,
  }) async {
    if (motivo.trim().isEmpty) {
      return const Left(ReglaDeNegocioFailure('Debes indicar el motivo de cancelación.'));
    }
    return repository.cancelarOrden(idOrden: idOrden, motivo: motivo);
  }
}
