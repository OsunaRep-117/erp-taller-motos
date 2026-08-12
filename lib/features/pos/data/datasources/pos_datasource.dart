import '../../domain/entities/item_carrito.dart';

abstract class PosDataSource {
  Future<List<Map<String, dynamic>>> listarRefaccionesPos();
  Future<String> registrarVenta(List<ItemCarrito> items, {String metodoPago});
  Future<List<Map<String, dynamic>>> listarVentas();
}
