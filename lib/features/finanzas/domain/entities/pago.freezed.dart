// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pago.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Pago {

 String get id; String get idOrden; double get monto; MetodoPago get metodoPago; String? get idPagoRevertido; DateTime get fechaPago;
/// Create a copy of Pago
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PagoCopyWith<Pago> get copyWith => _$PagoCopyWithImpl<Pago>(this as Pago, _$identity);

  /// Serializes this Pago to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Pago&&(identical(other.id, id) || other.id == id)&&(identical(other.idOrden, idOrden) || other.idOrden == idOrden)&&(identical(other.monto, monto) || other.monto == monto)&&(identical(other.metodoPago, metodoPago) || other.metodoPago == metodoPago)&&(identical(other.idPagoRevertido, idPagoRevertido) || other.idPagoRevertido == idPagoRevertido)&&(identical(other.fechaPago, fechaPago) || other.fechaPago == fechaPago));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,idOrden,monto,metodoPago,idPagoRevertido,fechaPago);

@override
String toString() {
  return 'Pago(id: $id, idOrden: $idOrden, monto: $monto, metodoPago: $metodoPago, idPagoRevertido: $idPagoRevertido, fechaPago: $fechaPago)';
}


}

/// @nodoc
abstract mixin class $PagoCopyWith<$Res>  {
  factory $PagoCopyWith(Pago value, $Res Function(Pago) _then) = _$PagoCopyWithImpl;
@useResult
$Res call({
 String id, String idOrden, double monto, MetodoPago metodoPago, String? idPagoRevertido, DateTime fechaPago
});




}
/// @nodoc
class _$PagoCopyWithImpl<$Res>
    implements $PagoCopyWith<$Res> {
  _$PagoCopyWithImpl(this._self, this._then);

  final Pago _self;
  final $Res Function(Pago) _then;

/// Create a copy of Pago
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? idOrden = null,Object? monto = null,Object? metodoPago = null,Object? idPagoRevertido = freezed,Object? fechaPago = null,}) {
  return _then(Pago(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,idOrden: null == idOrden ? _self.idOrden : idOrden // ignore: cast_nullable_to_non_nullable
as String,monto: null == monto ? _self.monto : monto // ignore: cast_nullable_to_non_nullable
as double,metodoPago: null == metodoPago ? _self.metodoPago : metodoPago // ignore: cast_nullable_to_non_nullable
as MetodoPago,idPagoRevertido: freezed == idPagoRevertido ? _self.idPagoRevertido : idPagoRevertido // ignore: cast_nullable_to_non_nullable
as String?,fechaPago: null == fechaPago ? _self.fechaPago : fechaPago // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Pago].
extension PagoPatterns on Pago {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Pago value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Pago() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Pago value)  $default,){
final _that = this;
switch (_that) {
case _Pago():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Pago value)?  $default,){
final _that = this;
switch (_that) {
case _Pago() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String idOrden,  double monto,  MetodoPago metodoPago,  String? idPagoRevertido,  DateTime fechaPago)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Pago() when $default != null:
return $default(_that.id,_that.idOrden,_that.monto,_that.metodoPago,_that.idPagoRevertido,_that.fechaPago);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String idOrden,  double monto,  MetodoPago metodoPago,  String? idPagoRevertido,  DateTime fechaPago)  $default,) {final _that = this;
switch (_that) {
case _Pago():
return $default(_that.id,_that.idOrden,_that.monto,_that.metodoPago,_that.idPagoRevertido,_that.fechaPago);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String idOrden,  double monto,  MetodoPago metodoPago,  String? idPagoRevertido,  DateTime fechaPago)?  $default,) {final _that = this;
switch (_that) {
case _Pago() when $default != null:
return $default(_that.id,_that.idOrden,_that.monto,_that.metodoPago,_that.idPagoRevertido,_that.fechaPago);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Pago extends Pago {
  const _Pago({required this.id, required this.idOrden, required this.monto, required this.metodoPago, this.idPagoRevertido, required this.fechaPago}): super._();
  factory _Pago.fromJson(Map<String, dynamic> json) => _$PagoFromJson(json);

@override final  String id;
@override final  String idOrden;
@override final  double monto;
@override final  MetodoPago metodoPago;
@override final  String? idPagoRevertido;
@override final  DateTime fechaPago;

/// Create a copy of Pago
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PagoCopyWith<_Pago> get copyWith => __$PagoCopyWithImpl<_Pago>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PagoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Pago&&(identical(other.id, id) || other.id == id)&&(identical(other.idOrden, idOrden) || other.idOrden == idOrden)&&(identical(other.monto, monto) || other.monto == monto)&&(identical(other.metodoPago, metodoPago) || other.metodoPago == metodoPago)&&(identical(other.idPagoRevertido, idPagoRevertido) || other.idPagoRevertido == idPagoRevertido)&&(identical(other.fechaPago, fechaPago) || other.fechaPago == fechaPago));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,idOrden,monto,metodoPago,idPagoRevertido,fechaPago);

@override
String toString() {
  return 'Pago(id: $id, idOrden: $idOrden, monto: $monto, metodoPago: $metodoPago, idPagoRevertido: $idPagoRevertido, fechaPago: $fechaPago)';
}


}

/// @nodoc
abstract mixin class _$PagoCopyWith<$Res> implements $PagoCopyWith<$Res> {
  factory _$PagoCopyWith(_Pago value, $Res Function(_Pago) _then) = __$PagoCopyWithImpl;
@override @useResult
$Res call({
 String id, String idOrden, double monto, MetodoPago metodoPago, String? idPagoRevertido, DateTime fechaPago
});




}
/// @nodoc
class __$PagoCopyWithImpl<$Res>
    implements _$PagoCopyWith<$Res> {
  __$PagoCopyWithImpl(this._self, this._then);

  final _Pago _self;
  final $Res Function(_Pago) _then;

/// Create a copy of Pago
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? idOrden = null,Object? monto = null,Object? metodoPago = null,Object? idPagoRevertido = freezed,Object? fechaPago = null,}) {
  return _then(_Pago(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,idOrden: null == idOrden ? _self.idOrden : idOrden // ignore: cast_nullable_to_non_nullable
as String,monto: null == monto ? _self.monto : monto // ignore: cast_nullable_to_non_nullable
as double,metodoPago: null == metodoPago ? _self.metodoPago : metodoPago // ignore: cast_nullable_to_non_nullable
as MetodoPago,idPagoRevertido: freezed == idPagoRevertido ? _self.idPagoRevertido : idPagoRevertido // ignore: cast_nullable_to_non_nullable
as String?,fechaPago: null == fechaPago ? _self.fechaPago : fechaPago // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
