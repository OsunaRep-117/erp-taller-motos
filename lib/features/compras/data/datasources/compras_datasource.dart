abstract class ComprasDataSource {
  Future<List<Map<String, dynamic>>> listarProveedores();
  Future<Map<String, dynamic>> crearProveedor({
    required String nombre,
    required String contacto,
    String? rfc,
  });
  Future<void> registrarEntrada({
    required String sku,
    required int cantidad,
    required double costoUnitario,
    required String idProveedor,
  });
  Future<List<Map<String, dynamic>>> listarEntradas();

  Future<List<Map<String, dynamic>>> listarOrdenesCompra();
  Future<List<Map<String, dynamic>>> detalleOrdenCompra(String idCompra);
  Future<Map<String, dynamic>> crearOrdenCompra({
    required String idProveedor,
    required List<Map<String, dynamic>> items,
  });
  Future<Map<String, dynamic>> aprobarOrdenCompra(String idCompra);
  Future<void> recibirOrdenCompra(String idCompra);
}
