// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'refaccion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Refaccion {

 String get sku; String get nombre; double get precioCosto; double get precioVenta; int get stockActual; int get stockReservado; int get stockMinimo; bool get inactivo;
/// Create a copy of Refaccion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RefaccionCopyWith<Refaccion> get copyWith => _$RefaccionCopyWithImpl<Refaccion>(this as Refaccion, _$identity);

  /// Serializes this Refaccion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Refaccion&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.precioCosto, precioCosto) || other.precioCosto == precioCosto)&&(identical(other.precioVenta, precioVenta) || other.precioVenta == precioVenta)&&(identical(other.stockActual, stockActual) || other.stockActual == stockActual)&&(identical(other.stockReservado, stockReservado) || other.stockReservado == stockReservado)&&(identical(other.stockMinimo, stockMinimo) || other.stockMinimo == stockMinimo)&&(identical(other.inactivo, inactivo) || other.inactivo == inactivo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sku,nombre,precioCosto,precioVenta,stockActual,stockReservado,stockMinimo,inactivo);

@override
String toString() {
  return 'Refaccion(sku: $sku, nombre: $nombre, precioCosto: $precioCosto, precioVenta: $precioVenta, stockActual: $stockActual, stockReservado: $stockReservado, stockMinimo: $stockMinimo, inactivo: $inactivo)';
}


}

