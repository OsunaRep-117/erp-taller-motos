enum EstadoExtensionCotizacion { pendiente, aprobada, rechazada }

class ExtensionCotizacion {
  final String id;
  final String idOrden;
  final String descripcion;
  final double montoAdicional;
  final EstadoExtensionCotizacion estado;
  final DateTime fechaSolicitud;
  final bool utilizada;

  const ExtensionCotizacion({
    required this.id,
    required this.idOrden,
    required this.descripcion,
    required this.montoAdicional,
    required this.estado,
    required this.fechaSolicitud,
    this.utilizada = false,
  });

  ExtensionCotizacion copyWith({
    String? id,
    String? idOrden,
    String? descripcion,
    double? montoAdicional,
    EstadoExtensionCotizacion? estado,
    DateTime? fechaSolicitud,
    bool? utilizada,
  }) {
    return ExtensionCotizacion(
      id: id ?? this.id,
      idOrden: idOrden ?? this.idOrden,
      descripcion: descripcion ?? this.descripcion,
      montoAdicional: montoAdicional ?? this.montoAdicional,
      estado: estado ?? this.estado,
      fechaSolicitud: fechaSolicitud ?? this.fechaSolicitud,
      utilizada: utilizada ?? this.utilizada,
    );
  }
}
