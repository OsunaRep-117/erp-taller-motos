import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/motocicleta.dart';
import '../repositories/crm_repository.dart';

/// Regla de negocio (Sección 6.2 del documento maestro): el VIN es
/// inmutable y único; se valida formato mínimo antes de enviar a
/// Supabase (la unicidad real la garantiza la PK de la tabla).
class CrearMotocicleta {
  final CrmRepository repository;
  const CrearMotocicleta(this.repository);

  Future<Either<Failure, Motocicleta>> call({
    required String vin,
    required String placa,
    required String marca,
    required String modelo,
    required int anio,
    required String idCliente,
  }) {
    final vinLimpio = vin.trim().toUpperCase();

    if (vinLimpio.length != 17) {
      return Future.value(
        const Left(ReglaDeNegocioFailure('El VIN debe tener exactamente 17 caracteres.')),
      );
    }
    if (placa.trim().isEmpty) {
      return Future.value(const Left(ReglaDeNegocioFailure('La placa es obligatoria.')));
    }
    final anioActual = DateTime.now().year;
    if (anio < 1980 || anio > anioActual + 1) {
      return Future.value(const Left(ReglaDeNegocioFailure('Año de fabricación inválido.')));
    }

    return repository.crearMotocicleta(
      vin: vinLimpio,
      placa: placa.trim().toUpperCase(),
      marca: marca.trim(),
      modelo: modelo.trim(),
      anio: anio,
      idCliente: idCliente,
    );
  }
}
