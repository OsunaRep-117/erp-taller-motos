import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/orden_compra.dart';
import '../repositories/compras_repository.dart';

class CrearOrdenCompra {
  final ComprasRepository repository;
  const CrearOrdenCompra(this.repository);

  Future<Either<Failure, OrdenCompra>> call({
    required String idProveedor,
    required List<CompraDetalle> items,
  }) {
    if (items.isEmpty) {
      return Future.value(
        const Left(
          ReglaDeNegocioFailure('Agrega al menos un ítem a la orden.'),
        ),
      );
    }
    return repository.crearOrdenCompra(idProveedor: idProveedor, items: items);
  }
}

class AprobarOrdenCompra {
  final ComprasRepository repository;
  const AprobarOrdenCompra(this.repository);

  Future<Either<Failure, OrdenCompra>> call(String idCompra) =>
      repository.aprobarOrdenCompra(idCompra);
}

class RecibirOrdenCompra {
  final ComprasRepository repository;
  const RecibirOrdenCompra(this.repository);

  Future<Either<Failure, void>> call(String idCompra) =>
      repository.recibirOrdenCompra(idCompra);
}
