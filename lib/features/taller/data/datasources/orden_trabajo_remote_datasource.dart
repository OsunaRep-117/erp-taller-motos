import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/orden_trabajo.dart';
import '../../domain/entities/reserva_refaccion_ot.dart';
import '../models/orden_trabajo_model.dart';
import 'orden_trabajo_datasource.dart';

class OrdenTrabajoRemoteDatasource implements OrdenTrabajoDataSource {
  final SupabaseClient client;
  const OrdenTrabajoRemoteDatasource(this.client);

  static const _tabla = 'ordenes_trabajo';

  Future<List<OrdenTrabajo>> obtenerOrdenes() async {
    final data = await client
        .from(_tabla)
        .select()
        .order('fecha_creacion', ascending: false);
    return (data as List)
        .map((row) => OrdenTrabajoModel.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<OrdenTrabajo> obtenerOrdenPorId(String id) async {
    final data = await client.from(_tabla).select().eq('id', id).single();
    return OrdenTrabajoModel.fromJson(data);
  }

  Future<OrdenTrabajo> crearOrden(OrdenTrabajo orden) async {
    final data = await client
        .from(_tabla)
        .insert(OrdenTrabajoModel.toInsertJson(orden))
        .select()
        .single();
    return OrdenTrabajoModel.fromJson(data);
  }

  Future<int> contarOrdenesEnProcesoDeMecanico(String idMecanico) async {
    final data = await client
        .from(_tabla)
        .select('id')
        .eq('id_mecanico', idMecanico)
        .eq('estado', 'en_proceso');
    return (data as List).length;
  }

  Future<OrdenTrabajo> asignarMecanico({
    required String idOrden,
    required String idMecanico,
  }) async {
    final data = await client
        .from(_tabla)
        .update({'id_mecanico': idMecanico, 'estado': 'en_proceso'})
        .eq('id', idOrden)
        .select()
        .single();
    return OrdenTrabajoModel.fromJson(data);
  }

  Future<OrdenTrabajo> actualizarHorasFacturables({
    required String idOrden,
    required double horas,
  }) async {
    final data = await client
        .from(_tabla)
        .update({'horas_facturables': horas})
        .eq('id', idOrden)
        .select()
        .single();
    return OrdenTrabajoModel.fromJson(data);
  }

  /// Llama a la RPC que calcula saldo_pendiente (refacciones + mano de
  /// obra) y cambia el estado en una sola operación atómica.
  Future<OrdenTrabajo> marcarComoTerminada(String idOrden) async {
    await client.rpc(
      'terminar_orden_calculando_saldo',
      params: {'p_id_orden': idOrden},
    );
    return obtenerOrdenPorId(idOrden);
  }

  Future<OrdenTrabajo> marcarComoEntregada(String idOrden) async {
    final data = await client
        .from(_tabla)
        .update({'estado': 'entregado'})
        .eq('id', idOrden)
        .select()
        .single();
    return OrdenTrabajoModel.fromJson(data);
  }

  @override
  Future<OrdenTrabajo> cancelarOrden(String idOrden, String motivo) async {
    final data = await client
        .from(_tabla)
        .update({'estado': 'cancelada'})
        .eq('id', idOrden)
        .select()
        .single();
    return OrdenTrabajoModel.fromJson(data);
  }

  @override
  Future<OrdenTrabajo> cambiarEstado({
    required String idOrden,
    required EstadoOrdenTrabajo nuevoEstado,
  }) async {
    final estadoDb = _estadoToDb(nuevoEstado);
    final data = await client
        .from(_tabla)
        .update({'estado': estadoDb})
        .eq('id', idOrden)
        .select()
        .single();
    return OrdenTrabajoModel.fromJson(data);
  }

  @override
  Future<OrdenTrabajo> aprobarPresupuesto(String idOrden) async {
    await client.rpc('aprobar_presupuesto', params: {'p_id_orden': idOrden});
    return obtenerOrdenPorId(idOrden);
  }

  @override
  Future<OrdenTrabajo> reabrirOrden(String idOrden) async {
    await client.rpc('reabrir_orden', params: {'p_id_orden': idOrden});
    return obtenerOrdenPorId(idOrden);
  }

  String _estadoToDb(EstadoOrdenTrabajo estado) {
    switch (estado) {
      case EstadoOrdenTrabajo.pendiente:
        return 'pendiente';
      case EstadoOrdenTrabajo.enProceso:
        return 'en_proceso';
      case EstadoOrdenTrabajo.esperandoAprobacion:
        return 'esperando_aprobacion';
      case EstadoOrdenTrabajo.esperandoPiezas:
        return 'esperando_piezas';
      case EstadoOrdenTrabajo.terminado:
        return 'terminado';
      case EstadoOrdenTrabajo.pagado:
        return 'pagado';
      case EstadoOrdenTrabajo.entregado:
        return 'entregado';
      case EstadoOrdenTrabajo.cancelada:
        return 'cancelada';
    }
  }

  Stream<List<OrdenTrabajo>> observarOrdenes() {
    late StreamController<List<OrdenTrabajo>> controller;
    StreamSubscription<List<Map<String, dynamic>>>? realtimeSub;
    Timer? pollTimer;

    Future<void> emitFetch() async {
      try {
        final ordenes = await obtenerOrdenes();
        if (!controller.isClosed) controller.add(ordenes);
      } catch (e, st) {
        if (!controller.isClosed) controller.addError(e, st);
      }
    }

    void startPolling() {
      pollTimer?.cancel();
      pollTimer = Timer.periodic(
        const Duration(seconds: 20),
        (_) => emitFetch(),
      );
    }

    controller = StreamController<List<OrdenTrabajo>>.broadcast(
      onListen: () {
        emitFetch();

        realtimeSub = client
            .from(_tabla)
            .stream(primaryKey: ['id'])
            .listen(
              (rows) {
                if (controller.isClosed) return;
                controller.add(rows.map(OrdenTrabajoModel.fromJson).toList());
              },
              onError: (_, __) {
                realtimeSub?.cancel();
                startPolling();
              },
            );
      },
      onCancel: () async {
        pollTimer?.cancel();
        await realtimeSub?.cancel();
      },
    );

    return controller.stream;
  }

  Future<List<Map<String, dynamic>>> obtenerHistorial(String idOrden) async {
    final data = await client
        .from('historial_estados_ot')
        .select()
        .eq('id_orden', idOrden)
        .order('fecha_cambio', ascending: false);
    return (data as List).cast<Map<String, dynamic>>();
  }

  /// Refacciones reservadas/usadas en una orden, con el nombre resuelto
  /// desde el catálogo para mostrarlas en la UI.
  Future<List<ReservaRefaccionOt>> obtenerRefaccionesReservadas(
    String idOrden,
  ) async {
    final data = await client
        .from('reservas_refaccion_ot')
        .select(
          'id, id_orden, sku, cantidad, precio_unitario, refacciones(nombre)',
        )
        .eq('id_orden', idOrden)
        .order('created_at', ascending: true);

    return (data as List).map((row) {
      final r = row as Map<String, dynamic>;
      final refaccion = r['refacciones'] as Map<String, dynamic>?;
      return ReservaRefaccionOt(
        id: r['id'] as String,
        idOrden: r['id_orden'] as String,
        sku: r['sku'] as String,
        nombreRefaccion: refaccion?['nombre'] as String? ?? r['sku'] as String,
        cantidad: r['cantidad'] as int,
        precioUnitario: (r['precio_unitario'] as num).toDouble(),
      );
    }).toList();
  }
}
