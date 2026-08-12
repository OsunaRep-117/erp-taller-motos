import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/refaccion.dart';
import 'inventario_datasource.dart';

class InventarioRemoteDatasource implements InventarioDataSource {
  final SupabaseClient client;
  const InventarioRemoteDatasource(this.client);

  Future<List<Refaccion>> listarRefacciones() async {
    final data = await client
        .from('refacciones')
        .select()
        .eq('inactivo', false)
        .order('nombre');
    return data.map(_fromJson).toList();
  }

  Future<Refaccion> obtenerPorSku(String sku) async {
    final data = await client.from('refacciones').select().eq('sku', sku).single();
    return _fromJson(data);
  }

  Future<Refaccion> crearRefaccion({
    required String sku,
    required String nombre,
    required double precioCosto,
    required double precioVenta,
    required int stockMinimo,
  }) async {
    final data = await client.from('refacciones').insert({
      'sku': sku,
      'nombre': nombre,
      'precio_costo': precioCosto,
      'precio_venta': precioVenta,
      'stock_minimo': stockMinimo,
      'stock_actual': 0,
      'stock_reservado': 0,
    }).select().single();
    return _fromJson(data);
  }

  Future<void> reservarParaOrden({
    required String idOrden,
    required String sku,
    required int cantidad,
    required double precioUnitarioVenta,
  }) async {
    final userId = client.auth.currentUser!.id;
    await client.rpc('reservar_refaccion_para_orden', params: {
      'p_id_orden': idOrden,
      'p_sku': sku,
      'p_cantidad': cantidad,
      'p_precio_unitario': precioUnitarioVenta,
      'p_id_usuario': userId,
    });
  }

  Future<void> confirmarSalidaPorOrden(String idOrden) async {
    final userId = client.auth.currentUser!.id;
    await client.rpc('confirmar_salida_inventario_por_orden', params: {
      'p_id_orden': idOrden,
      'p_id_usuario': userId,
    });
  }

  Future<void> ajustarInventarioManual({
    required String sku,
    required int cantidadAjuste,
    required String justificacion,
  }) async {
    final userId = client.auth.currentUser!.id;
    await client.rpc('ajustar_inventario_manual', params: {
      'p_sku': sku,
      'p_cantidad_ajuste': cantidadAjuste,
      'p_justificacion': justificacion,
      'p_id_usuario': userId,
    });
  }

  Refaccion _fromJson(Map<String, dynamic> json) => Refaccion(
        sku: json['sku'] as String? ?? '',
        nombre: json['nombre'] as String? ?? 'Sin nombre',
        precioCosto: (json['precio_costo'] as num?)?.toDouble() ?? 0.0,
        precioVenta: (json['precio_venta'] as num?)?.toDouble() ?? 0.0,
        stockActual: json['stock_actual'] as int? ?? 0,
        stockReservado: json['stock_reservado'] as int? ?? 0,
        stockMinimo: json['stock_minimo'] as int? ?? 0,
        inactivo: json['inactivo'] as bool? ?? false,
      );
}
