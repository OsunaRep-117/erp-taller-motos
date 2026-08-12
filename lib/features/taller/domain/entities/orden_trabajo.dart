import 'package:freezed_annotation/freezed_annotation.dart';

part 'orden_trabajo.freezed.dart';
part 'orden_trabajo.g.dart';

enum EstadoOrdenTrabajo {
  pendiente,
  enProceso,
  esperandoAprobacion,
  esperandoPiezas,
  terminado,
  pagado,
  entregado,
  cancelada,
}

@freezed
class OrdenTrabajo with _$OrdenTrabajo {
  const OrdenTrabajo._();

  const factory OrdenTrabajo({
    required String id,
    required String idMoto,
    String? idMecanico,
    required EstadoOrdenTrabajo estado,
    required String fallaReportada,
    @Default(0) double horasFacturables,
    @Default(0) double saldoPendiente,
    required DateTime fechaCreacion,
    DateTime? fechaInicioReparacion,
    DateTime? fechaTerminado,
  }) = _OrdenTrabajo;

  factory OrdenTrabajo.fromJson(Map<String, dynamic> json) => _$OrdenTrabajoFromJson(json);

  bool get puedeIniciarReparacion =>
      idMecanico != null && estado == EstadoOrdenTrabajo.pendiente;

  bool get puedeEntregarseSinCredito =>
      saldoPendiente <= 0 && estado == EstadoOrdenTrabajo.pagado;

  bool get esInmutable =>
      estado == EstadoOrdenTrabajo.terminado ||
      estado == EstadoOrdenTrabajo.pagado ||
      estado == EstadoOrdenTrabajo.entregado;
}
