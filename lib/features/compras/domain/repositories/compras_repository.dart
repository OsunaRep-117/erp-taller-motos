import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/proveedor.dart';
import '../entities/orden_compra.dart';

abstract class ComprasRepository {
  Future<Either<Failure, List<Proveedor>>> listarProveedores();

  Future<Either<Failure, Proveedor>> crearProveedor({
    required String nombre,
    required String contacto,
    String? rfc,
  });

  Future<Either<Failure, List<Map<String, dynamic>>>> listarEntradas();

  Future<Either<Failure, void>> recibirMercancia({
    required String sku,
    required int cantidad,
    required double costoUnitario,
    required String idProveedor,
  });

  Future<Either<Failure, List<OrdenCompra>>> listarOrdenesCompra();

  Future<Either<Failure, List<CompraDetalle>>> obtenerDetalleCompra(
    String idCompra,
  );

  Future<Either<Failure, OrdenCompra>> crearOrdenCompra({
    required String idProveedor,
    required List<CompraDetalle> items,
  });

  Future<Either<Failure, OrdenCompra>> aprobarOrdenCompra(String idCompra);

  Future<Either<Failure, void>> recibirOrdenCompra(String idCompra);
}
