import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/orden_trabajo.dart';
import '../repositories/orden_trabajo_repository.dart';

/// Aprueba el presupuesto del cliente y habilita reservas (§5.1 / §5.2).
class AprobarPresupuesto {
  final OrdenTrabajoRepository repository;
  const AprobarPresupuesto(this.repository);

  Future<Either<Failure, OrdenTrabajo>> call(String idOrden) =>
      repository.aprobarPresupuesto(idOrden);
}
