// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cliente.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Cliente {

 String get id; String get nombreCompleto; String get telefono; String? get rfc; double get limiteCredito; bool get esFlotilla;
/// Create a copy of Cliente
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClienteCopyWith<Cliente> get copyWith => _$ClienteCopyWithImpl<Cliente>(this as Cliente, _$identity);

  /// Serializes this Cliente to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Cliente&&(identical(other.id, id) || other.id == id)&&(identical(other.nombreCompleto, nombreCompleto) || other.nombreCompleto == nombreCompleto)&&(identical(other.telefono, telefono) || other.telefono == telefono)&&(identical(other.rfc, rfc) || other.rfc == rfc)&&(identical(other.limiteCredito, limiteCredito) || other.limiteCredito == limiteCredito)&&(identical(other.esFlotilla, esFlotilla) || other.esFlotilla == esFlotilla));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nombreCompleto,telefono,rfc,limiteCredito,esFlotilla);

@override
String toString() {
  return 'Cliente(id: $id, nombreCompleto: $nombreCompleto, telefono: $telefono, rfc: $rfc, limiteCredito: $limiteCredito, esFlotilla: $esFlotilla)';
}


}

/// @nodoc
abstract mixin class $ClienteCopyWith<$Res>  {
  factory $ClienteCopyWith(Cliente value, $Res Function(Cliente) _then) = _$ClienteCopyWithImpl;
@useResult
$Res call({
 String id, String nombreCompleto, String telefono, String? rfc, double limiteCredito, bool esFlotilla
});




}
/// @nodoc
class _$ClienteCopyWithImpl<$Res>
    implements $ClienteCopyWith<$Res> {
  _$ClienteCopyWithImpl(this._self, this._then);

  final Cliente _self;
  final $Res Function(Cliente) _then;

/// Create a copy of Cliente
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nombreCompleto = null,Object? telefono = null,Object? rfc = freezed,Object? limiteCredito = null,Object? esFlotilla = null,}) {
  return _then(Cliente(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nombreCompleto: null == nombreCompleto ? _self.nombreCompleto : nombreCompleto // ignore: cast_nullable_to_non_nullable
as String,telefono: null == telefono ? _self.telefono : telefono // ignore: cast_nullable_to_non_nullable
as String,rfc: freezed == rfc ? _self.rfc : rfc // ignore: cast_nullable_to_non_nullable
as String?,limiteCredito: null == limiteCredito ? _self.limiteCredito : limiteCredito // ignore: cast_nullable_to_non_nullable
as double,esFlotilla: null == esFlotilla ? _self.esFlotilla : esFlotilla // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Cliente].
extension ClientePatterns on Cliente {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Cliente value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Cliente() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Cliente value)  $default,){
final _that = this;
switch (_that) {
case _Cliente():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Cliente value)?  $default,){
final _that = this;
switch (_that) {
case _Cliente() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nombreCompleto,  String telefono,  String? rfc,  double limiteCredito,  bool esFlotilla)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Cliente() when $default != null:
return $default(_that.id,_that.nombreCompleto,_that.telefono,_that.rfc,_that.limiteCredito,_that.esFlotilla);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nombreCompleto,  String telefono,  String? rfc,  double limiteCredito,  bool esFlotilla)  $default,) {final _that = this;
switch (_that) {
case _Cliente():
return $default(_that.id,_that.nombreCompleto,_that.telefono,_that.rfc,_that.limiteCredito,_that.esFlotilla);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nombreCompleto,  String telefono,  String? rfc,  double limiteCredito,  bool esFlotilla)?  $default,) {final _that = this;
switch (_that) {
case _Cliente() when $default != null:
return $default(_that.id,_that.nombreCompleto,_that.telefono,_that.rfc,_that.limiteCredito,_that.esFlotilla);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Cliente extends Cliente {
  const _Cliente({required this.id, required this.nombreCompleto, required this.telefono, this.rfc, this.limiteCredito = 0, this.esFlotilla = false}): super._();
  factory _Cliente.fromJson(Map<String, dynamic> json) => _$ClienteFromJson(json);

@override final  String id;
@override final  String nombreCompleto;
@override final  String telefono;
@override final  String? rfc;
@override@JsonKey() final  double limiteCredito;
@override@JsonKey() final  bool esFlotilla;

/// Create a copy of Cliente
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClienteCopyWith<_Cliente> get copyWith => __$ClienteCopyWithImpl<_Cliente>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClienteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cliente&&(identical(other.id, id) || other.id == id)&&(identical(other.nombreCompleto, nombreCompleto) || other.nombreCompleto == nombreCompleto)&&(identical(other.telefono, telefono) || other.telefono == telefono)&&(identical(other.rfc, rfc) || other.rfc == rfc)&&(identical(other.limiteCredito, limiteCredito) || other.limiteCredito == limiteCredito)&&(identical(other.esFlotilla, esFlotilla) || other.esFlotilla == esFlotilla));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nombreCompleto,telefono,rfc,limiteCredito,esFlotilla);

@override
String toString() {
  return 'Cliente(id: $id, nombreCompleto: $nombreCompleto, telefono: $telefono, rfc: $rfc, limiteCredito: $limiteCredito, esFlotilla: $esFlotilla)';
}


}

/// @nodoc
abstract mixin class _$ClienteCopyWith<$Res> implements $ClienteCopyWith<$Res> {
  factory _$ClienteCopyWith(_Cliente value, $Res Function(_Cliente) _then) = __$ClienteCopyWithImpl;
@override @useResult
$Res call({
 String id, String nombreCompleto, String telefono, String? rfc, double limiteCredito, bool esFlotilla
});




}
/// @nodoc
class __$ClienteCopyWithImpl<$Res>
    implements _$ClienteCopyWith<$Res> {
  __$ClienteCopyWithImpl(this._self, this._then);

  final _Cliente _self;
  final $Res Function(_Cliente) _then;

/// Create a copy of Cliente
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nombreCompleto = null,Object? telefono = null,Object? rfc = freezed,Object? limiteCredito = null,Object? esFlotilla = null,}) {
  return _then(_Cliente(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nombreCompleto: null == nombreCompleto ? _self.nombreCompleto : nombreCompleto // ignore: cast_nullable_to_non_nullable
as String,telefono: null == telefono ? _self.telefono : telefono // ignore: cast_nullable_to_non_nullable
as String,rfc: freezed == rfc ? _self.rfc : rfc // ignore: cast_nullable_to_non_nullable
as String?,limiteCredito: null == limiteCredito ? _self.limiteCredito : limiteCredito // ignore: cast_nullable_to_non_nullable
as double,esFlotilla: null == esFlotilla ? _self.esFlotilla : esFlotilla // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
