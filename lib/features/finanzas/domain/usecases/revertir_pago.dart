import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../../domain/repositories/finanzas_repository.dart';

class RevertirPago {
  final FinanzasRepository repository;
  const RevertirPago(this.repository);

  Future<Either<Failure, void>> call({
    required String idPago,
    required Usuario usuarioActual,
  }) async {
    if (!usuarioActual.esAdmin && usuarioActual.rol != RolEmpleado.supervisor) {
      return const Left(
        ReglaDeNegocioFailure('Sin permisos para revertir pagos.'),
      );
    }
    return repository.revertirPago(idPago);
  }
}
