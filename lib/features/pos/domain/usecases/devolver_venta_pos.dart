import 'package:dartz/dartz.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../repositories/pos_repository.dart';

class DevolverVentaPos {
  final PosRepository repository;
  const DevolverVentaPos(this.repository);

  Future<Either<Failure, void>> call({
    required String idVenta,
    required String pinAutorizacion,
    Usuario? usuarioActual,
  }) {
    final autorizado =
        usuarioActual != null &&
        (usuarioActual.esAdmin || usuarioActual.rol == RolEmpleado.supervisor);
    final pinValido = pinAutorizacion == AppConfig.posAutorizacionPin;

    if (!autorizado && !pinValido) {
      return Future.value(
        const Left(
          ReglaDeNegocioFailure('PIN de supervisor inválido o sin permisos.'),
        ),
      );
    }

    return repository.devolverVenta(
      idVenta: idVenta,
      pinAutorizacion: pinAutorizacion,
    );
  }
}
