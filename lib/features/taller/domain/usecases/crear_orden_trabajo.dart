import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/orden_trabajo.dart';
import '../repositories/orden_trabajo_repository.dart';
import '../../../crm/domain/repositories/crm_repository.dart';

/// Regla de Evidencia (Sección 5.1 del Documento Maestro):
/// no se puede crear una OT sin al menos 1 fotografía adjunta.
/// Bloqueo por morosidad flotilla (§5.4).
class CrearOrdenTrabajo {
  final OrdenTrabajoRepository repository;
  final CrmRepository crmRepository;

  const CrearOrdenTrabajo(this.repository, this.crmRepository);

  Future<Either<Failure, OrdenTrabajo>> call({
    required String idMoto,
    required String fallaReportada,
    required List<String> fotosEvidencia,
  }) async {
    if (fotosEvidencia.isEmpty) {
      return const Left(
        ReglaDeNegocioFailure(
          'Debes adjuntar al menos una fotografía del estado de la motocicleta antes de crear la orden.',
        ),
      );
    }

    final motoResult = await crmRepository.obtenerMotocicletaPorVin(idMoto);
    final motoEither = await motoResult
        .fold<Future<Either<Failure, OrdenTrabajo>>>((f) async => Left(f), (
          moto,
        ) async {
          final morosoResult = await crmRepository.clienteFlotillaMoroso(
            moto.idCliente,
          );
          return morosoResult.fold(Left.new, (moroso) async {
            if (moroso) {
              return const Left(
                ReglaDeNegocioFailure(
                  'Cliente flotilla con adeudo vencido (>30 días). '
                  'Liquide el saldo pendiente antes de recibir nuevas motocicletas.',
                ),
              );
            }
            return repository.crearOrden(
              idMoto: idMoto,
              fallaReportada: fallaReportada,
              fotosEvidencia: fotosEvidencia,
            );
          });
        });
    return motoEither;
  }
}
