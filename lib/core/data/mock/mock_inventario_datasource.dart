import '../../../features/inventario/data/datasources/inventario_datasource.dart';
import '../../../features/inventario/domain/entities/refaccion.dart';
import 'mock_data_store.dart';

class MockInventarioDatasource implements InventarioDataSource {
  final MockDataStore store;
  const MockInventarioDatasource(this.store);

  Future<List<Refaccion>> listarRefacciones() async {
    store.ensureSeeded();
    return store.refacciones.where((r) => !r.inactivo).toList();
  }

  Future<Refaccion> obtenerPorSku(String sku) async {
    store.ensureSeeded();
    return store.refacciones.firstWhere((r) => r.sku == sku);
  }

  Future<Refaccion> crearRefaccion({
    required String sku,
    required String nombre,
    required double precioCosto,
    required double precioVenta,
    required int stockMinimo,
  }) async {
    store.ensureSeeded();
    if (store.refacciones.any((r) => r.sku == sku)) {
      throw Exception('Ya existe un producto con este SKU.');
    }
    final ref = Refaccion(
      sku: sku,
      nombre: nombre,
      precioCosto: precioCosto,
      precioVenta: precioVenta,
      stockActual: 0,
      stockReservado: 0,
      stockMinimo: stockMinimo,
    );
    store.refacciones.add(ref);
    return ref;
  }

  Future<void> reservarParaOrden({
    required String idOrden,
    required String sku,
    required int cantidad,
    required double precioUnitarioVenta,
  }) async =>
      store.reservarParaOrden(
        idOrden: idOrden,
        sku: sku,
        cantidad: cantidad,
        precioUnitarioVenta: precioUnitarioVenta,
      );

  Future<void> confirmarSalidaPorOrden(String idOrden) async =>
      store.confirmarSalidaPorOrden(idOrden);

  Future<void> ajustarInventarioManual({
    required String sku,
    required int cantidadAjuste,
    required String justificacion,
  }) async =>
      store.ajustarInventarioManual(
        sku: sku,
        cantidadAjuste: cantidadAjuste,
        justificacion: justificacion,
      );
}
