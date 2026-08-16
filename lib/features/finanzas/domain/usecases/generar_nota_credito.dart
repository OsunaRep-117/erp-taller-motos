import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/finanzas_repository.dart';

class GenerarNotaCredito {
  final FinanzasRepository repository;
  const GenerarNotaCredito(this.repository);

  Future<Either<Failure, void>> call({
    required String idFactura,
    required String motivo,
    required double monto,
  }) async {
    if (motivo.trim().isEmpty) {
      return const Left(ReglaDeNegocioFailure('El motivo es obligatorio.'));
    }
    if (monto <= 0) {
      return const Left(
        ReglaDeNegocioFailure('El monto debe ser mayor a cero.'),
      );
    }
    return repository.generarNotaCredito(
      idFactura: idFactura,
      motivo: motivo,
      monto: monto,
    );
  }
}
