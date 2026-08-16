import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/cita.dart';
import '../repositories/citas_repository.dart';

class CancelarCita {
  final CitasRepository repository;
  const CancelarCita(this.repository);

  Future<Either<Failure, Cita>> call(String idCita) =>
      repository.cancelarCita(idCita);
}
