import 'package:equatable/equatable.dart';

enum EstadoFactura { vigente, cancelada }

class Factura extends Equatable {
  final String id;
  final String idOrden;
  final String folioFiscal;
  final String rfcReceptor;
  final EstadoFactura estado;
  final DateTime fechaEmision;

  const Factura({
    required this.id,
    required this.idOrden,
    required this.folioFiscal,
    required this.rfcReceptor,
    required this.estado,
    required this.fechaEmision,
  });

  @override
  List<Object?> get props => [
    id,
    idOrden,
    folioFiscal,
    rfcReceptor,
    estado,
    fechaEmision,
  ];
}
