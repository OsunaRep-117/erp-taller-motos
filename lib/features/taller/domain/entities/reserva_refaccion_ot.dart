/// Una refacción reservada/usada dentro de una orden de trabajo.
class ReservaRefaccionOt {
  final String id;
  final String idOrden;
  final String sku;
  final String nombreRefaccion;
  final int cantidad;
  final double precioUnitario;

  const ReservaRefaccionOt({
    required this.id,
    required this.idOrden,
    required this.sku,
    required this.nombreRefaccion,
    required this.cantidad,
    required this.precioUnitario,
  });

  double get subtotal => cantidad * precioUnitario;
}
