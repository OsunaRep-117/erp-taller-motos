import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/item_carrito.dart';
import 'pos_datasource.dart';

class PosRemoteDatasource implements PosDataSource {
  final SupabaseClient client;
  const PosRemoteDatasource(this.client);

  /// Usa la vista refacciones_pos (Anexo B, Sección 4), que ya excluye
  /// precio_costo por diseño — el recepcionista nunca lo ve en el POS.
  /// El costo se resuelve del lado del servidor dentro de la RPC de
  /// venta, no se envía desde el cliente.
  Future<List<Map<String, dynamic>>> listarRefaccionesPos() async {
    final data = await client
        .from('refacciones_pos')
        .select()
        .eq('inactivo', false)
        .order('nombre');
    return (data as List).cast<Map<String, dynamic>>();
  }

  Future<String> registrarVenta(List<ItemCarrito> items, {String metodoPago = 'efectivo'}) async {
    final userId = client.auth.currentUser!.id;
    final itemsJson = items
        .map((i) => {
              'sku': i.sku,
              'cantidad': i.cantidad,
              'precio_unitario': i.precioUnitario,
            })
        .toList();

    final idVenta = await client.rpc('registrar_venta_mostrador', params: {
      'p_items': itemsJson,
      'p_id_usuario': userId,
      'p_metodo_pago': metodoPago,
    });

    return idVenta as String;
  }

  @override
  Future<List<Map<String, dynamic>>> listarVentas() async {
    final data = await client.from('ventas_pos').select().order('fecha', ascending: false);
    return (data as List).cast<Map<String, dynamic>>();
  }
}
