import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/config/app_config.dart';

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
abstract class OrdenTrabajo with _$OrdenTrabajo {
  const OrdenTrabajo._();

  const factory OrdenTrabajo({
    required String id,
    required String idMoto,
    String? idMecanico,
    required EstadoOrdenTrabajo estado,
    required String fallaReportada,
    @Default(0) double horasFacturables,
    @Default(2) double horasEstimadas,
    @Default(0) double saldoPendiente,
    required DateTime fechaCreacion,
    DateTime? fechaInicioReparacion,
    DateTime? fechaTerminado,
    DateTime? fechaAprobacionPresupuesto,
  }) = _OrdenTrabajo;

  factory OrdenTrabajo.fromJson(Map<String, dynamic> json) =>
      _$OrdenTrabajoFromJson(json);

  bool get puedeIniciarReparacion =>
      idMecanico != null && estado == EstadoOrdenTrabajo.pendiente;

  bool get puedeComenzarTrabajo =>
      idMecanico != null &&
      (estado == EstadoOrdenTrabajo.pendiente ||
          estado == EstadoOrdenTrabajo.esperandoPiezas);

  bool get puedeRegistrarTrabajo =>
      idMecanico != null &&
      (estado == EstadoOrdenTrabajo.enProceso ||
          estado == EstadoOrdenTrabajo.esperandoAprobacion ||
          estado == EstadoOrdenTrabajo.esperandoPiezas);

  bool perteneceAMecanico(String idMecanicoActual) =>
      idMecanico != null && idMecanico == idMecanicoActual;

  double get manoDeObraCalculada =>
      horasFacturables * AppConfig.tarifaManoObraPorHora;

  double get subtotalRefacciones {
    if (saldoPendiente <= 0) return 0;
    final refacciones = saldoPendiente - manoDeObraCalculada;
    return refacciones > 0 ? refacciones : 0;
  }

  double get totalTrabajo => saldoPendiente > 0
      ? saldoPendiente
      : manoDeObraCalculada + subtotalRefacciones;

  bool get requierePago =>
      saldoPendiente > 0 && estado == EstadoOrdenTrabajo.terminado;

  bool get puedeEntregarseSinCredito =>
      saldoPendiente <= 0 && estado == EstadoOrdenTrabajo.pagado;

  Map<String, double> resumenCierre({
    required double costoRefaccionesReservadas,
    required double costoRefaccionesAdicionales,
    required double horasRealesTrabajadas,
  }) {
    final manoObra = horasRealesTrabajadas * AppConfig.tarifaManoObraPorHora;
    final refacciones =
        costoRefaccionesReservadas + costoRefaccionesAdicionales;
    final total = manoObra + refacciones;

    return {'manoDeObra': manoObra, 'refacciones': refacciones, 'total': total};
  }

  List<String> get bloqueosOperacion {
    final bloqueos = <String>[];

    if (idMecanico == null || idMecanico!.isEmpty) {
      bloqueos.add('Sin mecánico asignado');
    }

    if (!presupuestoAprobado) {
      bloqueos.add('Presupuesto pendiente de aprobación');
    }

    if (estado == EstadoOrdenTrabajo.terminado && saldoPendiente > 0) {
      bloqueos.add('Pago requerido antes de entregar el vehículo');
    }

    if (estado == EstadoOrdenTrabajo.pagado && saldoPendiente > 0) {
      bloqueos.add('Aún existe saldo pendiente por cobrar');
    }

    return bloqueos;
  }

  bool get esInmutable =>
      estado == EstadoOrdenTrabajo.terminado ||
      estado == EstadoOrdenTrabajo.pagado ||
      estado == EstadoOrdenTrabajo.entregado;

  bool get presupuestoAprobado => fechaAprobacionPresupuesto != null;

  /// §5.2 — alerta si duración real supera 150% del tiempo estimado.
  bool get slaExcedido {
    if (fechaInicioReparacion == null ||
        fechaTerminado == null ||
        horasEstimadas <= 0) {
      return false;
    }
    final horasReales =
        fechaTerminado!.difference(fechaInicioReparacion!).inMinutes / 60.0;
    return horasReales > horasEstimadas * 1.5;
  }

  double? get progresoSla {
    if (fechaInicioReparacion == null || horasEstimadas <= 0) return null;
    final horasTranscurridas =
        DateTime.now().difference(fechaInicioReparacion!).inMinutes / 60.0;
    return horasTranscurridas / (horasEstimadas * 1.5);
  }
}
