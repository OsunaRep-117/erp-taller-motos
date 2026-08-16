// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orden_trabajo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrdenTrabajo {

 String get id; String get idMoto; String? get idMecanico; EstadoOrdenTrabajo get estado; String get fallaReportada; double get horasFacturables; double get horasEstimadas; double get saldoPendiente; DateTime get fechaCreacion; DateTime? get fechaInicioReparacion; DateTime? get fechaTerminado; DateTime? get fechaAprobacionPresupuesto;
/// Create a copy of OrdenTrabajo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrdenTrabajoCopyWith<OrdenTrabajo> get copyWith => _$OrdenTrabajoCopyWithImpl<OrdenTrabajo>(this as OrdenTrabajo, _$identity);

  /// Serializes this OrdenTrabajo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrdenTrabajo&&(identical(other.id, id) || other.id == id)&&(identical(other.idMoto, idMoto) || other.idMoto == idMoto)&&(identical(other.idMecanico, idMecanico) || other.idMecanico == idMecanico)&&(identical(other.estado, estado) || other.estado == estado)&&(identical(other.fallaReportada, fallaReportada) || other.fallaReportada == fallaReportada)&&(identical(other.horasFacturables, horasFacturables) || other.horasFacturables == horasFacturables)&&(identical(other.horasEstimadas, horasEstimadas) || other.horasEstimadas == horasEstimadas)&&(identical(other.saldoPendiente, saldoPendiente) || other.saldoPendiente == saldoPendiente)&&(identical(other.fechaCreacion, fechaCreacion) || other.fechaCreacion == fechaCreacion)&&(identical(other.fechaInicioReparacion, fechaInicioReparacion) || other.fechaInicioReparacion == fechaInicioReparacion)&&(identical(other.fechaTerminado, fechaTerminado) || other.fechaTerminado == fechaTerminado)&&(identical(other.fechaAprobacionPresupuesto, fechaAprobacionPresupuesto) || other.fechaAprobacionPresupuesto == fechaAprobacionPresupuesto));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,idMoto,idMecanico,estado,fallaReportada,horasFacturables,horasEstimadas,saldoPendiente,fechaCreacion,fechaInicioReparacion,fechaTerminado,fechaAprobacionPresupuesto);

@override
String toString() {
  return 'OrdenTrabajo(id: $id, idMoto: $idMoto, idMecanico: $idMecanico, estado: $estado, fallaReportada: $fallaReportada, horasFacturables: $horasFacturables, horasEstimadas: $horasEstimadas, saldoPendiente: $saldoPendiente, fechaCreacion: $fechaCreacion, fechaInicioReparacion: $fechaInicioReparacion, fechaTerminado: $fechaTerminado, fechaAprobacionPresupuesto: $fechaAprobacionPresupuesto)';
}


}

