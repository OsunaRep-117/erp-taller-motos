import '../../../features/taller/data/datasources/extension_cotizacion_datasource.dart';
import '../../../features/taller/domain/entities/extension_cotizacion.dart';
import 'mock_data_store.dart';

class MockExtensionCotizacionDatasource
    implements ExtensionCotizacionDataSource {
  final MockDataStore store;
  const MockExtensionCotizacionDatasource(this.store);

  @override
  Future<List<ExtensionCotizacion>> listarPorOrden(String idOrden) async {
    store.ensureSeeded();
    return store.extensionesCotizacion
        .where((e) => e.idOrden == idOrden)
        .toList();
  }

  @override
  Future<ExtensionCotizacion> solicitar({
    required String idOrden,
    required String descripcion,
    required double montoAdicional,
  }) async => store.solicitarExtensionCotizacion(
    idOrden: idOrden,
    descripcion: descripcion,
    montoAdicional: montoAdicional,
  );

  @override
  Future<ExtensionCotizacion> aprobar(String idExtension) async =>
      store.aprobarExtensionCotizacion(idExtension);
}
