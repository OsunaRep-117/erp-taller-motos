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

    return ordenResult.fold<Future<Either<Failure, OrdenTrabajo>>>(
      (f) async => Left(f),
      (orden) async {
        if (orden.saldoPendiente <= 0) {
          return repository.marcarComoEntregada(idOrden);
        }

        final motoResult = await crmRepository.obtenerMotocicletaPorVin(
          orden.idMoto,
        );

        return motoResult.fold<Future<Either<Failure, OrdenTrabajo>>>(
          (f) async => Left(f),
          (moto) async {
            final clienteResult = await crmRepository.obtenerClientePorId(
              moto.idCliente,
            );

            return clienteResult.fold<Future<Either<Failure, OrdenTrabajo>>>(
              (f) async => Left(f),
              (cliente) async {
                if (!cliente.esFlotilla) {
                  return const Left(
                    ReglaDeNegocioFailure(
                      'Clientes particulares no pueden retirar vehículos con saldo pendiente.',
                    ),
                  );
                }

                final exposicionResult =
                    await crmRepository.calcularExposicionCredito(
                  cliente.id,
                );

                return exposicionResult
                    .fold<Future<Either<Failure, OrdenTrabajo>>>(
                  (f) async => Left(f),
                  (exposicion) async {
                    if (exposicion > cliente.limiteCredito) {
                      return const Left(
                        ReglaDeNegocioFailure(
                          'La exposición de crédito del cliente supera su límite disponible.',
                        ),
                      );
                    }
                    return repository.marcarComoEntregada(idOrden);
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}