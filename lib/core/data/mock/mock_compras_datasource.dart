import '../../../features/compras/data/datasources/compras_datasource.dart';
import '../../../features/compras/domain/entities/proveedor.dart';
import 'mock_data_store.dart';

class MockComprasDatasource implements ComprasDataSource {
  final MockDataStore store;
  const MockComprasDatasource(this.store);

  @override
  Future<List<Map<String, dynamic>>> listarProveedores() async {
    store.ensureSeeded();
    return store.proveedores
        .map((p) => {
              'id': p.id,
              'nombre': p.nombre,
              'contacto': p.contacto,
              'rfc': p.rfc,
            })
        .toList();
  }

  @override
  Future<Map<String, dynamic>> crearProveedor({
    required String nombre,
    required String contacto,
    String? rfc,
  }) async {
    store.ensureSeeded();
    final prov = Proveedor(
      id: 'prov-${store.proveedores.length + 1}',
      nombre: nombre,
      contacto: contacto,
      rfc: rfc,
    );
    store.proveedores.add(prov);
    return {
      'id': prov.id,
      'nombre': prov.nombre,
      'contacto': prov.contacto,
      'rfc': prov.rfc,
    };
  }

  @override
  Future<void> registrarEntrada({
    required String sku,
    required int cantidad,
    required double costoUnitario,
    required String idProveedor,
  }) async =>
      store.registrarEntrada(
        sku: sku,
        cantidad: cantidad,
        costoUnitario: costoUnitario,
        idProveedor: idProveedor,
      );

  @override
  Future<List<Map<String, dynamic>>> listarEntradas() async {
    store.ensureSeeded();
    return store.entradasInventario
        .map((e) => {
              'id': e.id,
              'sku': e.sku,
              'cantidad': e.cantidad,
              'costo_unitario': e.costoUnitario,
              'id_proveedor': e.idProveedor,
              'fecha': e.fecha.toIso8601String(),
            })
        .toList();
  }
}
