import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/item_carrito.dart';
import '../../domain/entities/resultado_cierre_caja.dart';
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

  Future<String> registrarVenta(
    List<ItemCarrito> items, {
    String metodoPago = 'efectivo',
  }) async {
    final userId = client.auth.currentUser!.id;
    final itemsJson = items
        .map(
          (i) => {
            'sku': i.sku,
            'cantidad': i.cantidad,
            'precio_unitario': i.precioUnitario,
          },
        )
        .toList();

    final idVenta = await client.rpc(
      'registrar_venta_mostrador',
      params: {
        'p_items': itemsJson,
        'p_id_usuario': userId,
        'p_metodo_pago': metodoPago,
      },
    );

    return idVenta as String;
  }

  @override
  Future<List<Map<String, dynamic>>> listarVentas() async {
    final data = await client
        .from('ventas_pos')
        .select()
        .order('fecha', ascending: false);
    return (data as List).cast<Map<String, dynamic>>();
  }

  @override
  Future<ResultadoCierreCaja> registrarCierreCajaCiego({
    required double efectivoContado,
  }) async {
    final row = await client.rpc(
      'registrar_cierre_caja_ciego',
      params: {'p_efectivo_contado': efectivoContado},
    );
    final json = row as Map<String, dynamic>;
    return ResultadoCierreCaja(
      id: json['id'] as String,
      efectivoContado: (json['efectivo_contado'] as num).toDouble(),
      efectivoEsperado: (json['efectivo_esperado'] as num).toDouble(),
      diferencia: (json['diferencia'] as num).toDouble(),
      fecha: DateTime.parse(json['created_at'] as String),
    );
  }

  @override
  Future<void> devolverVenta({
    required String idVenta,
    required String pinAutorizacion,
  }) async {
    await client.rpc(
      'devolver_venta_pos',
      params: {'p_id_venta': idVenta, 'p_pin_autorizacion': pinAutorizacion},
    );
  }
}
