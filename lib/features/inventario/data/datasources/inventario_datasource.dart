import '../../domain/entities/refaccion.dart';

abstract class InventarioDataSource {
  Future<List<Refaccion>> listarRefacciones();
  Future<Refaccion> obtenerPorSku(String sku);
  Future<Refaccion> crearRefaccion({
    required String sku,
    required String nombre,
    required double precioCosto,
    required double precioVenta,
    required int stockMinimo,
  });
  Future<void> reservarParaOrden({
    required String idOrden,
    required String sku,
    required int cantidad,
    required double precioUnitarioVenta,
  });
  Future<void> confirmarSalidaPorOrden(String idOrden);
  Future<void> ajustarInventarioManual({
    required String sku,
    required int cantidadAjuste,
    required String justificacion,
  });
}
