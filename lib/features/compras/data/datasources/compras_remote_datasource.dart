import 'package:supabase_flutter/supabase_flutter.dart';

import 'compras_datasource.dart';

class ComprasRemoteDatasource implements ComprasDataSource {
  final SupabaseClient client;
  const ComprasRemoteDatasource(this.client);

  Future<List<Map<String, dynamic>>> listarProveedores() async {
    final data = await client.from('proveedores').select().order('nombre');
    return (data as List).cast<Map<String, dynamic>>();
  }

  @override
  Future<Map<String, dynamic>> crearProveedor({
    required String nombre,
    required String contacto,
    String? rfc,
  }) async {
    final data = await client
        .from('proveedores')
        .insert({'nombre': nombre, 'contacto': contacto, 'rfc': rfc})
        .select()
        .single();
    return data;
  }

  Future<void> registrarEntrada({
    required String sku,
    required int cantidad,
    required double costoUnitario,
    required String idProveedor,
  }) async {
    // Registrar la entrada en una tabla de auditoría de compras
    await client.from('entradas_inventario').insert({
      'sku': sku,
      'cantidad': cantidad,
      'costo_unitario': costoUnitario,
      'id_proveedor': idProveedor,
    });

    // Incrementar el stock_actual en la tabla refacciones
    // Nota: En un entorno real, esto se haría mediante un trigger en la DB
    // o una RPC para asegurar atomicidad. Aquí simulamos la llamada.
    await client.rpc('incrementar_stock', params: {
      'p_sku': sku,
      'p_cantidad': cantidad,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> listarEntradas() async {
    final data = await client
        .from('entradas_inventario')
        .select()
        .order('fecha', ascending: false);
    return (data as List).cast<Map<String, dynamic>>();
  }
}
