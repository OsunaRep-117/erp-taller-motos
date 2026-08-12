import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/usuario.dart';
import '../repositories/auth_repository.dart';

class IniciarSesion {
  final AuthRepository repository;
  const IniciarSesion(this.repository);

  Future<Either<Failure, Usuario>> call({
    required String email,
    required String password,
  }) {
    if (email.trim().isEmpty || password.isEmpty) {
      return Future.value(
        const Left(ReglaDeNegocioFailure('Email y contraseña son obligatorios.')),
      );
    }
    return repository.iniciarSesion(email: email.trim(), password: password);
  }
}
