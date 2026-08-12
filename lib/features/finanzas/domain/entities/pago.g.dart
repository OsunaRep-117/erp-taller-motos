// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pago.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PagoImpl _$$PagoImplFromJson(Map<String, dynamic> json) => _$PagoImpl(
  id: json['id'] as String,
  idOrden: json['idOrden'] as String,
  monto: (json['monto'] as num).toDouble(),
  metodoPago: $enumDecode(_$MetodoPagoEnumMap, json['metodoPago']),
  idPagoRevertido: json['idPagoRevertido'] as String?,
  fechaPago: DateTime.parse(json['fechaPago'] as String),
);

Map<String, dynamic> _$$PagoImplToJson(_$PagoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idOrden': instance.idOrden,
      'monto': instance.monto,
      'metodoPago': _$MetodoPagoEnumMap[instance.metodoPago]!,
      'idPagoRevertido': instance.idPagoRevertido,
      'fechaPago': instance.fechaPago.toIso8601String(),
    };

const _$MetodoPagoEnumMap = {
  MetodoPago.efectivo: 'efectivo',
  MetodoPago.tarjeta: 'tarjeta',
  MetodoPago.transferencia: 'transferencia',
  MetodoPago.creditoB2B: 'creditoB2B',
};
