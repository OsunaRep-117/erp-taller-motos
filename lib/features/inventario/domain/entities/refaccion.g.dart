// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refaccion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Refaccion _$RefaccionFromJson(Map<String, dynamic> json) => _Refaccion(
  sku: json['sku'] as String,
  nombre: json['nombre'] as String,
  precioCosto: (json['precioCosto'] as num).toDouble(),
  precioVenta: (json['precioVenta'] as num).toDouble(),
  stockActual: (json['stockActual'] as num).toInt(),
  stockReservado: (json['stockReservado'] as num).toInt(),
  stockMinimo: (json['stockMinimo'] as num).toInt(),
  inactivo: json['inactivo'] as bool? ?? false,
);

Map<String, dynamic> _$RefaccionToJson(_Refaccion instance) =>
    <String, dynamic>{
      'sku': instance.sku,
      'nombre': instance.nombre,
      'precioCosto': instance.precioCosto,
      'precioVenta': instance.precioVenta,
      'stockActual': instance.stockActual,
      'stockReservado': instance.stockReservado,
      'stockMinimo': instance.stockMinimo,
      'inactivo': instance.inactivo,
    };
