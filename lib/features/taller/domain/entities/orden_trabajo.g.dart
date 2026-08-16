// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orden_trabajo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrdenTrabajo _$OrdenTrabajoFromJson(Map<String, dynamic> json) =>
    _OrdenTrabajo(
      id: json['id'] as String,
      idMoto: json['idMoto'] as String,
      idMecanico: json['idMecanico'] as String?,
      estado: $enumDecode(_$EstadoOrdenTrabajoEnumMap, json['estado']),
      fallaReportada: json['fallaReportada'] as String,
      horasFacturables: (json['horasFacturables'] as num?)?.toDouble() ?? 0,
      horasEstimadas: (json['horasEstimadas'] as num?)?.toDouble() ?? 2,
      saldoPendiente: (json['saldoPendiente'] as num?)?.toDouble() ?? 0,
      fechaCreacion: DateTime.parse(json['fechaCreacion'] as String),
      fechaInicioReparacion: json['fechaInicioReparacion'] == null
          ? null
          : DateTime.parse(json['fechaInicioReparacion'] as String),
      fechaTerminado: json['fechaTerminado'] == null
          ? null
          : DateTime.parse(json['fechaTerminado'] as String),
      fechaAprobacionPresupuesto: json['fechaAprobacionPresupuesto'] == null
          ? null
          : DateTime.parse(json['fechaAprobacionPresupuesto'] as String),
    );

Map<String, dynamic> _$OrdenTrabajoToJson(
  _OrdenTrabajo instance,
) => <String, dynamic>{
  'id': instance.id,
  'idMoto': instance.idMoto,
  'idMecanico': instance.idMecanico,
  'estado': _$EstadoOrdenTrabajoEnumMap[instance.estado]!,
  'fallaReportada': instance.fallaReportada,
  'horasFacturables': instance.horasFacturables,
  'horasEstimadas': instance.horasEstimadas,
  'saldoPendiente': instance.saldoPendiente,
  'fechaCreacion': instance.fechaCreacion.toIso8601String(),
  'fechaInicioReparacion': instance.fechaInicioReparacion?.toIso8601String(),
  'fechaTerminado': instance.fechaTerminado?.toIso8601String(),
  'fechaAprobacionPresupuesto': instance.fechaAprobacionPresupuesto
      ?.toIso8601String(),
};

const _$EstadoOrdenTrabajoEnumMap = {
  EstadoOrdenTrabajo.pendiente: 'pendiente',
  EstadoOrdenTrabajo.enProceso: 'enProceso',
  EstadoOrdenTrabajo.esperandoAprobacion: 'esperandoAprobacion',
  EstadoOrdenTrabajo.esperandoPiezas: 'esperandoPiezas',
  EstadoOrdenTrabajo.terminado: 'terminado',
  EstadoOrdenTrabajo.pagado: 'pagado',
  EstadoOrdenTrabajo.entregado: 'entregado',
  EstadoOrdenTrabajo.cancelada: 'cancelada',
};
