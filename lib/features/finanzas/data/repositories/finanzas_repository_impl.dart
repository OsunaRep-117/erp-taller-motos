import 'package:dartz/dartz.dart';
import 'package:postgrest/postgrest.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/factura.dart';
import '../../domain/entities/pago.dart';
import '../../domain/repositories/finanzas_repository.dart';
import '../datasources/finanzas_remote_datasource.dart';

import '../datasources/finanzas_datasource.dart';

class FinanzasRepositoryImpl implements FinanzasRepository {
  final FinanzasDataSource remote;
  const FinanzasRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, void>> registrarPago({
    required String idOrden,
    required double monto,
    required MetodoPago metodoPago,
  }) async {
    try {
      await remote.registrarPago(idOrden: idOrden, monto: monto, metodoPago: metodoPago.name);
      return const Right(null);
    } on PostgrestException catch (e) {
      // El RAISE EXCEPTION de "excede el saldo" cae aquí.
      return Left(ReglaDeNegocioFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> revertirPago(String idPago) async {
    try {
      await remote.revertirPago(idPago);
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Pago>>> listarPagosPorOrden(String idOrden) async {
    try {
      return Right(await remote.listarPagosPorOrden(idOrden));
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Pago>>> listarTodosLosPagos() async {
    try {
      return Right(await remote.listarTodosLosPagos());
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Factura>>> listarFacturas() async {
    try {
      return Right(await remote.listarFacturas());
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Factura>> emitirFactura({
    required String idOrden,
    required String rfcReceptor,
  }) async {
    try {
      return Right(await remote.emitirFactura(idOrden: idOrden, rfcReceptor: rfcReceptor));
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        return const Left(ReglaDeNegocioFailure('Esta orden ya tiene una factura emitida.'));
      }
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> generarNotaCredito({
    required String idFactura,
    required String motivo,
    required double monto,
  }) async {
    try {
      await remote.generarNotaCredito(idFactura: idFactura, motivo: motivo, monto: monto);
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> obtenerIngresosMensuales() async {
    try {
      return Right(await remote.obtenerIngresosMensuales());
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> obtenerValorInventario() async {
    try {
      return Right(await remote.obtenerValorInventario());
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
