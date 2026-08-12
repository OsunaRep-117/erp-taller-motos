import 'package:equatable/equatable.dart';

enum RolEmpleado { admin, recepcionista, mecanico, supervisor }

/// Representa al empleado ya autenticado, combinando su sesión de
/// Supabase Auth con su fila en la tabla empleados (que trae el rol).
class Usuario extends Equatable {
  final String id;
  final String email;
  final String nombre;
  final RolEmpleado rol;

  const Usuario({
    required this.id,
    required this.email,
    required this.nombre,
    required this.rol,
  });

  bool get esAdmin => rol == RolEmpleado.admin;
  bool get esMecanico => rol == RolEmpleado.mecanico;

  static RolEmpleado rolFromString(String value) {
    switch (value) {
      case 'admin':
        return RolEmpleado.admin;
      case 'recepcionista':
        return RolEmpleado.recepcionista;
      case 'mecanico':
        return RolEmpleado.mecanico;
      case 'supervisor':
        return RolEmpleado.supervisor;
      default:
        throw ArgumentError('Rol desconocido: $value');
    }
  }

  @override
  List<Object?> get props => [id, email, nombre, rol];
}