/// @nodoc
abstract mixin class $OrdenTrabajoCopyWith<$Res>  {
  factory $OrdenTrabajoCopyWith(OrdenTrabajo value, $Res Function(OrdenTrabajo) _then) = _$OrdenTrabajoCopyWithImpl;
@useResult
$Res call({
 String id, String idMoto, String? idMecanico, EstadoOrdenTrabajo estado, String fallaReportada, double horasFacturables, double horasEstimadas, double saldoPendiente, DateTime fechaCreacion, DateTime? fechaInicioReparacion, DateTime? fechaTerminado, DateTime? fechaAprobacionPresupuesto
});




}
/// @nodoc
class _$OrdenTrabajoCopyWithImpl<$Res>
    implements $OrdenTrabajoCopyWith<$Res> {
  _$OrdenTrabajoCopyWithImpl(this._self, this._then);

  final OrdenTrabajo _self;
  final $Res Function(OrdenTrabajo) _then;

/// Create a copy of OrdenTrabajo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? idMoto = null,Object? idMecanico = freezed,Object? estado = null,Object? fallaReportada = null,Object? horasFacturables = null,Object? horasEstimadas = null,Object? saldoPendiente = null,Object? fechaCreacion = null,Object? fechaInicioReparacion = freezed,Object? fechaTerminado = freezed,Object? fechaAprobacionPresupuesto = freezed,}) {
  return _then(OrdenTrabajo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,idMoto: null == idMoto ? _self.idMoto : idMoto // ignore: cast_nullable_to_non_nullable
as String,idMecanico: freezed == idMecanico ? _self.idMecanico : idMecanico // ignore: cast_nullable_to_non_nullable
as String?,estado: null == estado ? _self.estado : estado // ignore: cast_nullable_to_non_nullable
as EstadoOrdenTrabajo,fallaReportada: null == fallaReportada ? _self.fallaReportada : fallaReportada // ignore: cast_nullable_to_non_nullable
as String,horasFacturables: null == horasFacturables ? _self.horasFacturables : horasFacturables // ignore: cast_nullable_to_non_nullable
as double,horasEstimadas: null == horasEstimadas ? _self.horasEstimadas : horasEstimadas // ignore: cast_nullable_to_non_nullable
as double,saldoPendiente: null == saldoPendiente ? _self.saldoPendiente : saldoPendiente // ignore: cast_nullable_to_non_nullable
as double,fechaCreacion: null == fechaCreacion ? _self.fechaCreacion : fechaCreacion // ignore: cast_nullable_to_non_nullable
as DateTime,fechaInicioReparacion: freezed == fechaInicioReparacion ? _self.fechaInicioReparacion : fechaInicioReparacion // ignore: cast_nullable_to_non_nullable
as DateTime?,fechaTerminado: freezed == fechaTerminado ? _self.fechaTerminado : fechaTerminado // ignore: cast_nullable_to_non_nullable
as DateTime?,fechaAprobacionPresupuesto: freezed == fechaAprobacionPresupuesto ? _self.fechaAprobacionPresupuesto : fechaAprobacionPresupuesto // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrdenTrabajo].
extension OrdenTrabajoPatterns on OrdenTrabajo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrdenTrabajo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrdenTrabajo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrdenTrabajo value)  $default,){
final _that = this;
switch (_that) {
case _OrdenTrabajo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrdenTrabajo value)?  $default,){
final _that = this;
switch (_that) {
case _OrdenTrabajo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String idMoto,  String? idMecanico,  EstadoOrdenTrabajo estado,  String fallaReportada,  double horasFacturables,  double horasEstimadas,  double saldoPendiente,  DateTime fechaCreacion,  DateTime? fechaInicioReparacion,  DateTime? fechaTerminado,  DateTime? fechaAprobacionPresupuesto)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrdenTrabajo() when $default != null:
return $default(_that.id,_that.idMoto,_that.idMecanico,_that.estado,_that.fallaReportada,_that.horasFacturables,_that.horasEstimadas,_that.saldoPendiente,_that.fechaCreacion,_that.fechaInicioReparacion,_that.fechaTerminado,_that.fechaAprobacionPresupuesto);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String idMoto,  String? idMecanico,  EstadoOrdenTrabajo estado,  String fallaReportada,  double horasFacturables,  double horasEstimadas,  double saldoPendiente,  DateTime fechaCreacion,  DateTime? fechaInicioReparacion,  DateTime? fechaTerminado,  DateTime? fechaAprobacionPresupuesto)  $default,) {final _that = this;
switch (_that) {
case _OrdenTrabajo():
return $default(_that.id,_that.idMoto,_that.idMecanico,_that.estado,_that.fallaReportada,_that.horasFacturables,_that.horasEstimadas,_that.saldoPendiente,_that.fechaCreacion,_that.fechaInicioReparacion,_that.fechaTerminado,_that.fechaAprobacionPresupuesto);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String idMoto,  String? idMecanico,  EstadoOrdenTrabajo estado,  String fallaReportada,  double horasFacturables,  double horasEstimadas,  double saldoPendiente,  DateTime fechaCreacion,  DateTime? fechaInicioReparacion,  DateTime? fechaTerminado,  DateTime? fechaAprobacionPresupuesto)?  $default,) {final _that = this;
switch (_that) {
case _OrdenTrabajo() when $default != null:
return $default(_that.id,_that.idMoto,_that.idMecanico,_that.estado,_that.fallaReportada,_that.horasFacturables,_that.horasEstimadas,_that.saldoPendiente,_that.fechaCreacion,_that.fechaInicioReparacion,_that.fechaTerminado,_that.fechaAprobacionPresupuesto);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrdenTrabajo extends OrdenTrabajo {
  const _OrdenTrabajo({required this.id, required this.idMoto, this.idMecanico, required this.estado, required this.fallaReportada, this.horasFacturables = 0, this.horasEstimadas = 2, this.saldoPendiente = 0, required this.fechaCreacion, this.fechaInicioReparacion, this.fechaTerminado, this.fechaAprobacionPresupuesto}): super._();
  factory _OrdenTrabajo.fromJson(Map<String, dynamic> json) => _$OrdenTrabajoFromJson(json);

@override final  String id;
@override final  String idMoto;
@override final  String? idMecanico;
@override final  EstadoOrdenTrabajo estado;
@override final  String fallaReportada;
@override@JsonKey() final  double horasFacturables;
@override@JsonKey() final  double horasEstimadas;
@override@JsonKey() final  double saldoPendiente;
@override final  DateTime fechaCreacion;
@override final  DateTime? fechaInicioReparacion;
@override final  DateTime? fechaTerminado;
@override final  DateTime? fechaAprobacionPresupuesto;

/// Create a copy of OrdenTrabajo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrdenTrabajoCopyWith<_OrdenTrabajo> get copyWith => __$OrdenTrabajoCopyWithImpl<_OrdenTrabajo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrdenTrabajoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrdenTrabajo&&(identical(other.id, id) || other.id == id)&&(identical(other.idMoto, idMoto) || other.idMoto == idMoto)&&(identical(other.idMecanico, idMecanico) || other.idMecanico == idMecanico)&&(identical(other.estado, estado) || other.estado == estado)&&(identical(other.fallaReportada, fallaReportada) || other.fallaReportada == fallaReportada)&&(identical(other.horasFacturables, horasFacturables) || other.horasFacturables == horasFacturables)&&(identical(other.horasEstimadas, horasEstimadas) || other.horasEstimadas == horasEstimadas)&&(identical(other.saldoPendiente, saldoPendiente) || other.saldoPendiente == saldoPendiente)&&(identical(other.fechaCreacion, fechaCreacion) || other.fechaCreacion == fechaCreacion)&&(identical(other.fechaInicioReparacion, fechaInicioReparacion) || other.fechaInicioReparacion == fechaInicioReparacion)&&(identical(other.fechaTerminado, fechaTerminado) || other.fechaTerminado == fechaTerminado)&&(identical(other.fechaAprobacionPresupuesto, fechaAprobacionPresupuesto) || other.fechaAprobacionPresupuesto == fechaAprobacionPresupuesto));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,idMoto,idMecanico,estado,fallaReportada,horasFacturables,horasEstimadas,saldoPendiente,fechaCreacion,fechaInicioReparacion,fechaTerminado,fechaAprobacionPresupuesto);

@override
String toString() {
  return 'OrdenTrabajo(id: $id, idMoto: $idMoto, idMecanico: $idMecanico, estado: $estado, fallaReportada: $fallaReportada, horasFacturables: $horasFacturables, horasEstimadas: $horasEstimadas, saldoPendiente: $saldoPendiente, fechaCreacion: $fechaCreacion, fechaInicioReparacion: $fechaInicioReparacion, fechaTerminado: $fechaTerminado, fechaAprobacionPresupuesto: $fechaAprobacionPresupuesto)';
}


}

/// @nodoc
abstract mixin class _$OrdenTrabajoCopyWith<$Res> implements $OrdenTrabajoCopyWith<$Res> {
  factory _$OrdenTrabajoCopyWith(_OrdenTrabajo value, $Res Function(_OrdenTrabajo) _then) = __$OrdenTrabajoCopyWithImpl;
@override @useResult
$Res call({
 String id, String idMoto, String? idMecanico, EstadoOrdenTrabajo estado, String fallaReportada, double horasFacturables, double horasEstimadas, double saldoPendiente, DateTime fechaCreacion, DateTime? fechaInicioReparacion, DateTime? fechaTerminado, DateTime? fechaAprobacionPresupuesto
});




}
/// @nodoc
class __$OrdenTrabajoCopyWithImpl<$Res>
    implements _$OrdenTrabajoCopyWith<$Res> {
  __$OrdenTrabajoCopyWithImpl(this._self, this._then);

  final _OrdenTrabajo _self;
  final $Res Function(_OrdenTrabajo) _then;

/// Create a copy of OrdenTrabajo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? idMoto = null,Object? idMecanico = freezed,Object? estado = null,Object? fallaReportada = null,Object? horasFacturables = null,Object? horasEstimadas = null,Object? saldoPendiente = null,Object? fechaCreacion = null,Object? fechaInicioReparacion = freezed,Object? fechaTerminado = freezed,Object? fechaAprobacionPresupuesto = freezed,}) {
  return _then(_OrdenTrabajo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,idMoto: null == idMoto ? _self.idMoto : idMoto // ignore: cast_nullable_to_non_nullable
as String,idMecanico: freezed == idMecanico ? _self.idMecanico : idMecanico // ignore: cast_nullable_to_non_nullable
as String?,estado: null == estado ? _self.estado : estado // ignore: cast_nullable_to_non_nullable
as EstadoOrdenTrabajo,fallaReportada: null == fallaReportada ? _self.fallaReportada : fallaReportada // ignore: cast_nullable_to_non_nullable
as String,horasFacturables: null == horasFacturables ? _self.horasFacturables : horasFacturables // ignore: cast_nullable_to_non_nullable
as double,horasEstimadas: null == horasEstimadas ? _self.horasEstimadas : horasEstimadas // ignore: cast_nullable_to_non_nullable
as double,saldoPendiente: null == saldoPendiente ? _self.saldoPendiente : saldoPendiente // ignore: cast_nullable_to_non_nullable
as double,fechaCreacion: null == fechaCreacion ? _self.fechaCreacion : fechaCreacion // ignore: cast_nullable_to_non_nullable
as DateTime,fechaInicioReparacion: freezed == fechaInicioReparacion ? _self.fechaInicioReparacion : fechaInicioReparacion // ignore: cast_nullable_to_non_nullable
as DateTime?,fechaTerminado: freezed == fechaTerminado ? _self.fechaTerminado : fechaTerminado // ignore: cast_nullable_to_non_nullable
as DateTime?,fechaAprobacionPresupuesto: freezed == fechaAprobacionPresupuesto ? _self.fechaAprobacionPresupuesto : fechaAprobacionPresupuesto // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
