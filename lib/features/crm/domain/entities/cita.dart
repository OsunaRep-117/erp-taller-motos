enum EstadoCita { agendada, confirmada, cancelada, completada }

class Cita {
  final String id;
  final String idCliente;
  final String? idMoto;
  final String? idOrden;
  final DateTime fechaCita;
  final String motivo;
  final EstadoCita estado;
  final DateTime createdAt;

  const Cita({
    required this.id,
    required this.idCliente,
    this.idMoto,
    this.idOrden,
    required this.fechaCita,
    required this.motivo,
    required this.estado,
    required this.createdAt,
  });

  bool get puedeConfirmar => estado == EstadoCita.agendada;
  bool get puedeCancelar =>
      estado == EstadoCita.agendada || estado == EstadoCita.confirmada;
  bool get puedeCompletar => estado == EstadoCita.confirmada && idOrden == null;
}
