import '../../../auth/domain/entities/usuario.dart';

/// Pre-registro para que un usuario entre con Google y reciba su rol en el ERP.
class EmpleadoInvitacion {
  final String id;
  final String email;
  final String nombre;
  final RolEmpleado rol;
  final DateTime creadoEn;

  const EmpleadoInvitacion({
    required this.id,
    required this.email,
    required this.nombre,
    required this.rol,
    required this.creadoEn,
  });
}
