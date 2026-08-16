enum EstadoOrdenCompra { borrador, aprobada, recibida, cancelada }

class OrdenCompra {
  final String id;
  final String idProveedor;
  final DateTime fechaCreacion;
  final EstadoOrdenCompra estado;
  final double total;

  const OrdenCompra({
    required this.id,
    required this.idProveedor,
    required this.fechaCreacion,
    required this.estado,
    required this.total,
  });
}

class CompraDetalle {
  final String idCompra;
  final String skuRefaccion;
  final int cantidad;
  final double precioCompra;

  const CompraDetalle({
    required this.idCompra,
    required this.skuRefaccion,
    required this.cantidad,
    required this.precioCompra,
  });
}
