import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../crm/domain/repositories/crm_repository.dart';
import '../entities/orden_trabajo.dart';
import '../repositories/orden_trabajo_repository.dart';

class EntregarOrden {
  final OrdenTrabajoRepository repository;
  final CrmRepository crmRepository;

  const EntregarOrden(this.repository, this.crmRepository);

  Future<Either<Failure, OrdenTrabajo>> call(String idOrden) async {
    final ordenResult = await repository.obtenerOrdenPorId(idOrden);

    return ordenResult.fold((f) => Left(f), (orden) async {
      if (orden.estado != EstadoOrdenTrabajo.pagado) {
        return const Left(
          ReglaDeNegocioFailure(
            'La orden debe estar pagada antes del entrega.',
          ),
        );
      }

      if (orden.saldoPendiente > 0) {
        return const Left(
          ReglaDeNegocioFailure(
            'El saldo pendiente debe quedar en cero para entregar el vehículo.',
          ),
        );
      }

      return repository.marcarComoEntregada(idOrden);
    });
  }
}
