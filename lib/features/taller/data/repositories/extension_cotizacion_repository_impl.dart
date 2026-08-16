import 'package:dartz/dartz.dart';
import 'package:postgrest/postgrest.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/extension_cotizacion.dart';
import '../../domain/repositories/extension_cotizacion_repository.dart';
import '../datasources/extension_cotizacion_datasource.dart';

class ExtensionCotizacionRepositoryImpl
    implements ExtensionCotizacionRepository {
  final ExtensionCotizacionDataSource remote;
  const ExtensionCotizacionRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<ExtensionCotizacion>>> listarPorOrden(
    String idOrden,
  ) async {
    try {
      return Right(await remote.listarPorOrden(idOrden));
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ExtensionCotizacion>> solicitar({
    required String idOrden,
    required String descripcion,
    required double montoAdicional,
  }) async {
    try {
      return Right(
        await remote.solicitar(
          idOrden: idOrden,
          descripcion: descripcion,
          montoAdicional: montoAdicional,
        ),
      );
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ExtensionCotizacion>> aprobar(
    String idExtension,
  ) async {
    try {
      return Right(await remote.aprobar(idExtension));
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
