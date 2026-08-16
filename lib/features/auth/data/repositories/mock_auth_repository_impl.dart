import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/data/mock/mock_auth_datasource.dart';

class MockAuthRepositoryImpl implements AuthRepository {
  final MockAuthDatasource remote;
  const MockAuthRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, Usuario>> iniciarSesion({
    required String email,
    required String password,
  }) async {
    try {
      final usuario = await remote.iniciarSesion(
        email: email,
        password: password,
      );
      return Right(usuario);
    } catch (e) {
      return Left(
        ReglaDeNegocioFailure(e.toString().replaceFirst('Exception: ', '')),
      );
    }
  }

  @override
  Future<Either<Failure, Usuario>> iniciarSesionConGoogle() async {
    try {
      final usuario = await remote.iniciarSesionConGoogle();
      return Right(usuario);
    } catch (e) {
      return Left(
        ReglaDeNegocioFailure(e.toString().replaceFirst('Exception: ', '')),
      );
    }
  }

  @override
  Future<Either<Failure, void>> cerrarSesion() async {
    try {
      await remote.cerrarSesion();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Usuario?> obtenerUsuarioActual() => remote.obtenerUsuarioActual();

  @override
  Stream<Usuario?> observarEstadoAuth() => remote.observarEstadoAuth();
}
