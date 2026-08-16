import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/pago.dart';
import '../repositories/finanzas_repository.dart';

class RegistrarPago {
  final FinanzasRepository repository;
  const RegistrarPago(this.repository);

  Future<Either<Failure, void>> call({
    required String idOrden,
    required double monto,
    required MetodoPago metodoPago,
  }) {
    if (monto <= 0) {
      return Future.value(
        const Left(ReglaDeNegocioFailure('El monto debe ser mayor a 0.')),
      );
    }
    // La validación de "no exceder el saldo pendiente" (Sección 6.9)
    // ocurre en la RPC registrar_pago, porque requiere el saldo actual
    // desde la base de datos, no un valor que el cliente pudiera tener
    // desactualizado.
    return repository.registrarPago(
      idOrden: idOrden,
      monto: monto,
      metodoPago: metodoPago,
    );
  }
}
