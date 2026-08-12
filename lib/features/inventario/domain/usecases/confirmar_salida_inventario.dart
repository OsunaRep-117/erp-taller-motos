import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/inventario_repository.dart';

/// Al pasar la OT a "Terminado", el stock reservado se convierte en
/// salida definitiva (Sección 5.2 del documento maestro).
class ConfirmarSalidaInventario {
  final InventarioRepository repository;
  const ConfirmarSalidaInventario(this.repository);

  Future<Either<Failure, void>> call(String idOrden) {
    return repository.confirmarSalidaPorOrden(idOrden);
  }
}
