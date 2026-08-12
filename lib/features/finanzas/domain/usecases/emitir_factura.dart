import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../taller/domain/entities/orden_trabajo.dart';
import '../entities/factura.dart';
import '../repositories/finanzas_repository.dart';

/// Regla de negocio (Sección 6.10): solo se emite factura cuando la
/// orden ya no tiene saldo pendiente, y a partir de ahí queda inmutable.
class EmitirFactura {
  final FinanzasRepository repository;
  const EmitirFactura(this.repository);

  Future<Either<Failure, Factura>> call({
    required OrdenTrabajo orden,
    required String rfcReceptor,
  }) {
    if (orden.saldoPendiente > 0) {
      return Future.value(
        const Left(ReglaDeNegocioFailure('No se puede facturar una orden con saldo pendiente.')),
      );
    }
    if (rfcReceptor.trim().isEmpty) {
      return Future.value(const Left(ReglaDeNegocioFailure('El RFC del receptor es obligatorio.')));
    }

    return repository.emitirFactura(idOrden: orden.id, rfcReceptor: rfcReceptor.trim());
  }
}
