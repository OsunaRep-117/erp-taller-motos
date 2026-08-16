// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'empleado.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Empleado {

 String get id; String get nombre; String get email; RolEmpleado get rol; bool get activo; DateTime get fechaContratacion;
/// Create a copy of Empleado
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmpleadoCopyWith<Empleado> get copyWith => _$EmpleadoCopyWithImpl<Empleado>(this as Empleado, _$identity);

  /// Serializes this Empleado to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Empleado&&(identical(other.id, id) || other.id == id)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.email, email) || other.email == email)&&(identical(other.rol, rol) || other.rol == rol)&&(identical(other.activo, activo) || other.activo == activo)&&(identical(other.fechaContratacion, fechaContratacion) || other.fechaContratacion == fechaContratacion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nombre,email,rol,activo,fechaContratacion);

@override
String toString() {
  return 'Empleado(id: $id, nombre: $nombre, email: $email, rol: $rol, activo: $activo, fechaContratacion: $fechaContratacion)';
}


}

/// @nodoc
abstract mixin class $EmpleadoCopyWith<$Res>  {
  factory $EmpleadoCopyWith(Empleado value, $Res Function(Empleado) _then) = _$EmpleadoCopyWithImpl;
@useResult
$Res call({
 String id, String nombre, String email, RolEmpleado rol, bool activo, DateTime fechaContratacion
});




}
/// @nodoc
class _$EmpleadoCopyWithImpl<$Res>
    implements $EmpleadoCopyWith<$Res> {
  _$EmpleadoCopyWithImpl(this._self, this._then);

  final Empleado _self;
  final $Res Function(Empleado) _then;

/// Create a copy of Empleado
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nombre = null,Object? email = null,Object? rol = null,Object? activo = null,Object? fechaContratacion = null,}) {
  return _then(Empleado(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,rol: null == rol ? _self.rol : rol // ignore: cast_nullable_to_non_nullable
as RolEmpleado,activo: null == activo ? _self.activo : activo // ignore: cast_nullable_to_non_nullable
as bool,fechaContratacion: null == fechaContratacion ? _self.fechaContratacion : fechaContratacion // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Empleado].
extension EmpleadoPatterns on Empleado {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Empleado value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Empleado() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Empleado value)  $default,){
final _that = this;
switch (_that) {
case _Empleado():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Empleado value)?  $default,){
final _that = this;
switch (_that) {
case _Empleado() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nombre,  String email,  RolEmpleado rol,  bool activo,  DateTime fechaContratacion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Empleado() when $default != null:
return $default(_that.id,_that.nombre,_that.email,_that.rol,_that.activo,_that.fechaContratacion);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nombre,  String email,  RolEmpleado rol,  bool activo,  DateTime fechaContratacion)  $default,) {final _that = this;
switch (_that) {
case _Empleado():
return $default(_that.id,_that.nombre,_that.email,_that.rol,_that.activo,_that.fechaContratacion);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nombre,  String email,  RolEmpleado rol,  bool activo,  DateTime fechaContratacion)?  $default,) {final _that = this;
switch (_that) {
case _Empleado() when $default != null:
return $default(_that.id,_that.nombre,_that.email,_that.rol,_that.activo,_that.fechaContratacion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Empleado implements Empleado {
  const _Empleado({required this.id, required this.nombre, required this.email, required this.rol, this.activo = true, required this.fechaContratacion});
  factory _Empleado.fromJson(Map<String, dynamic> json) => _$EmpleadoFromJson(json);

@override final  String id;
@override final  String nombre;
@override final  String email;
@override final  RolEmpleado rol;
@override@JsonKey() final  bool activo;
@override final  DateTime fechaContratacion;

/// Create a copy of Empleado
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmpleadoCopyWith<_Empleado> get copyWith => __$EmpleadoCopyWithImpl<_Empleado>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmpleadoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Empleado&&(identical(other.id, id) || other.id == id)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.email, email) || other.email == email)&&(identical(other.rol, rol) || other.rol == rol)&&(identical(other.activo, activo) || other.activo == activo)&&(identical(other.fechaContratacion, fechaContratacion) || other.fechaContratacion == fechaContratacion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nombre,email,rol,activo,fechaContratacion);

@override
String toString() {
  return 'Empleado(id: $id, nombre: $nombre, email: $email, rol: $rol, activo: $activo, fechaContratacion: $fechaContratacion)';
}


}

/// @nodoc
abstract mixin class _$EmpleadoCopyWith<$Res> implements $EmpleadoCopyWith<$Res> {
  factory _$EmpleadoCopyWith(_Empleado value, $Res Function(_Empleado) _then) = __$EmpleadoCopyWithImpl;
@override @useResult
$Res call({
 String id, String nombre, String email, RolEmpleado rol, bool activo, DateTime fechaContratacion
});




}
/// @nodoc
class __$EmpleadoCopyWithImpl<$Res>
    implements _$EmpleadoCopyWith<$Res> {
  __$EmpleadoCopyWithImpl(this._self, this._then);

  final _Empleado _self;
  final $Res Function(_Empleado) _then;

/// Create a copy of Empleado
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nombre = null,Object? email = null,Object? rol = null,Object? activo = null,Object? fechaContratacion = null,}) {
  return _then(_Empleado(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,rol: null == rol ? _self.rol : rol // ignore: cast_nullable_to_non_nullable
as RolEmpleado,activo: null == activo ? _self.activo : activo // ignore: cast_nullable_to_non_nullable
as bool,fechaContratacion: null == fechaContratacion ? _self.fechaContratacion : fechaContratacion // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
