import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../auth/domain/entities/usuario.dart';

part 'empleado.freezed.dart';
part 'empleado.g.dart';

@freezed
class Empleado with _$Empleado {
  const factory Empleado({
    required String id,
    required String nombre,
    required String email,
    required RolEmpleado rol,
    @Default(true) bool activo,
    required DateTime fechaContratacion,
  }) = _Empleado;

  factory Empleado.fromJson(Map<String, dynamic> json) => _$EmpleadoFromJson(json);
}
