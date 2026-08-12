import 'package:dartz/dartz.dart';
import 'package:postgrest/postgrest.dart';

import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../../domain/entities/comision.dart';
import '../../domain/entities/empleado.dart';
import '../../domain/entities/empleado_invitacion.dart';
import '../../domain/repositories/rrhh_repository.dart';
import '../datasources/rrhh_datasource.dart';

class RrhhRepositoryImpl implements RrhhRepository {
  final RrhhDataSource remote;
  const RrhhRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<Comision>>> listarComisionesDeMecanico(String idMecanico) async {
    try {
      final comisiones = await remote.listarComisionesDeMecanico(idMecanico);
      return Right(comisiones);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Comision>>> listarTodasLasComisiones() async {
    try {
      final todasComisiones = await remote.listarTodasLasComisiones();
      return Right(todasComisiones);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Empleado>>> listarEmpleados() async {
    try {
      final empleados = await remote.listarEmpleados();
      return Right(empleados);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Empleado>> crearEmpleado({
    required String nombre,
    required String email,
    required String rol,
  }) async {
    try {
      final empleado = await remote.crearEmpleado(
        nombre: nombre,
        email: email,
        rol: Usuario.rolFromString(rol),
      );
      return Right(empleado);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ReglaDeNegocioFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> actualizarRolEmpleado(String idEmpleado, String nuevoRol) async {
    try {
      await remote.actualizarRolEmpleado(idEmpleado, nuevoRol);
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> desactivarEmpleado(String idEmpleado) async {
    try {
      await remote.desactivarEmpleado(idEmpleado);
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EmpleadoInvitacion>> invitarEmpleadoGoogle({
    required String nombre,
    required String email,
    required String rol,
    required String invitadoPorId,
  }) async {
    try {
      final inv = await remote.invitarEmpleadoGoogle(
        nombre: nombre,
        email: email,
        rol: Usuario.rolFromString(rol),
        invitadoPorId: invitadoPorId,
      );
      return Right(inv);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ReglaDeNegocioFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, List<EmpleadoInvitacion>>> listarInvitacionesPendientes() async {
    try {
      return Right(await remote.listarInvitacionesPendientes());
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelarInvitacion(String idInvitacion) async {
    try {
      await remote.cancelarInvitacion(idInvitacion);
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
