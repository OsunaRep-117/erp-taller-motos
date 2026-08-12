import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/orden_trabajo.dart';
import '../repositories/orden_trabajo_repository.dart';

class CambiarEstadoOrden {
  final OrdenTrabajoRepository repository;
  const CambiarEstadoOrden(this.repository);

  Future<Either<Failure, OrdenTrabajo>> call({
    required String idOrden,
    required EstadoOrdenTrabajo nuevoEstado,
  }) =>
      repository.cambiarEstado(idOrden: idOrden, nuevoEstado: nuevoEstado);
}
