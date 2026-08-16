import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/orden_trabajo.dart';
import '../repositories/orden_trabajo_repository.dart';

/// Regla Antifatiga (Sección 5.1 del Documento Maestro):
/// un mecánico no puede tener más de 2 OT en "En Reparación" simultáneamente.
///
/// La validación del conteo real contra la base de datos ocurre en el
/// repositorio/datasource (vía una consulta), porque requiere estado
/// actual del servidor. Aquí se orquesta la llamada y se decide qué
/// hacer con el resultado.
class AsignarMecanico {
  final OrdenTrabajoRepository repository;
  const AsignarMecanico(this.repository);

  Future<Either<Failure, OrdenTrabajo>> call({
    required String idOrden,
    required String idMecanico,
  }) {
    return repository.asignarMecanico(idOrden: idOrden, idMecanico: idMecanico);
  }
}
