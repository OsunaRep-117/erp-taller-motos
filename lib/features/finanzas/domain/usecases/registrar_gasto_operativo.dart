import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../entities/gasto_operativo.dart';
import '../repositories/finanzas_repository.dart';

class RegistrarGastoOperativo {
  final FinanzasRepository repository;
  const RegistrarGastoOperativo(this.repository);

  Future<Either<Failure, GastoOperativo>> call({
    required Usuario usuarioActual,
    required String concepto,
    required double monto,
    String? categoria,
  }) async {
    if (!usuarioActual.esAdmin && usuarioActual.rol != RolEmpleado.supervisor) {
      return const Left(
        ReglaDeNegocioFailure('Sin permisos para registrar gastos operativos.'),
      );
    }
    if (concepto.trim().isEmpty) {
      return const Left(ReglaDeNegocioFailure('El concepto es obligatorio.'));
    }
    if (monto <= 0) {
      return const Left(
        ReglaDeNegocioFailure('El monto debe ser mayor a cero.'),
      );
    }
    return repository.registrarGastoOperativo(
      concepto: concepto,
      monto: monto,
      categoria: categoria,
    );
  }
}
