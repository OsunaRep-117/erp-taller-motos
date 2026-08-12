import 'package:dartz/dartz.dart';
import 'package:postgrest/postgrest.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/item_carrito.dart';
import '../../domain/repositories/pos_repository.dart';
import '../datasources/pos_datasource.dart';

class PosRepositoryImpl implements PosRepository {
  final PosDataSource remote;
  const PosRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, String>> registrarVenta(List<ItemCarrito> items, {String metodoPago = 'efectivo'}) async {
    try {
      return Right(await remote.registrarVenta(items, metodoPago: metodoPago));
    } on PostgrestException catch (e) {
      // Aquí llegan tanto "stock insuficiente" como "venta con pérdida"
      // (Sección 5.3), ambas generadas por RAISE EXCEPTION en la RPC.
      return Left(ReglaDeNegocioFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
