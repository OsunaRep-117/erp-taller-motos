enum TipoMovimientoInventario {
  entradaCompra,
  salidaVentaPos,
  salidaOt,
  ajuste,
  reserva,
  liberacionReserva,
}

class MovimientoInventario {
  final String id;
  final String sku;
  final TipoMovimientoInventario tipo;
  final int cantidad;
  final double? costoUnitario;
  final String referenciaTipo;
  final String referenciaId;
  final String? idUsuario;
  final DateTime createdAt;

  const MovimientoInventario({
    required this.id,
    required this.sku,
    required this.tipo,
    required this.cantidad,
    required this.referenciaTipo,
    required this.referenciaId,
    required this.createdAt,
    this.costoUnitario,
    this.idUsuario,
  });
}
