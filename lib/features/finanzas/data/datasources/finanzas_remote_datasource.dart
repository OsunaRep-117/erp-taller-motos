import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/factura.dart';
import '../../domain/entities/gasto_operativo.dart';
import '../../domain/entities/pago.dart';
import 'finanzas_datasource.dart';

class FinanzasRemoteDatasource implements FinanzasDataSource {
  final SupabaseClient client;
  const FinanzasRemoteDatasource(this.client);

  Future<void> registrarPago({
    required String idOrden,
    required double monto,
    required String metodoPago,
  }) async {
    await client.rpc(
      'registrar_pago',
      params: {
        'p_id_orden': idOrden,
        'p_monto': monto,
        'p_metodo_pago': metodoPago,
      },
    );
  }

  Future<void> revertirPago(String idPago) async {
    await client.rpc('revertir_pago', params: {'p_id_pago': idPago});
  }

  Future<List<Pago>> listarPagosPorOrden(String idOrden) async {
    final data = await client
        .from('pagos')
        .select()
        .eq('id_orden', idOrden)
        .order('fecha_pago', ascending: false);
    return data.map(_pagoFromJson).toList();
  }

  @override
  Future<List<Pago>> listarTodosLosPagos() async {
    final data = await client
        .from('pagos')
        .select()
        .order('fecha_pago', ascending: false);
    return data.map(_pagoFromJson).toList();
  }

  Future<Factura> emitirFactura({
    required String idOrden,
    required String rfcReceptor,
  }) async {
    final folio = 'FOLIO-${const Uuid().v4()}';
    final data = await client
        .from('facturas')
        .insert({
          'id_orden': idOrden,
          'folio_fiscal': folio,
          'rfc_receptor': rfcReceptor,
        })
        .select()
        .single();
    return _facturaFromJson(data);
  }

  @override
  Future<List<Factura>> listarFacturas() async {
    final data = await client
        .from('facturas')
        .select()
        .order('fecha_emision', ascending: false);
    return data.map(_facturaFromJson).toList();
  }

  Future<void> generarNotaCredito({
    required String idFactura,
    required String motivo,
    required double monto,
  }) async {
    await client.from('notas_credito').insert({
      'id_factura': idFactura,
      'motivo': motivo,
      'monto': monto,
    });
    await client
        .from('facturas')
        .update({'estado': 'cancelada'})
        .eq('id', idFactura);
  }

  Pago _pagoFromJson(Map<String, dynamic> json) => Pago(
    id: json['id'] as String,
    idOrden: json['id_orden'] as String,
    monto: (json['monto'] as num).toDouble(),
    metodoPago: MetodoPago.values.byName(json['metodo_pago'] as String),
    idPagoRevertido: json['id_pago_revertido'] as String?,
    fechaPago: DateTime.parse(json['fecha_pago'] as String),
  );

  Factura _facturaFromJson(Map<String, dynamic> json) => Factura(
    id: json['id'] as String,
    idOrden: json['id_orden'] as String,
    folioFiscal: json['folio_fiscal'] as String,
    rfcReceptor: json['rfc_receptor'] as String,
    estado: EstadoFactura.values.byName(json['estado'] as String),
    fechaEmision: DateTime.parse(json['fecha_emision'] as String),
  );

  Future<double> obtenerIngresosMensuales() async {
    final mesActual = DateTime.now().month;
    final anioActual = DateTime.now().year;

    // Filtramos pagos no revertidos del mes actual
    final data = await client
        .from('pagos')
        .select('monto')
        .filter('id_pago_revertido', 'is', null)
        .gte(
          'fecha_pago',
          DateTime(anioActual, mesActual, 1).toIso8601String(),
        );

    final total = (data as List).fold<double>(
      0,
      (sum, item) => sum + (item['monto'] as num).toDouble(),
    );
    return total;
  }

  Future<double> obtenerValorInventario() async {
    final data = await client
        .from('refacciones')
        .select('stock_actual, precio_costo')
        .eq('inactivo', false);
    final total = (data as List).fold<double>(
      0,
      (sum, item) =>
          sum +
          ((item['stock_actual'] as num) * (item['precio_costo'] as num))
              .toDouble(),
    );
    return total;
  }

  @override
  Future<GastoOperativo> registrarGastoOperativo({
    required String concepto,
    required double monto,
    String? categoria,
  }) async {
    final id = await client.rpc(
      'registrar_gasto_operativo',
      params: {
        'p_concepto': concepto,
        'p_monto': monto,
        'p_categoria': categoria,
      },
    );
    final data = await client
        .from('gastos_operativos')
        .select()
        .eq('id', id)
        .single();
    return _gastoFromJson(data);
  }

  @override
  Future<List<GastoOperativo>> listarGastosOperativos() async {
    final data = await client
        .from('gastos_operativos')
        .select()
        .order('fecha_gasto', ascending: false);
    return (data as List)
        .map((row) => _gastoFromJson(row as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<double> obtenerGastosOperativosMes() async {
    final mesActual = DateTime.now().month;
    final anioActual = DateTime.now().year;
    final data = await client
        .from('gastos_operativos')
        .select('monto')
        .gte(
          'fecha_gasto',
          DateTime(anioActual, mesActual, 1).toIso8601String(),
        );
    return (data as List).fold<double>(
      0,
      (sum, item) => sum + (item['monto'] as num).toDouble(),
    );
  }

  GastoOperativo _gastoFromJson(Map<String, dynamic> json) => GastoOperativo(
    id: json['id'] as String,
    concepto: json['concepto'] as String,
    categoria: json['categoria'] as String?,
    monto: (json['monto'] as num).toDouble(),
    fechaGasto: DateTime.parse(json['fecha_gasto'] as String),
  );
}
