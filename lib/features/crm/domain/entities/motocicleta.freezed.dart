// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'motocicleta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Motocicleta {

 String get vin; String get placa; String get marca; String get modelo; int get anio; String get idCliente;
/// Create a copy of Motocicleta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MotocicletaCopyWith<Motocicleta> get copyWith => _$MotocicletaCopyWithImpl<Motocicleta>(this as Motocicleta, _$identity);

  /// Serializes this Motocicleta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Motocicleta&&(identical(other.vin, vin) || other.vin == vin)&&(identical(other.placa, placa) || other.placa == placa)&&(identical(other.marca, marca) || other.marca == marca)&&(identical(other.modelo, modelo) || other.modelo == modelo)&&(identical(other.anio, anio) || other.anio == anio)&&(identical(other.idCliente, idCliente) || other.idCliente == idCliente));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vin,placa,marca,modelo,anio,idCliente);

@override
String toString() {
  return 'Motocicleta(vin: $vin, placa: $placa, marca: $marca, modelo: $modelo, anio: $anio, idCliente: $idCliente)';
}


}

/// @nodoc
abstract mixin class $MotocicletaCopyWith<$Res>  {
  factory $MotocicletaCopyWith(Motocicleta value, $Res Function(Motocicleta) _then) = _$MotocicletaCopyWithImpl;
@useResult
$Res call({
 String vin, String placa, String marca, String modelo, int anio, String idCliente
});




}
/// @nodoc
class _$MotocicletaCopyWithImpl<$Res>
    implements $MotocicletaCopyWith<$Res> {
  _$MotocicletaCopyWithImpl(this._self, this._then);

  final Motocicleta _self;
  final $Res Function(Motocicleta) _then;

/// Create a copy of Motocicleta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vin = null,Object? placa = null,Object? marca = null,Object? modelo = null,Object? anio = null,Object? idCliente = null,}) {
  return _then(Motocicleta(
vin: null == vin ? _self.vin : vin // ignore: cast_nullable_to_non_nullable
as String,placa: null == placa ? _self.placa : placa // ignore: cast_nullable_to_non_nullable
as String,marca: null == marca ? _self.marca : marca // ignore: cast_nullable_to_non_nullable
as String,modelo: null == modelo ? _self.modelo : modelo // ignore: cast_nullable_to_non_nullable
as String,anio: null == anio ? _self.anio : anio // ignore: cast_nullable_to_non_nullable
as int,idCliente: null == idCliente ? _self.idCliente : idCliente // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Motocicleta].
extension MotocicletaPatterns on Motocicleta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Motocicleta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Motocicleta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Motocicleta value)  $default,){
final _that = this;
switch (_that) {
case _Motocicleta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Motocicleta value)?  $default,){
final _that = this;
switch (_that) {
case _Motocicleta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String vin,  String placa,  String marca,  String modelo,  int anio,  String idCliente)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Motocicleta() when $default != null:
return $default(_that.vin,_that.placa,_that.marca,_that.modelo,_that.anio,_that.idCliente);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String vin,  String placa,  String marca,  String modelo,  int anio,  String idCliente)  $default,) {final _that = this;
switch (_that) {
case _Motocicleta():
return $default(_that.vin,_that.placa,_that.marca,_that.modelo,_that.anio,_that.idCliente);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String vin,  String placa,  String marca,  String modelo,  int anio,  String idCliente)?  $default,) {final _that = this;
switch (_that) {
case _Motocicleta() when $default != null:
return $default(_that.vin,_that.placa,_that.marca,_that.modelo,_that.anio,_that.idCliente);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Motocicleta implements Motocicleta {
  const _Motocicleta({required this.vin, required this.placa, required this.marca, required this.modelo, required this.anio, required this.idCliente});
  factory _Motocicleta.fromJson(Map<String, dynamic> json) => _$MotocicletaFromJson(json);

@override final  String vin;
@override final  String placa;
@override final  String marca;
@override final  String modelo;
@override final  int anio;
@override final  String idCliente;

/// Create a copy of Motocicleta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MotocicletaCopyWith<_Motocicleta> get copyWith => __$MotocicletaCopyWithImpl<_Motocicleta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MotocicletaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Motocicleta&&(identical(other.vin, vin) || other.vin == vin)&&(identical(other.placa, placa) || other.placa == placa)&&(identical(other.marca, marca) || other.marca == marca)&&(identical(other.modelo, modelo) || other.modelo == modelo)&&(identical(other.anio, anio) || other.anio == anio)&&(identical(other.idCliente, idCliente) || other.idCliente == idCliente));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vin,placa,marca,modelo,anio,idCliente);

@override
String toString() {
  return 'Motocicleta(vin: $vin, placa: $placa, marca: $marca, modelo: $modelo, anio: $anio, idCliente: $idCliente)';
}


}

/// @nodoc
abstract mixin class _$MotocicletaCopyWith<$Res> implements $MotocicletaCopyWith<$Res> {
  factory _$MotocicletaCopyWith(_Motocicleta value, $Res Function(_Motocicleta) _then) = __$MotocicletaCopyWithImpl;
@override @useResult
$Res call({
 String vin, String placa, String marca, String modelo, int anio, String idCliente
});




}
/// @nodoc
class __$MotocicletaCopyWithImpl<$Res>
    implements _$MotocicletaCopyWith<$Res> {
  __$MotocicletaCopyWithImpl(this._self, this._then);

  final _Motocicleta _self;
  final $Res Function(_Motocicleta) _then;

/// Create a copy of Motocicleta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vin = null,Object? placa = null,Object? marca = null,Object? modelo = null,Object? anio = null,Object? idCliente = null,}) {
  return _then(_Motocicleta(
vin: null == vin ? _self.vin : vin // ignore: cast_nullable_to_non_nullable
as String,placa: null == placa ? _self.placa : placa // ignore: cast_nullable_to_non_nullable
as String,marca: null == marca ? _self.marca : marca // ignore: cast_nullable_to_non_nullable
as String,modelo: null == modelo ? _self.modelo : modelo // ignore: cast_nullable_to_non_nullable
as String,anio: null == anio ? _self.anio : anio // ignore: cast_nullable_to_non_nullable
as int,idCliente: null == idCliente ? _self.idCliente : idCliente // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
