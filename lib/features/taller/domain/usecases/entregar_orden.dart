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
    
    return ordenResult.fold(
      (f) => Left(f),
      (orden) async {
        if (orden.estado != EstadoOrdenTrabajo.terminado && orden.estado != EstadoOrdenTrabajo.pagado) {
          return const Left(ReglaDeNegocioFailure('La orden debe estar terminada o pagada para entregarse.'));
        }

        if (orden.saldoPendiente > 0) {
          // Validar crédito si es flotilla
          final motoResult = await crmRepository.obtenerMotocicletaPorVin(orden.idMoto);
          
          return motoResult.fold(
            (f) => Left(f),
            (moto) async {
              final clienteResult = await crmRepository.obtenerClientePorId(moto.idCliente);
              
              return clienteResult.fold(
                (f) => Left(f),
                (cliente) async {
                  if (!cliente.esFlotilla) {
                    return const Left(ReglaDeNegocioFailure('Clientes particulares no pueden retirar vehículos con saldo pendiente.'));
                  }
                  
                  if (orden.saldoPendiente > cliente.limiteCredito) {
                    return const Left(ReglaDeNegocioFailure('El saldo pendiente excede el límite de crédito del cliente flotilla.'));
                  }
                  
                  return repository.marcarComoEntregada(idOrden);
                },
              );
            },
          );
        }

        // Si saldo es 0, entregar directamente
        return repository.marcarComoEntregada(idOrden);
      },
    );
  }
}
