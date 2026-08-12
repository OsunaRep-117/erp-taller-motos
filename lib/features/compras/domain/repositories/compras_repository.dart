import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/proveedor.dart';

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
}
