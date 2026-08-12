// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'empleado.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmpleadoImpl _$$EmpleadoImplFromJson(Map<String, dynamic> json) =>
    _$EmpleadoImpl(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      email: json['email'] as String,
      rol: $enumDecode(_$RolEmpleadoEnumMap, json['rol']),
      activo: json['activo'] as bool? ?? true,
      fechaContratacion: DateTime.parse(json['fechaContratacion'] as String),
    );

Map<String, dynamic> _$$EmpleadoImplToJson(_$EmpleadoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'email': instance.email,
      'rol': _$RolEmpleadoEnumMap[instance.rol]!,
      'activo': instance.activo,
      'fechaContratacion': instance.fechaContratacion.toIso8601String(),
    };

const _$RolEmpleadoEnumMap = {
  RolEmpleado.admin: 'admin',
  RolEmpleado.recepcionista: 'recepcionista',
  RolEmpleado.mecanico: 'mecanico',
  RolEmpleado.supervisor: 'supervisor',
};
