import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/orden_trabajo.dart';
import '../repositories/orden_trabajo_repository.dart';

/// Marca la OT como terminada (§5.1 y §5.2).
/// Solo el mecánico asignado puede terminar; inventario y saldo los resuelve el repositorio/RPC.
class TerminarOrden {
  final OrdenTrabajoRepository ordenRepository;

  const TerminarOrden(this.ordenRepository);

  Future<Either<Failure, OrdenTrabajo>> call({
    required String idOrden,
    required String idEmpleadoActual,
  }) async {
    final ordenResult = await ordenRepository.obtenerOrdenPorId(idOrden);
    return ordenResult.fold((f) => Left(f), (orden) async {
      if (orden.idMecanico == null) {
        return const Left(
          ReglaDeNegocioFailure('La orden no tiene mecánico asignado.'),
        );
      }
      if (orden.idMecanico != idEmpleadoActual) {
        return const Left(
          ReglaDeNegocioFailure(
            'Solo el mecánico asignado puede marcar la orden como terminada.',
          ),
        );
      }

      return ordenRepository.marcarComoTerminada(idOrden);
    });
  }
}
