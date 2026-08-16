import 'package:freezed_annotation/freezed_annotation.dart';

part 'cliente.freezed.dart';
part 'cliente.g.dart';

@freezed
abstract class Cliente with _$Cliente {
  const Cliente._();

  const factory Cliente({
    required String id,
    required String nombreCompleto,
    required String telefono,
    String? rfc,
    @Default(0) double limiteCredito,
    @Default(false) bool esFlotilla,
  }) = _Cliente;

  factory Cliente.fromJson(Map<String, dynamic> json) =>
      _$ClienteFromJson(json);

  bool get esValido =>
      telefono.trim().isNotEmpty &&
      (!esFlotilla || (rfc?.trim().isNotEmpty ?? false));
}
