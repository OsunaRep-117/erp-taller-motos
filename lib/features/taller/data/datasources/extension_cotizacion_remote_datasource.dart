import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/extension_cotizacion.dart';
import 'extension_cotizacion_datasource.dart';

class ExtensionCotizacionRemoteDatasource
    implements ExtensionCotizacionDataSource {
  final SupabaseClient client;
  const ExtensionCotizacionRemoteDatasource(this.client);

  @override
  Future<List<ExtensionCotizacion>> listarPorOrden(String idOrden) async {
    final data = await client
        .from('extension_cotizacion')
        .select()
        .eq('id_orden', idOrden)
        .order('fecha_solicitud', ascending: false);
    return (data as List)
        .map((row) => _fromJson(row as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ExtensionCotizacion> solicitar({
    required String idOrden,
    required String descripcion,
    required double montoAdicional,
  }) async {
    final id = await client.rpc(
      'solicitar_extension_cotizacion',
      params: {
        'p_id_orden': idOrden,
        'p_descripcion': descripcion,
        'p_monto_adicional': montoAdicional,
      },
    );
    final data = await client
        .from('extension_cotizacion')
        .select()
        .eq('id', id)
        .single();
    return _fromJson(data);
  }

  @override
  Future<ExtensionCotizacion> aprobar(String idExtension) async {
    await client.rpc(
      'aprobar_extension_cotizacion',
      params: {'p_id_extension': idExtension},
    );
    final data = await client
        .from('extension_cotizacion')
        .select()
        .eq('id', idExtension)
        .single();
    return _fromJson(data);
  }

  ExtensionCotizacion _fromJson(Map<String, dynamic> json) =>
      ExtensionCotizacion(
        id: json['id'] as String,
        idOrden: json['id_orden'] as String,
        descripcion: json['descripcion'] as String,
        montoAdicional: (json['monto_adicional'] as num).toDouble(),
        estado: EstadoExtensionCotizacion.values.byName(
          json['estado'] as String,
        ),
        fechaSolicitud: DateTime.parse(json['fecha_solicitud'] as String),
        utilizada: json['utilizada'] as bool? ?? false,
      );
}
