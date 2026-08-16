import 'package:equatable/equatable.dart';
import 'orden_trabajo.dart';

class EstadoHistorial extends Equatable {
  final String id;
  final String idOrden;
  final EstadoOrdenTrabajo estadoAnterior;
  final EstadoOrdenTrabajo estadoNuevo;
  final DateTime fechaCambio;
  final String? idUsuario;

  const EstadoHistorial({
    required this.id,
    required this.idOrden,
    required this.estadoAnterior,
    required this.estadoNuevo,
    required this.fechaCambio,
    this.idUsuario,
  });

  @override
  List<Object?> get props => [
    id,
    idOrden,
    estadoAnterior,
    estadoNuevo,
    fechaCambio,
    idUsuario,
  ];
}
