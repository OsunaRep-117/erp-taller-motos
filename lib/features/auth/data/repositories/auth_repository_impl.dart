import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;
  const AuthRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, Usuario>> iniciarSesion({
    required String email,
    required String password,
  }) async {
    try {
      final usuario = await remote.iniciarSesion(email: email, password: password);
      return Right(usuario);
    } on AuthException catch (e) {
      return Left(ReglaDeNegocioFailure(e.message));
    } catch (e) {
      return Left(ReglaDeNegocioFailure(AuthRemoteDatasource.mensajeAmigable(e)));
    }
  }

  @override
  Future<Either<Failure, Usuario>> iniciarSesionConGoogle() async {
    try {
      final usuario = await remote.iniciarSesionConGoogle();
      return Right(usuario);
    } on GoogleRedirectPending {
      return const Left(
        ReglaDeNegocioFailure('Redirigiendo a Google…'),
      );
    } on AuthException catch (e) {
      return Left(ReglaDeNegocioFailure(e.message));
    } catch (e) {
      return Left(ReglaDeNegocioFailure(AuthRemoteDatasource.mensajeAmigable(e)));
    }
  }

  @override
  Future<Either<Failure, void>> cerrarSesion() async {
    try {
      await remote.cerrarSesion();
      return const Right(null);
    } catch (e) {
      return Left(ReglaDeNegocioFailure(AuthRemoteDatasource.mensajeAmigable(e)));
    }
  }

  @override
  Future<Usuario?> obtenerUsuarioActual() => remote.obtenerUsuarioActual();

  @override
  Stream<Usuario?> observarEstadoAuth() => remote.observarEstadoAuth();
}
