// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cliente.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Cliente _$ClienteFromJson(Map<String, dynamic> json) => _Cliente(
  id: json['id'] as String,
  nombreCompleto: json['nombreCompleto'] as String,
  telefono: json['telefono'] as String,
  rfc: json['rfc'] as String?,
  limiteCredito: (json['limiteCredito'] as num?)?.toDouble() ?? 0,
  esFlotilla: json['esFlotilla'] as bool? ?? false,
);

Map<String, dynamic> _$ClienteToJson(_Cliente instance) => <String, dynamic>{
  'id': instance.id,
  'nombreCompleto': instance.nombreCompleto,
  'telefono': instance.telefono,
  'rfc': instance.rfc,
  'limiteCredito': instance.limiteCredito,
  'esFlotilla': instance.esFlotilla,
};
