import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/motocicleta.dart';
import '../repositories/crm_repository.dart';

class ActualizarMotocicleta {
  final CrmRepository repository;
  const ActualizarMotocicleta(this.repository);

  Future<Either<Failure, Motocicleta>> call({
    required String vin,
    required String placa,
    required String marca,
    required String modelo,
    required int anio,
    required String idCliente,
  }) {
    if (anio < 1980 || anio > DateTime.now().year + 1) {
      return Future.value(
        const Left(ReglaDeNegocioFailure('Año fuera de rango.')),
      );
    }
    return repository.actualizarMotocicleta(
      vin: vin,
      placa: placa.toUpperCase(),
      marca: marca,
      modelo: modelo,
      anio: anio,
      idCliente: idCliente,
    );
  }
}
