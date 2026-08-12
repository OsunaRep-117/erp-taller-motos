import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/orden_trabajo.dart';
import '../repositories/orden_trabajo_repository.dart';

/// Regla de Evidencia (Sección 5.1 del Documento Maestro):
/// no se puede crear una OT sin al menos 1 fotografía adjunta.
class CrearOrdenTrabajo {
  final OrdenTrabajoRepository repository;
  const CrearOrdenTrabajo(this.repository);

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

    return repository.crearOrden(
      idMoto: idMoto,
      fallaReportada: fallaReportada,
      fotosEvidencia: fotosEvidencia,
    );
  }
}
