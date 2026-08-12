import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/comision.dart';
import '../entities/empleado.dart';
import '../entities/empleado_invitacion.dart';

abstract class RrhhRepository {
  /// El cálculo real ocurre en un trigger de base de datos al pagar la
  /// OT (Sección 5.5 del documento maestro); este repositorio solo
  /// consulta lo ya generado, no lo calcula desde el cliente.
  Future<Either<Failure, List<Comision>>> listarComisionesDeMecanico(String idMecanico);

  /// Solo para Admin: vista de productividad de todos los mecánicos.
  Future<Either<Failure, List<Comision>>> listarTodasLasComisiones();

  /// Gestión de personal (Solo Admin)
  Future<Either<Failure, List<Empleado>>> listarEmpleados();

  Future<Either<Failure, Empleado>> crearEmpleado({
    required String nombre,
    required String email,
    required String rol,
  });
  
  Future<Either<Failure, void>> actualizarRolEmpleado(String idEmpleado, String nuevoRol);
  
  Future<Either<Failure, void>> desactivarEmpleado(String idEmpleado);
  
  Future<Either<Failure, EmpleadoInvitacion>> invitarEmpleadoGoogle({
    required String nombre,
    required String email,
    required String rol,
    required String invitadoPorId,
  });

  Future<Either<Failure, List<EmpleadoInvitacion>>> listarInvitacionesPendientes();

  Future<Either<Failure, void>> cancelarInvitacion(String idInvitacion);
}
