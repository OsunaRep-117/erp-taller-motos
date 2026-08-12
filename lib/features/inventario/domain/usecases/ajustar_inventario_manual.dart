import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../repositories/inventario_repository.dart';

/// Sección 5.2: los ajustes manuales requieren justificación escrita
/// y solo puede ejecutarlos el Administrador.
class AjustarInventarioManual {
  final InventarioRepository repository;
  const AjustarInventarioManual(this.repository);

  Future<Either<Failure, void>> call({
    required Usuario usuarioActual,
    required String sku,
    required int cantidadAjuste,
    required String justificacion,
  }) {
    if (!usuarioActual.esAdmin) {
      return Future.value(
        const Left(ReglaDeNegocioFailure('Solo un administrador puede hacer ajustes de inventario.')),
      );
    }
    if (justificacion.trim().isEmpty) {
      return Future.value(
        const Left(ReglaDeNegocioFailure('Se requiere una justificación para el ajuste.')),
      );
    }
    if (cantidadAjuste == 0) {
      return Future.value(
        const Left(ReglaDeNegocioFailure('La cantidad de ajuste no puede ser cero.')),
      );
    }

    return repository.ajustarInventarioManual(
      sku: sku,
      cantidadAjuste: cantidadAjuste,
      justificacion: justificacion,
    );
  }
}
