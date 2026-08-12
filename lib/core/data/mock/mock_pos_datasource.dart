import '../../../features/pos/data/datasources/pos_datasource.dart';
import '../../../features/pos/domain/entities/item_carrito.dart';
import 'mock_data_store.dart';

class MockPosDatasource implements PosDataSource {
  final MockDataStore store;
  const MockPosDatasource(this.store);

  @override
  Future<List<Map<String, dynamic>>> listarRefaccionesPos() async {
    store.ensureSeeded();
    return store.refacciones
        .where((r) => !r.inactivo)
        .map((r) => {
              'sku': r.sku,
              'nombre': r.nombre,
              'precio_venta': r.precioVenta,
              'stock_disponible': r.stockDisponible,
            })
        .toList();
  }

  @override
  Future<String> registrarVenta(List<ItemCarrito> items, {String metodoPago = 'efectivo'}) async {
    final itemsJson = items
        .map((i) => {
              'sku': i.sku,
              'cantidad': i.cantidad,
              'precio_unitario': i.precioUnitario,
            })
        .toList();
    return store.registrarVentaPos(itemsJson, metodoPago: metodoPago);
  }

  @override
  Future<List<Map<String, dynamic>>> listarVentas() async {
    store.ensureSeeded();
    return store.ventasPos
        .map((v) => {
              'id': v.id,
              'fecha': v.fecha.toIso8601String(),
              'id_usuario': v.idUsuario,
              'metodo_pago': v.metodoPago,
              'items': v.items,
              'total': v.items.fold<double>(
                0,
                (s, i) => s + (i['cantidad'] as int) * (i['precio_unitario'] as num).toDouble(),
              ),
            })
        .toList();
  }
}
