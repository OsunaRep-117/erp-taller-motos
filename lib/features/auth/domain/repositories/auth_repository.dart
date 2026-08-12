import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/usuario.dart';

abstract class AuthRepository {
  Future<Either<Failure, Usuario>> iniciarSesion({
    required String email,
    required String password,
  });

  Future<Either<Failure, Usuario>> iniciarSesionConGoogle();

  Future<Either<Failure, void>> cerrarSesion();

  Future<Usuario?> obtenerUsuarioActual();

  Stream<Usuario?> observarEstadoAuth();
}
