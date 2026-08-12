import '../../../features/auth/domain/entities/usuario.dart';
import '../../../features/rrhh/data/datasources/rrhh_datasource.dart';
import '../../../features/rrhh/domain/entities/comision.dart';
import '../../../features/rrhh/domain/entities/empleado.dart';
import '../../../features/rrhh/domain/entities/empleado_invitacion.dart';
import 'mock_data_store.dart';

class MockRrhhDatasource implements RrhhDataSource {
  final MockDataStore store;
  const MockRrhhDatasource(this.store);

  Future<List<Comision>> listarComisionesDeMecanico(String idMecanico) async {
    store.ensureSeeded();
    return store.comisiones.where((c) => c.idMecanico == idMecanico).toList();
  }

  Future<List<Comision>> listarTodasLasComisiones() async {
    store.ensureSeeded();
    return List.from(store.comisiones);
  }

  Future<List<Empleado>> listarEmpleados() async {
    store.ensureSeeded();
    return List.from(store.empleados);
  }

  Future<Empleado> crearEmpleado({
    required String nombre,
    required String email,
    required RolEmpleado rol,
  }) async {
    store.ensureSeeded();
    if (store.empleados.any((e) => e.email.toLowerCase() == email.toLowerCase())) {
      throw Exception('Ya existe un empleado con ese correo.');
    }
    final emp = Empleado(
      id: 'emp-${store.empleados.length + 1}',
      nombre: nombre,
      email: email,
      rol: rol,
      fechaContratacion: DateTime.now(),
    );
    store.empleados.add(emp);
    return emp;
  }

  Future<void> actualizarRolEmpleado(String idEmpleado, String nuevoRol) async {
    final idx = store.empleados.indexWhere((e) => e.id == idEmpleado);
    final emp = store.empleados[idx];
    store.empleados[idx] = emp.copyWith(rol: Usuario.rolFromString(nuevoRol));
  }

  Future<void> desactivarEmpleado(String idEmpleado) async {
    final idx = store.empleados.indexWhere((e) => e.id == idEmpleado);
    final emp = store.empleados[idx];
    store.empleados[idx] = emp.copyWith(activo: false);
  }

  @override
  Future<EmpleadoInvitacion> invitarEmpleadoGoogle({
    required String nombre,
    required String email,
    required RolEmpleado rol,
    required String invitadoPorId,
  }) async {
    final inv = store.invitarEmpleadoGoogle(
      nombre: nombre,
      email: email,
      rol: rol,
      invitadoPorId: invitadoPorId,
    );
    return EmpleadoInvitacion(
      id: inv.id,
      email: inv.email,
      nombre: inv.nombre,
      rol: inv.rol,
      creadoEn: inv.creadoEn,
    );
  }

  @override
  Future<List<EmpleadoInvitacion>> listarInvitacionesPendientes() async {
    store.ensureSeeded();
    return store.invitacionesEmpleados
        .where((i) => !i.activado)
        .map(
          (i) => EmpleadoInvitacion(
            id: i.id,
            email: i.email,
            nombre: i.nombre,
            rol: i.rol,
            creadoEn: i.creadoEn,
          ),
        )
        .toList();
  }

  @override
  Future<void> cancelarInvitacion(String idInvitacion) async {
    store.cancelarInvitacion(idInvitacion);
  }
}
