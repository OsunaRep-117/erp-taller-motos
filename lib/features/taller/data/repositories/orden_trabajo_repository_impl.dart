import 'package:dartz/dartz.dart';
import 'package:postgrest/postgrest.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/estado_historial.dart';
import '../../domain/entities/orden_trabajo.dart';
import '../../domain/repositories/orden_trabajo_repository.dart';
import '../datasources/orden_trabajo_datasource.dart';
import '../models/orden_trabajo_model.dart';

const _kMaxOtEnProcesoPorMecanico = 2;

class OrdenTrabajoRepositoryImpl implements OrdenTrabajoRepository {
  final OrdenTrabajoDataSource remote;
  const OrdenTrabajoRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<OrdenTrabajo>>> obtenerOrdenes() async {
    try {
      return Right(await remote.obtenerOrdenes());
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrdenTrabajo>> obtenerOrdenPorId(String id) async {
    try {
      return Right(await remote.obtenerOrdenPorId(id));
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrdenTrabajo>> crearOrden({
    required String idMoto,
    required String fallaReportada,
    required List<String> fotosEvidencia,
  }) async {
    try {
      final nuevaOrden = OrdenTrabajo(
        id: 'ORD-${DateTime.now().year}-${const Uuid().v4().substring(0, 8)}',
        idMoto: idMoto,
        estado: EstadoOrdenTrabajo.pendiente,
        fallaReportada: fallaReportada,
        fechaCreacion: DateTime.now(),
      );
      return Right(await remote.crearOrden(nuevaOrden));
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrdenTrabajo>> asignarMecanico({
    required String idOrden,
    required String idMecanico,
  }) async {
    try {
      final ordenesEnProceso = await remote.contarOrdenesEnProcesoDeMecanico(idMecanico);
      if (ordenesEnProceso >= _kMaxOtEnProcesoPorMecanico) {
        return const Left(ReglaDeNegocioFailure(
          'Este mecánico ya tiene 2 órdenes en reparación. Debe pausar una antes de asignarle otra.',
        ));
      }
      return Right(await remote.asignarMecanico(idOrden: idOrden, idMecanico: idMecanico));
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrdenTrabajo>> actualizarHorasFacturables({
    required String idOrden,
    required double horas,
  }) async {
    try {
      return Right(await remote.actualizarHorasFacturables(idOrden: idOrden, horas: horas));
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrdenTrabajo>> marcarComoTerminada(String idOrden) async {
    try {
      return Right(await remote.marcarComoTerminada(idOrden));
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrdenTrabajo>> marcarComoEntregada(String idOrden) async {
    try {
      return Right(await remote.marcarComoEntregada(idOrden));
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrdenTrabajo>> cancelarOrden({
    required String idOrden,
    required String motivo,
  }) async {
    try {
      return Right(await remote.cancelarOrden(idOrden, motivo));
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ReglaDeNegocioFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, OrdenTrabajo>> cambiarEstado({
    required String idOrden,
    required EstadoOrdenTrabajo nuevoEstado,
  }) async {
    try {
      return Right(await remote.cambiarEstado(idOrden: idOrden, nuevoEstado: nuevoEstado));
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ReglaDeNegocioFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Stream<List<OrdenTrabajo>> observarOrdenes() => remote.observarOrdenes();

  @override
  Future<Either<Failure, List<EstadoHistorial>>> obtenerHistorial(String idOrden) async {
    try {
      final data = await remote.obtenerHistorial(idOrden);
      return Right(data.map((json) => EstadoHistorial(
            id: json['id'] as String,
            idOrden: json['id_orden'] as String,
            estadoAnterior: json['estado_anterior'] != null
                ? OrdenTrabajoModel.estadoFromString(json['estado_anterior'] as String)
                : EstadoOrdenTrabajo.pendiente,
            estadoNuevo: OrdenTrabajoModel.estadoFromString(json['estado_nuevo'] as String),
            fechaCambio: DateTime.parse(json['fecha_cambio'] as String),
            idUsuario: json['id_usuario'] as String?,
          )).toList());
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
