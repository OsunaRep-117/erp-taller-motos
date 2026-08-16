import 'package:dartz/dartz.dart';
import 'package:postgrest/postgrest.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/item_carrito.dart';
import '../../domain/entities/resultado_cierre_caja.dart';
import '../../domain/repositories/pos_repository.dart';
import '../datasources/pos_datasource.dart';

class PosRepositoryImpl implements PosRepository {
  final PosDataSource remote;
  const PosRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, String>> registrarVenta(
    List<ItemCarrito> items, {
    String metodoPago = 'efectivo',
  }) async {
    try {
      return Right(await remote.registrarVenta(items, metodoPago: metodoPago));
    } on PostgrestException catch (e) {
      return Left(ReglaDeNegocioFailure(e.message));
    } catch (e) {
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, ResultadoCierreCaja>> registrarCierreCajaCiego({
    required double efectivoContado,
  }) async {
    try {
      return Right(
        await remote.registrarCierreCajaCiego(efectivoContado: efectivoContado),
      );
    } on PostgrestException catch (e) {
      return Left(ReglaDeNegocioFailure(e.message));
    } catch (e) {
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, void>> devolverVenta({
    required String idVenta,
    required String pinAutorizacion,
  }) async {
    try {
      await remote.devolverVenta(
        idVenta: idVenta,
        pinAutorizacion: pinAutorizacion,
      );
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ReglaDeNegocioFailure(e.message));
    } catch (e) {
      return Left(_mapException(e));
    }
  }

  Failure _mapException(Object e) {
    final msg = e.toString().replaceFirst('Exception: ', '');
    if (msg.contains('saturado') ||
        msg.contains('devuelta') ||
        msg.contains('PIN') ||
        msg.contains('permisos') ||
        msg.contains('Stock') ||
        msg.contains('costo')) {
      return ReglaDeNegocioFailure(msg);
    }
    return ServerFailure(msg);
  }
}
