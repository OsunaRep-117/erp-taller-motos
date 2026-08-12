// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'empleado.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Empleado _$EmpleadoFromJson(Map<String, dynamic> json) {
  return _Empleado.fromJson(json);
}

/// @nodoc
mixin _$Empleado {
  String get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  RolEmpleado get rol => throw _privateConstructorUsedError;
  bool get activo => throw _privateConstructorUsedError;
  DateTime get fechaContratacion => throw _privateConstructorUsedError;

  /// Serializes this Empleado to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Empleado
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmpleadoCopyWith<Empleado> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmpleadoCopyWith<$Res> {
  factory $EmpleadoCopyWith(Empleado value, $Res Function(Empleado) then) =
      _$EmpleadoCopyWithImpl<$Res, Empleado>;
  @useResult
  $Res call({
    String id,
    String nombre,
    String email,
    RolEmpleado rol,
    bool activo,
    DateTime fechaContratacion,
  });
}

/// @nodoc
class _$EmpleadoCopyWithImpl<$Res, $Val extends Empleado>
    implements $EmpleadoCopyWith<$Res> {
  _$EmpleadoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Empleado
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? email = null,
    Object? rol = null,
    Object? activo = null,
    Object? fechaContratacion = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            nombre: null == nombre
                ? _value.nombre
                : nombre // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            rol: null == rol
                ? _value.rol
                : rol // ignore: cast_nullable_to_non_nullable
                      as RolEmpleado,
            activo: null == activo
                ? _value.activo
                : activo // ignore: cast_nullable_to_non_nullable
                      as bool,
            fechaContratacion: null == fechaContratacion
                ? _value.fechaContratacion
                : fechaContratacion // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmpleadoImplCopyWith<$Res>
    implements $EmpleadoCopyWith<$Res> {
  factory _$$EmpleadoImplCopyWith(
    _$EmpleadoImpl value,
    $Res Function(_$EmpleadoImpl) then,
  ) = __$$EmpleadoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String nombre,
    String email,
    RolEmpleado rol,
    bool activo,
    DateTime fechaContratacion,
  });
}

/// @nodoc
class __$$EmpleadoImplCopyWithImpl<$Res>
    extends _$EmpleadoCopyWithImpl<$Res, _$EmpleadoImpl>
    implements _$$EmpleadoImplCopyWith<$Res> {
  __$$EmpleadoImplCopyWithImpl(
    _$EmpleadoImpl _value,
    $Res Function(_$EmpleadoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Empleado
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? email = null,
    Object? rol = null,
    Object? activo = null,
    Object? fechaContratacion = null,
  }) {
    return _then(
      _$EmpleadoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        nombre: null == nombre
            ? _value.nombre
            : nombre // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        rol: null == rol
            ? _value.rol
            : rol // ignore: cast_nullable_to_non_nullable
                  as RolEmpleado,
        activo: null == activo
            ? _value.activo
            : activo // ignore: cast_nullable_to_non_nullable
                  as bool,
        fechaContratacion: null == fechaContratacion
            ? _value.fechaContratacion
            : fechaContratacion // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmpleadoImpl implements _Empleado {
  const _$EmpleadoImpl({
    required this.id,
    required this.nombre,
    required this.email,
    required this.rol,
    this.activo = true,
    required this.fechaContratacion,
  });

  factory _$EmpleadoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmpleadoImplFromJson(json);

  @override
  final String id;
  @override
  final String nombre;
  @override
  final String email;
  @override
  final RolEmpleado rol;
  @override
  @JsonKey()
  final bool activo;
  @override
  final DateTime fechaContratacion;

  @override
  String toString() {
    return 'Empleado(id: $id, nombre: $nombre, email: $email, rol: $rol, activo: $activo, fechaContratacion: $fechaContratacion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmpleadoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.rol, rol) || other.rol == rol) &&
            (identical(other.activo, activo) || other.activo == activo) &&
            (identical(other.fechaContratacion, fechaContratacion) ||
                other.fechaContratacion == fechaContratacion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    nombre,
    email,
    rol,
    activo,
    fechaContratacion,
  );

  /// Create a copy of Empleado
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmpleadoImplCopyWith<_$EmpleadoImpl> get copyWith =>
      __$$EmpleadoImplCopyWithImpl<_$EmpleadoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmpleadoImplToJson(this);
  }
}

abstract class _Empleado implements Empleado {
  const factory _Empleado({
    required final String id,
    required final String nombre,
    required final String email,
    required final RolEmpleado rol,
    final bool activo,
    required final DateTime fechaContratacion,
  }) = _$EmpleadoImpl;

  factory _Empleado.fromJson(Map<String, dynamic> json) =
      _$EmpleadoImpl.fromJson;

  @override
  String get id;
  @override
  String get nombre;
  @override
  String get email;
  @override
  RolEmpleado get rol;
  @override
  bool get activo;
  @override
  DateTime get fechaContratacion;

  /// Create a copy of Empleado
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmpleadoImplCopyWith<_$EmpleadoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
