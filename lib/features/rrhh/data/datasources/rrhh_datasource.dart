import '../../../auth/domain/entities/usuario.dart';
import '../../domain/entities/comision.dart';
import '../../domain/entities/empleado.dart';
import '../../domain/entities/empleado_invitacion.dart';

abstract class RrhhDataSource {
  Future<List<Comision>> listarComisionesDeMecanico(String idMecanico);
  Future<List<Comision>> listarTodasLasComisiones();
  Future<List<Empleado>> listarEmpleados();
  Future<Empleado> crearEmpleado({
    required String nombre,
    required String email,
    required RolEmpleado rol,
  });
  Future<void> actualizarRolEmpleado(String idEmpleado, String nuevoRol);
  Future<void> desactivarEmpleado(String idEmpleado);

  Future<EmpleadoInvitacion> invitarEmpleadoGoogle({
    required String nombre,
    required String email,
    required RolEmpleado rol,
    required String invitadoPorId,
  });

  Future<List<EmpleadoInvitacion>> listarInvitacionesPendientes();

  Future<void> cancelarInvitacion(String idInvitacion);
}
