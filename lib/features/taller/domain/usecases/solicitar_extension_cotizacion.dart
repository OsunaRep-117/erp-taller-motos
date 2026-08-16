import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/extension_cotizacion.dart';
import '../repositories/extension_cotizacion_repository.dart';

class SolicitarExtensionCotizacion {
  final ExtensionCotizacionRepository repository;
  const SolicitarExtensionCotizacion(this.repository);

  Future<Either<Failure, ExtensionCotizacion>> call({
    required String idOrden,
    required String descripcion,
    required double montoAdicional,
  }) async {
    if (descripcion.trim().isEmpty) {
      return const Left(
        ReglaDeNegocioFailure('La descripción es obligatoria.'),
      );
    }
    if (montoAdicional <= 0) {
      return const Left(
        ReglaDeNegocioFailure('El monto adicional debe ser mayor a cero.'),
      );
    }
    return repository.solicitar(
      idOrden: idOrden,
      descripcion: descripcion,
      montoAdicional: montoAdicional,
    );
  }
}
