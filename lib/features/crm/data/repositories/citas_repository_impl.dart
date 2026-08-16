import 'package:dartz/dartz.dart';
import 'package:postgrest/postgrest.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/cita.dart';
import '../../domain/repositories/citas_repository.dart';
import '../datasources/citas_datasource.dart';

class CitasRepositoryImpl implements CitasRepository {
  final CitasDataSource remote;
  const CitasRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<Cita>>> listarCitas() async {
    try {
      return Right(await remote.listarCitas());
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, Cita>> agendarCita({
    required String idCliente,
    required DateTime fechaCita,
    required String motivo,
    String? idMoto,
  }) async {
    try {
      return Right(
        await remote.agendarCita(
          idCliente: idCliente,
          fechaCita: fechaCita,
          motivo: motivo,
          idMoto: idMoto,
        ),
      );
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, Cita>> confirmarCita(String idCita) async {
    try {
      return Right(await remote.confirmarCita(idCita));
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, Cita>> cancelarCita(String idCita) async {
    try {
      return Right(await remote.cancelarCita(idCita));
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, Cita>> completarCita({
    required String idCita,
    required String idMoto,
    required String idOrden,
  }) async {
    try {
      return Right(
        await remote.completarCita(
          idCita: idCita,
          idMoto: idMoto,
          idOrden: idOrden,
        ),
      );
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(_mapException(e));
    }
  }

  Failure _mapException(Object e) {
    final msg = e.toString();
    if (msg.contains('saturado') ||
        msg.contains('obligatorio') ||
        msg.contains('no encontrada')) {
      return ReglaDeNegocioFailure(msg.replaceFirst('Exception: ', ''));
    }
    return ServerFailure(msg);
  }
}