/// @nodoc
abstract mixin class $RefaccionCopyWith<$Res>  {
  factory $RefaccionCopyWith(Refaccion value, $Res Function(Refaccion) _then) = _$RefaccionCopyWithImpl;
@useResult
$Res call({
 String sku, String nombre, double precioCosto, double precioVenta, int stockActual, int stockReservado, int stockMinimo, bool inactivo
});




}
/// @nodoc
class _$RefaccionCopyWithImpl<$Res>
    implements $RefaccionCopyWith<$Res> {
  _$RefaccionCopyWithImpl(this._self, this._then);

  final Refaccion _self;
  final $Res Function(Refaccion) _then;

/// Create a copy of Refaccion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sku = null,Object? nombre = null,Object? precioCosto = null,Object? precioVenta = null,Object? stockActual = null,Object? stockReservado = null,Object? stockMinimo = null,Object? inactivo = null,}) {
  return _then(Refaccion(
sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,precioCosto: null == precioCosto ? _self.precioCosto : precioCosto // ignore: cast_nullable_to_non_nullable
as double,precioVenta: null == precioVenta ? _self.precioVenta : precioVenta // ignore: cast_nullable_to_non_nullable
as double,stockActual: null == stockActual ? _self.stockActual : stockActual // ignore: cast_nullable_to_non_nullable
as int,stockReservado: null == stockReservado ? _self.stockReservado : stockReservado // ignore: cast_nullable_to_non_nullable
as int,stockMinimo: null == stockMinimo ? _self.stockMinimo : stockMinimo // ignore: cast_nullable_to_non_nullable
as int,inactivo: null == inactivo ? _self.inactivo : inactivo // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Refaccion].
extension RefaccionPatterns on Refaccion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Refaccion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Refaccion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Refaccion value)  $default,){
final _that = this;
switch (_that) {
case _Refaccion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Refaccion value)?  $default,){
final _that = this;
switch (_that) {
case _Refaccion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sku,  String nombre,  double precioCosto,  double precioVenta,  int stockActual,  int stockReservado,  int stockMinimo,  bool inactivo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Refaccion() when $default != null:
return $default(_that.sku,_that.nombre,_that.precioCosto,_that.precioVenta,_that.stockActual,_that.stockReservado,_that.stockMinimo,_that.inactivo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sku,  String nombre,  double precioCosto,  double precioVenta,  int stockActual,  int stockReservado,  int stockMinimo,  bool inactivo)  $default,) {final _that = this;
switch (_that) {
case _Refaccion():
return $default(_that.sku,_that.nombre,_that.precioCosto,_that.precioVenta,_that.stockActual,_that.stockReservado,_that.stockMinimo,_that.inactivo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sku,  String nombre,  double precioCosto,  double precioVenta,  int stockActual,  int stockReservado,  int stockMinimo,  bool inactivo)?  $default,) {final _that = this;
switch (_that) {
case _Refaccion() when $default != null:
return $default(_that.sku,_that.nombre,_that.precioCosto,_that.precioVenta,_that.stockActual,_that.stockReservado,_that.stockMinimo,_that.inactivo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Refaccion extends Refaccion {
  const _Refaccion({required this.sku, required this.nombre, required this.precioCosto, required this.precioVenta, required this.stockActual, required this.stockReservado, required this.stockMinimo, this.inactivo = false}): super._();
  factory _Refaccion.fromJson(Map<String, dynamic> json) => _$RefaccionFromJson(json);

@override final  String sku;
@override final  String nombre;
@override final  double precioCosto;
@override final  double precioVenta;
@override final  int stockActual;
@override final  int stockReservado;
@override final  int stockMinimo;
@override@JsonKey() final  bool inactivo;

/// Create a copy of Refaccion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RefaccionCopyWith<_Refaccion> get copyWith => __$RefaccionCopyWithImpl<_Refaccion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RefaccionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Refaccion&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.precioCosto, precioCosto) || other.precioCosto == precioCosto)&&(identical(other.precioVenta, precioVenta) || other.precioVenta == precioVenta)&&(identical(other.stockActual, stockActual) || other.stockActual == stockActual)&&(identical(other.stockReservado, stockReservado) || other.stockReservado == stockReservado)&&(identical(other.stockMinimo, stockMinimo) || other.stockMinimo == stockMinimo)&&(identical(other.inactivo, inactivo) || other.inactivo == inactivo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sku,nombre,precioCosto,precioVenta,stockActual,stockReservado,stockMinimo,inactivo);

@override
String toString() {
  return 'Refaccion(sku: $sku, nombre: $nombre, precioCosto: $precioCosto, precioVenta: $precioVenta, stockActual: $stockActual, stockReservado: $stockReservado, stockMinimo: $stockMinimo, inactivo: $inactivo)';
}


}

/// @nodoc
abstract mixin class _$RefaccionCopyWith<$Res> implements $RefaccionCopyWith<$Res> {
  factory _$RefaccionCopyWith(_Refaccion value, $Res Function(_Refaccion) _then) = __$RefaccionCopyWithImpl;
@override @useResult
$Res call({
 String sku, String nombre, double precioCosto, double precioVenta, int stockActual, int stockReservado, int stockMinimo, bool inactivo
});




}
/// @nodoc
class __$RefaccionCopyWithImpl<$Res>
    implements _$RefaccionCopyWith<$Res> {
  __$RefaccionCopyWithImpl(this._self, this._then);

  final _Refaccion _self;
  final $Res Function(_Refaccion) _then;

/// Create a copy of Refaccion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sku = null,Object? nombre = null,Object? precioCosto = null,Object? precioVenta = null,Object? stockActual = null,Object? stockReservado = null,Object? stockMinimo = null,Object? inactivo = null,}) {
  return _then(_Refaccion(
sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,precioCosto: null == precioCosto ? _self.precioCosto : precioCosto // ignore: cast_nullable_to_non_nullable
as double,precioVenta: null == precioVenta ? _self.precioVenta : precioVenta // ignore: cast_nullable_to_non_nullable
as double,stockActual: null == stockActual ? _self.stockActual : stockActual // ignore: cast_nullable_to_non_nullable
as int,stockReservado: null == stockReservado ? _self.stockReservado : stockReservado // ignore: cast_nullable_to_non_nullable
as int,stockMinimo: null == stockMinimo ? _self.stockMinimo : stockMinimo // ignore: cast_nullable_to_non_nullable
as int,inactivo: null == inactivo ? _self.inactivo : inactivo // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
