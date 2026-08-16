import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/cita.dart';
import '../repositories/citas_repository.dart';

class AgendarCita {
  final CitasRepository repository;
  const AgendarCita(this.repository);

  Future<Either<Failure, Cita>> call({
    required String idCliente,
    required DateTime fechaCita,
    required String motivo,
    String? idMoto,
  }) {
    if (motivo.trim().isEmpty) {
      return Future.value(
        const Left(
          ReglaDeNegocioFailure('El motivo de la cita es obligatorio.'),
        ),
      );
    }
    return repository.agendarCita(
      idCliente: idCliente,
      fechaCita: fechaCita,
      motivo: motivo,
      idMoto: idMoto,
    );
  }
}
