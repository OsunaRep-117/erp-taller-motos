import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../entities/orden_trabajo.dart';
import '../repositories/orden_trabajo_repository.dart';

/// Reapertura admin: terminado → en_proceso (§5.1).
class ReabrirOrden {
  final OrdenTrabajoRepository repository;
  const ReabrirOrden(this.repository);

  Future<Either<Failure, OrdenTrabajo>> call({
    required String idOrden,
    required Usuario usuarioActual,
  }) async {
    if (!usuarioActual.esAdmin) {
      return const Left(
        ReglaDeNegocioFailure('Solo un administrador puede reabrir la orden.'),
      );
    }
    return repository.reabrirOrden(idOrden);
  }
}
