import '../../domain/entities/orden_trabajo.dart';

/// Traduce entre el snake_case de la tabla ordenes_trabajo en Supabase
/// y la entidad de dominio en camelCase.
class OrdenTrabajoModel {
  static OrdenTrabajo fromJson(Map<String, dynamic> json) {
    return OrdenTrabajo(
      id: json['id'] as String? ?? '',
      idMoto: json['id_moto'] as String? ?? '',
      idMecanico: json['id_mecanico'] as String?,
      estado: estadoFromString(json['estado'] as String? ?? 'pendiente'),
      fallaReportada: json['falla_reportada'] as String? ?? '',
      horasFacturables: (json['horas_facturables'] as num?)?.toDouble() ?? 0,
      saldoPendiente: (json['saldo_pendiente'] as num?)?.toDouble() ?? 0,
      fechaCreacion: json['fecha_creacion'] != null 
          ? DateTime.parse(json['fecha_creacion'] as String) 
          : DateTime.now(),
      fechaInicioReparacion: json['fecha_inicio_reparacion'] != null
          ? DateTime.parse(json['fecha_inicio_reparacion'] as String)
          : null,
      fechaTerminado: json['fecha_terminado'] != null
          ? DateTime.parse(json['fecha_terminado'] as String)
          : null,
    );
  }

  static Map<String, dynamic> toInsertJson(OrdenTrabajo orden) {
    return {
      'id': orden.id,
      'id_moto': orden.idMoto,
      'id_mecanico': orden.idMecanico,
      'estado': _estadoToString(orden.estado),
      'falla_reportada': orden.fallaReportada,
    };
  }

  static EstadoOrdenTrabajo estadoFromString(String value) {
    switch (value) {
      case 'pendiente':
        return EstadoOrdenTrabajo.pendiente;
      case 'en_proceso':
        return EstadoOrdenTrabajo.enProceso;
      case 'esperando_aprobacion':
        return EstadoOrdenTrabajo.esperandoAprobacion;
      case 'esperando_piezas':
        return EstadoOrdenTrabajo.esperandoPiezas;
      case 'terminado':
        return EstadoOrdenTrabajo.terminado;
      case 'pagado':
        return EstadoOrdenTrabajo.pagado;
      case 'entregado':
        return EstadoOrdenTrabajo.entregado;
      case 'cancelada':
        return EstadoOrdenTrabajo.cancelada;
      default:
        return EstadoOrdenTrabajo.pendiente;
    }
  }

  static String _estadoToString(EstadoOrdenTrabajo estado) {
    return estado.name.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (m) => '_${m.group(0)!.toLowerCase()}',
    );
  }
}
