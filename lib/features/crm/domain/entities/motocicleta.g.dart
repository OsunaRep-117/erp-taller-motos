// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motocicleta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MotocicletaImpl _$$MotocicletaImplFromJson(Map<String, dynamic> json) =>
    _$MotocicletaImpl(
      vin: json['vin'] as String,
      placa: json['placa'] as String,
      marca: json['marca'] as String,
      modelo: json['modelo'] as String,
      anio: (json['anio'] as num).toInt(),
      idCliente: json['idCliente'] as String,
    );

Map<String, dynamic> _$$MotocicletaImplToJson(_$MotocicletaImpl instance) =>
    <String, dynamic>{
      'vin': instance.vin,
      'placa': instance.placa,
      'marca': instance.marca,
      'modelo': instance.modelo,
      'anio': instance.anio,
      'idCliente': instance.idCliente,
    };
