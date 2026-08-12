import 'package:freezed_annotation/freezed_annotation.dart';

part 'proveedor.freezed.dart';
part 'proveedor.g.dart';

@freezed
class Proveedor with _$Proveedor {
  const factory Proveedor({
    required String id,
    required String nombre,
    required String contacto,
    String? rfc,
  }) = _Proveedor;

  factory Proveedor.fromJson(Map<String, dynamic> json) => _$ProveedorFromJson(json);
}
