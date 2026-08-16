import 'package:equatable/equatable.dart';

/// Regla de negocio (Sección 5.3 del documento maestro): la validación
/// de "no vender con pérdidas" se hace en el servidor (RPC), no aquí.
/// El recepcionista, por diseño (Anexo B, Sección 4), no tiene acceso
/// a precio_costo, así que el cliente no puede ni debe replicar esa
/// validación localmente.
class ItemCarrito extends Equatable {
  final String sku;
  final String nombre;
  final int cantidad;
  final double precioUnitario;

  const ItemCarrito({
    required this.sku,
    required this.nombre,
    required this.cantidad,
    required this.precioUnitario,
  });

  double get subtotal => cantidad * precioUnitario;

  ItemCarrito copyWith({int? cantidad, double? precioUnitario}) => ItemCarrito(
    sku: sku,
    nombre: nombre,
    cantidad: cantidad ?? this.cantidad,
    precioUnitario: precioUnitario ?? this.precioUnitario,
  );

  @override
  List<Object?> get props => [sku, nombre, cantidad, precioUnitario];
}
