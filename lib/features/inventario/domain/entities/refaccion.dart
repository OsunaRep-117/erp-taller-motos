import 'package:freezed_annotation/freezed_annotation.dart';

part 'refaccion.freezed.dart';
part 'refaccion.g.dart';

@freezed
abstract class Refaccion with _$Refaccion {
  const Refaccion._();

  const factory Refaccion({
    required String sku,
    required String nombre,
    required double precioCosto,
    required double precioVenta,
    required int stockActual,
    required int stockReservado,
    required int stockMinimo,
    @Default(false) bool inactivo,
  }) = _Refaccion;

  factory Refaccion.fromJson(Map<String, dynamic> json) =>
      _$RefaccionFromJson(json);

  int get stockDisponible => stockActual - stockReservado;
  bool get requiereReorden => stockActual <= stockMinimo;
}
