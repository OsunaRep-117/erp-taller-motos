import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/cita.dart';
import '../repositories/citas_repository.dart';
import '../../../taller/domain/usecases/crear_orden_trabajo.dart';

/// Marca la cita como completada y la vincula a la OT generada (§6.6).
class CompletarCita {
  final CitasRepository citasRepository;
  final CrearOrdenTrabajo crearOrdenTrabajo;

  const CompletarCita(this.citasRepository, this.crearOrdenTrabajo);

  Future<Either<Failure, Cita>> call({
    required String idCita,
    required String idMoto,
    required String motivo,
    required List<String> fotosEvidencia,
  }) async {
    if (fotosEvidencia.isEmpty) {
      return const Left(
        ReglaDeNegocioFailure(
          'Debes adjuntar al menos una fotografía antes de registrar la llegada.',
        ),
      );
    }

    final ordenResult = await crearOrdenTrabajo(
      idMoto: idMoto,
      fallaReportada: motivo,
      fotosEvidencia: fotosEvidencia,
    );

    return ordenResult.fold(
      Left.new,
      (orden) => citasRepository.completarCita(
        idCita: idCita,
        idMoto: idMoto,
        idOrden: orden.id,
      ),
    );
  }
}
