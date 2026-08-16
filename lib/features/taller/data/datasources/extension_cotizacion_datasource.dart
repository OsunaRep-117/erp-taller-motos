import '../../domain/entities/extension_cotizacion.dart';

abstract class ExtensionCotizacionDataSource {
  Future<List<ExtensionCotizacion>> listarPorOrden(String idOrden);

  Future<ExtensionCotizacion> solicitar({
    required String idOrden,
    required String descripcion,
    required double montoAdicional,
  });

  Future<ExtensionCotizacion> aprobar(String idExtension);
}
