import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../entities/extension_cotizacion.dart';
import '../repositories/extension_cotizacion_repository.dart';

class AprobarExtensionCotizacion {
  final ExtensionCotizacionRepository repository;
  const AprobarExtensionCotizacion(this.repository);

  Future<Either<Failure, ExtensionCotizacion>> call({
    required String idExtension,
    required Usuario usuarioActual,
  }) async {
    if (!usuarioActual.esAdmin && usuarioActual.rol != RolEmpleado.supervisor) {
      return const Left(
        ReglaDeNegocioFailure(
          'Sin permisos para aprobar extensiones de cotización.',
        ),
      );
    }
    return repository.aprobar(idExtension);
  }
}
