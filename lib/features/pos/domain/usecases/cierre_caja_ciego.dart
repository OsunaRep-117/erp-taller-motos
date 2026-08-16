import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/resultado_cierre_caja.dart';
import '../repositories/pos_repository.dart';

class CierreCajaCiego {
  final PosRepository repository;
  const CierreCajaCiego(this.repository);

  Future<Either<Failure, ResultadoCierreCaja>> call({
    required double efectivoContado,
  }) {
    if (efectivoContado < 0) {
      return Future.value(
        const Left(
          ReglaDeNegocioFailure('El efectivo contado no puede ser negativo.'),
        ),
      );
    }
    return repository.registrarCierreCajaCiego(
      efectivoContado: efectivoContado,
    );
  }
}
