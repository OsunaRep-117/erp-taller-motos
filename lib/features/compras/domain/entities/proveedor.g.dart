// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proveedor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProveedorImpl _$$ProveedorImplFromJson(Map<String, dynamic> json) =>
    _$ProveedorImpl(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      contacto: json['contacto'] as String,
      rfc: json['rfc'] as String?,
    );

Map<String, dynamic> _$$ProveedorImplToJson(_$ProveedorImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'contacto': instance.contacto,
      'rfc': instance.rfc,
    };
