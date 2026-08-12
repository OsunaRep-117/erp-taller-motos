import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/domain/entities/usuario.dart';
import '../../domain/entities/comision.dart';
import '../../domain/entities/empleado.dart';
import '../../domain/entities/empleado_invitacion.dart';
import 'rrhh_datasource.dart';

class RrhhRemoteDatasource implements RrhhDataSource {
  final SupabaseClient client;
  const RrhhRemoteDatasource(this.client);

  Future<List<Comision>> listarComisionesDeMecanico(String idMecanico) async {
    final data = await client
        .from('comisiones')
        .select()
        .eq('id_mecanico', idMecanico)
        .order('fecha_generada', ascending: false);
    return data.map(_fromJson).toList();
  }

  Future<List<Comision>> listarTodasLasComisiones() async {
    final data = await client.from('comisiones').select().order('fecha_generada', ascending: false);
    return data.map(_fromJson).toList();
  }

  Comision _fromJson(Map<String, dynamic> json) => Comision(
        id: json['id'] as String? ?? '',
        idOrden: json['id_orden'] as String? ?? '',
        idMecanico: json['id_mecanico'] as String? ?? '',
        monto: (json['monto'] as num?)?.toDouble() ?? 0.0,
        porcentajeAplicado: (json['porcentaje_aplicado'] as num?)?.toDouble() ?? 0.0,
        fechaGenerada: json['fecha_generada'] != null 
            ? DateTime.parse(json['fecha_generada'] as String) 
            : DateTime.now(),
      );

  Future<List<Empleado>> listarEmpleados() async {
    final data = await client.from('empleados').select().order('nombre');
    return (data as List).map((e) {
      final id = e['id'] as String? ?? '';
      final nombre = e['nombre'] as String? ?? 'Sin nombre';
      final email = e['email'] as String? ?? 'Sin email';
      final rolStr = e['rol'] as String? ?? 'mecanico';
      final fechaStr = e['fecha_contratacion'] as String?;
      
      return Empleado(
        id: id,
        nombre: nombre,
        email: email,
        rol: Usuario.rolFromString(rolStr),
        activo: e['activo'] as bool? ?? true,
        fechaContratacion: fechaStr != null ? DateTime.parse(fechaStr) : DateTime.now(),
      );
    }).toList();
  }

  @override
  Future<Empleado> crearEmpleado({
    required String nombre,
    required String email,
    required RolEmpleado rol,
  }) async {
    final data = await client.from('empleados').insert({
      'nombre': nombre,
      'email': email,
      'rol': rol.name,
    }).select().single();
    return Empleado(
      id: data['id'] as String,
      nombre: data['nombre'] as String,
      email: data['email'] as String,
      rol: Usuario.rolFromString(data['rol'] as String),
      fechaContratacion: DateTime.parse(data['fecha_contratacion'] as String),
    );
  }

  Future<void> actualizarRolEmpleado(String idEmpleado, String nuevoRol) async {
    await client.from('empleados').update({'rol': nuevoRol}).eq('id', idEmpleado);
  }

  Future<void> desactivarEmpleado(String idEmpleado) async {
    await client.from('empleados').update({'activo': false}).eq('id', idEmpleado);
  }

  @override
  Future<EmpleadoInvitacion> invitarEmpleadoGoogle({
    required String nombre,
    required String email,
    required RolEmpleado rol,
    required String invitadoPorId,
  }) async {
    final data = await client
        .from('empleados_invitados')
        .insert({
          'nombre': nombre,
          'email': email.trim().toLowerCase(),
          'rol': rol.name,
          'invitado_por': invitadoPorId,
        })
        .select()
        .single();
    return _invitacionFromJson(data);
  }

  @override
  Future<List<EmpleadoInvitacion>> listarInvitacionesPendientes() async {
    final data = await client
        .from('empleados_invitados')
        .select()
        .eq('activado', false)
        .order('created_at', ascending: false);
    return (data as List).map((e) => _invitacionFromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> cancelarInvitacion(String idInvitacion) async {
    await client.from('empleados_invitados').delete().eq('id', idInvitacion).eq('activado', false);
  }

  EmpleadoInvitacion _invitacionFromJson(Map<String, dynamic> json) => EmpleadoInvitacion(
        id: json['id'] as String,
        email: json['email'] as String,
        nombre: json['nombre'] as String,
        rol: Usuario.rolFromString(json['rol'] as String),
        creadoEn: DateTime.parse(json['created_at'] as String),
      );
}
