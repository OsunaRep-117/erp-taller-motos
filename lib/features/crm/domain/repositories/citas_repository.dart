import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/cita.dart';

abstract class CitasRepository {
  Future<Either<Failure, List<Cita>>> listarCitas();

  Future<Either<Failure, Cita>> agendarCita({
    required String idCliente,
    required DateTime fechaCita,
    required String motivo,
    String? idMoto,
  });

  Future<Either<Failure, Cita>> confirmarCita(String idCita);

  Future<Either<Failure, Cita>> cancelarCita(String idCita);

  Future<Either<Failure, Cita>> completarCita({
    required String idCita,
    required String idMoto,
    required String idOrden,
  });
}
