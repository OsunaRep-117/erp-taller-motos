import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/cita.dart';
import '../repositories/citas_repository.dart';

class ConfirmarCita {
  final CitasRepository repository;
  const ConfirmarCita(this.repository);

  Future<Either<Failure, Cita>> call(String idCita) =>
      repository.confirmarCita(idCita);
}
