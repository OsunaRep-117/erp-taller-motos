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
}
