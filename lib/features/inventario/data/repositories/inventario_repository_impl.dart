import 'package:dartz/dartz.dart';
import 'package:postgrest/postgrest.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/refaccion.dart';
import '../../domain/repositories/inventario_repository.dart';
import '../datasources/inventario_remote_datasource.dart';

import '../datasources/inventario_datasource.dart';

class InventarioRepositoryImpl implements InventarioRepository {
  final InventarioDataSource remote;
  const InventarioRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<Refaccion>>> listarRefacciones() async {
    try {
      final data = await remote.listarRefacciones();
      return Right(data);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Refaccion>> obtenerPorSku(String sku) async {
    try {
      final data = await remote.obtenerPorSku(sku);
      return Right(data);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Refaccion>> crearRefaccion({
    required String sku,
    required String nombre,
    required double precioCosto,
    required double precioVenta,
    required int stockMinimo,
  }) async {
    try {
      final data = await remote.crearRefaccion(
        sku: sku,
        nombre: nombre,
        precioCosto: precioCosto,
        precioVenta: precioVenta,
        stockMinimo: stockMinimo,
      );
      return Right(data);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        return const Left(
          ReglaDeNegocioFailure('Ya existe un producto con este SKU.'),
        );
      }
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> listarReservasPorOrden(
    String idOrden,
  ) async {
    try {
      final data = await remote.listarReservasPorOrden(idOrden);
      return Right(data);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> listarConsumosPorOrden(
    String idOrden,
  ) async {
    try {
      final data = await remote.listarConsumosPorOrden(idOrden);
      return Right(data);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> reservarParaOrden({
    required String idOrden,
    required String sku,
    required int cantidad,
    required double precioUnitarioVenta,
  }) async {
    try {
      await remote.reservarParaOrden(
        idOrden: idOrden,
        sku: sku,
        cantidad: cantidad,
        precioUnitarioVenta: precioUnitarioVenta,
      );
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ReglaDeNegocioFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registrarConsumoParaOrden({
    required String idOrden,
    required String sku,
    required int cantidad,
    required double precioUnitario,
    String? nombre,
  }) async {
    try {
      await remote.registrarConsumoParaOrden(
        idOrden: idOrden,
        sku: sku,
        cantidad: cantidad,
        precioUnitario: precioUnitario,
        nombre: nombre,
      );
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> confirmarSalidaPorOrden(String idOrden) async {
    try {
      await remote.confirmarSalidaPorOrden(idOrden);
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> ajustarInventarioManual({
    required String sku,
    required int cantidadAjuste,
    required String justificacion,
  }) async {
    try {
      await remote.ajustarInventarioManual(
        sku: sku,
        cantidadAjuste: cantidadAjuste,
        justificacion: justificacion,
      );
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ReglaDeNegocioFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
