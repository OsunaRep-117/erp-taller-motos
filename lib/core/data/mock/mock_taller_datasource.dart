import 'dart:async';
import 'dart:typed_data';

import '../../../features/taller/data/datasources/orden_trabajo_datasource.dart';
import '../../../features/taller/domain/entities/orden_trabajo.dart';
import '../../../features/taller/domain/entities/reserva_refaccion_ot.dart';
import 'mock_data_store.dart';

class MockOrdenTrabajoDatasource implements OrdenTrabajoDataSource {
  final MockDataStore store;
  const MockOrdenTrabajoDatasource(this.store);

  Future<List<OrdenTrabajo>> obtenerOrdenes() async {
    store.ensureSeeded();
    return List.from(store.ordenes);
  }

  Future<OrdenTrabajo> obtenerOrdenPorId(String id) async {
    store.ensureSeeded();
    return store.ordenes.firstWhere((o) => o.id == id);
  }

  Future<OrdenTrabajo> crearOrden(OrdenTrabajo orden) async {
    return store.crearOrden(
      idMoto: orden.idMoto,
      fallaReportada: orden.fallaReportada,
    );
  }

  Future<int> contarOrdenesEnProcesoDeMecanico(String idMecanico) async =>
      store.contarOrdenesEnProcesoDeMecanico(idMecanico);

  Future<OrdenTrabajo> asignarMecanico({
    required String idOrden,
    required String idMecanico,
  }) async => store.asignarMecanico(idOrden: idOrden, idMecanico: idMecanico);

  Future<OrdenTrabajo> actualizarHorasFacturables({
    required String idOrden,
    required double horas,
  }) async => store.actualizarHoras(idOrden: idOrden, horas: horas);

  Future<OrdenTrabajo> marcarComoTerminada(String idOrden) async =>
      store.marcarComoTerminada(idOrden);

  Future<OrdenTrabajo> marcarComoEntregada(String idOrden) async =>
      store.marcarComoEntregada(idOrden);

  Future<OrdenTrabajo> cancelarOrden(String idOrden, String motivo) async =>
      store.cancelarOrden(idOrden, motivo);

  @override
  Future<OrdenTrabajo> cambiarEstado({
    required String idOrden,
    required EstadoOrdenTrabajo nuevoEstado,
  }) async => store.cambiarEstado(idOrden: idOrden, nuevoEstado: nuevoEstado);

  @override
  Future<OrdenTrabajo> aprobarPresupuesto(String idOrden) async =>
      store.aprobarPresupuesto(idOrden);

  @override
  Future<OrdenTrabajo> reabrirOrden(String idOrden) async =>
      store.reabrirOrden(idOrden);

  Stream<List<OrdenTrabajo>> observarOrdenes() {
    store.ensureSeeded();
    return store.ordenesStream.startWith(store.ordenes);
  }

  Future<List<Map<String, dynamic>>> obtenerHistorial(String idOrden) async {
    store.ensureSeeded();
    return store.historialEstados
        .where((h) => h.idOrden == idOrden)
        .map(
          (h) => {
            'id': h.id,
            'id_orden': h.idOrden,
            'estado_anterior': h.estadoAnterior?.name,
            'estado_nuevo': h.estadoNuevo.name,
            'fecha_cambio': h.fechaCambio.toIso8601String(),
            'id_usuario': h.idUsuario,
          },
        )
        .toList();
  }

  @override
  Future<List<ReservaRefaccionOt>> obtenerRefaccionesReservadas(
    String idOrden,
  ) async {
    store.ensureSeeded();
    final reservas = store.reservasPorOrden[idOrden] ?? [];
    return reservas
        .map(
          (r) => ReservaRefaccionOt(
            id: '$idOrden-${r.sku}',
            idOrden: idOrden,
            sku: r.sku,
            nombreRefaccion: store.refacciones
                .firstWhere(
                  (ref) => ref.sku == r.sku,
                  orElse: () => store.refacciones.first,
                )
                .nombre,
            cantidad: r.cantidad,
            precioUnitario: r.precioUnitario,
          ),
        )
        .toList();
  }
}

class MockEvidenciaOtDatasource {
  final MockDataStore store;
  const MockEvidenciaOtDatasource(this.store);

  Future<String> subirEvidencia({
    required String idOrden,
    required Uint8List bytes,
    required String nombreArchivo,
    required String etapa,
    required String subidaPor,
  }) async => store.subirEvidencia(
    idOrden: idOrden,
    bytes: bytes,
    nombreArchivo: nombreArchivo,
    etapa: etapa,
    subidaPor: subidaPor,
  );

  Future<List<EvidenciaOt>> listarPorOrden(String idOrden) async {
    store.ensureSeeded();
    return store.evidencias.where((e) => e.idOrden == idOrden).toList();
  }
}

extension _StartWith<T> on Stream<T> {
  Stream<T> startWith(T value) async* {
    yield value;
    yield* this;
  }
}
