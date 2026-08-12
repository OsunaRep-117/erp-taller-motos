import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class CerrarSesion {
  final AuthRepository repository;
  const CerrarSesion(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.cerrarSesion();
  }
}
