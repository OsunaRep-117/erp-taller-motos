import 'package:equatable/equatable.dart';

class Comision extends Equatable {
  final String id;
  final String idOrden;
  final String idMecanico;
  final double monto;
  final double porcentajeAplicado;
  final DateTime fechaGenerada;

  const Comision({
    required this.id,
    required this.idOrden,
    required this.idMecanico,
    required this.monto,
    required this.porcentajeAplicado,
    required this.fechaGenerada,
  });

  @override
  List<Object?> get props => [id, idOrden, idMecanico, monto, porcentajeAplicado, fechaGenerada];
}
