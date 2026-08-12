import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/cliente.dart';
import '../repositories/crm_repository.dart';

/// Reglas de negocio (Sección 6.1 del documento maestro):
/// - Teléfono obligatorio.
/// - Si es_flotilla = true, el RFC se vuelve obligatorio.
class CrearCliente {
  final CrmRepository repository;
  const CrearCliente(this.repository);

  Future<Either<Failure, Cliente>> call({
    required String nombreCompleto,
    required String telefono,
    String? rfc,
    bool esFlotilla = false,
  }) {
    if (nombreCompleto.trim().isEmpty) {
      return Future.value(const Left(ReglaDeNegocioFailure('El nombre es obligatorio.')));
    }
    if (telefono.trim().isEmpty) {
      return Future.value(const Left(ReglaDeNegocioFailure('El teléfono es obligatorio.')));
    }
    if (esFlotilla && (rfc == null || rfc.trim().isEmpty)) {
      return Future.value(
        const Left(ReglaDeNegocioFailure('El RFC es obligatorio para clientes de flotilla.')),
      );
    }

    return repository.crearCliente(
      nombreCompleto: nombreCompleto.trim(),
      telefono: telefono.trim(),
      rfc: rfc?.trim(),
      esFlotilla: esFlotilla,
    );
  }
}
