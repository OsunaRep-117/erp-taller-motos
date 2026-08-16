import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/usuario.dart';
import '../repositories/auth_repository.dart';

class IniciarSesionConGoogle {
  final AuthRepository repository;
  const IniciarSesionConGoogle(this.repository);

  Future<Either<Failure, Usuario>> call() =>
      repository.iniciarSesionConGoogle();
}
