import 'package:dartz/dartz.dart';
import 'package:postgrest/postgrest.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/proveedor.dart';
import '../../domain/repositories/compras_repository.dart';
import '../datasources/compras_datasource.dart';

class ComprasRepositoryImpl implements ComprasRepository {
  final ComprasDataSource remote;
  const ComprasRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<Proveedor>>> listarProveedores() async {
    try {
      final data = await remote.listarProveedores();
      return Right(data.map((json) => Proveedor(
        id: json['id'] as String,
        nombre: json['nombre'] as String,
        contacto: json['contacto'] as String,
        rfc: json['rfc'] as String?,
      )).toList());
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Proveedor>> crearProveedor({
    required String nombre,
    required String contacto,
    String? rfc,
  }) async {
    try {
      final data = await remote.crearProveedor(
        nombre: nombre,
        contacto: contacto,
        rfc: rfc,
      );
      return Right(Proveedor(
        id: data['id'] as String,
        nombre: data['nombre'] as String,
        contacto: data['contacto'] as String,
        rfc: data['rfc'] as String?,
      ));
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> listarEntradas() async {
    try {
      return Right(await remote.listarEntradas());
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> recibirMercancia({
    required String sku,
    required int cantidad,
    required double costoUnitario,
    required String idProveedor,
  }) async {
    try {
      await remote.registrarEntrada(
        sku: sku,
        cantidad: cantidad,
        costoUnitario: costoUnitario,
        idProveedor: idProveedor,
      );
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
