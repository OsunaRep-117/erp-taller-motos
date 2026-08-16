import 'package:freezed_annotation/freezed_annotation.dart';

part 'pago.freezed.dart';
part 'pago.g.dart';

enum MetodoPago { efectivo, tarjeta, transferencia, creditoB2B }

@freezed
abstract class Pago with _$Pago {
  const Pago._();

  const factory Pago({
    required String id,
    required String idOrden,
    required double monto,
    required MetodoPago metodoPago,
    String? idPagoRevertido,
    required DateTime fechaPago,
  }) = _Pago;

  factory Pago.fromJson(Map<String, dynamic> json) => _$PagoFromJson(json);

  bool get esReversion => idPagoRevertido != null;
}
