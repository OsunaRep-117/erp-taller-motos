import 'package:freezed_annotation/freezed_annotation.dart';

part 'motocicleta.freezed.dart';
part 'motocicleta.g.dart';

@freezed
class Motocicleta with _$Motocicleta {
  const factory Motocicleta({
    required String vin,
    required String placa,
    required String marca,
    required String modelo,
    required int anio,
    required String idCliente,
  }) = _Motocicleta;

  factory Motocicleta.fromJson(Map<String, dynamic> json) => _$MotocicletaFromJson(json);
}
