import '../../domain/entities/cita.dart';

class CitaModel {
  static Cita fromJson(Map<String, dynamic> json) {
    return Cita(
      id: json['id'] as String,
      idCliente: json['id_cliente'] as String,
      idMoto: json['id_moto'] as String?,
      idOrden: json['id_orden'] as String?,
      fechaCita: DateTime.parse(json['fecha_cita'] as String),
      motivo: json['motivo'] as String,
      estado: _estadoFromString(json['estado'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static EstadoCita _estadoFromString(String value) {
    switch (value) {
      case 'confirmada':
        return EstadoCita.confirmada;
      case 'cancelada':
        return EstadoCita.cancelada;
      case 'completada':
        return EstadoCita.completada;
      default:
        return EstadoCita.agendada;
    }
  }
}
