import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../inventario/domain/usecases/confirmar_salida_inventario.dart';
import '../entities/orden_trabajo.dart';
import '../repositories/orden_trabajo_repository.dart';

/// Orquesta dos pasos que deben ocurrir juntos al terminar la OT
/// (Secciones 5.1 y 5.2 del documento maestro): cambiar el estado y
/// confirmar la salida definitiva de las refacciones reservadas.
/// No hay transacción real entre dos tablas de módulos distintos desde
/// el cliente; si el segundo paso falla, se reporta para reintentar
/// manualmente en vez de dejarlo fallar en silencio.
class TerminarOrden {
  final OrdenTrabajoRepository ordenRepository;
  final ConfirmarSalidaInventario confirmarSalidaInventario;

  const TerminarOrden(this.ordenRepository, this.confirmarSalidaInventario);

  Future<Either<Failure, OrdenTrabajo>> call(String idOrden) async {
    final resultadoInventario = await confirmarSalidaInventario(idOrden);
    if (resultadoInventario.isLeft()) {
      return resultadoInventario.fold(
        (f) => Left(f),
        (_) => throw StateError('unreachable'),
      );
    }

    return ordenRepository.marcarComoTerminada(idOrden);
  }
}
