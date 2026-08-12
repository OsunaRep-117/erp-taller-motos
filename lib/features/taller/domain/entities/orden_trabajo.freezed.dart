// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orden_trabajo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrdenTrabajo _$OrdenTrabajoFromJson(Map<String, dynamic> json) {
  return _OrdenTrabajo.fromJson(json);
}

/// @nodoc
mixin _$OrdenTrabajo {
  String get id => throw _privateConstructorUsedError;
  String get idMoto => throw _privateConstructorUsedError;
  String? get idMecanico => throw _privateConstructorUsedError;
  EstadoOrdenTrabajo get estado => throw _privateConstructorUsedError;
  String get fallaReportada => throw _privateConstructorUsedError;
  double get horasFacturables => throw _privateConstructorUsedError;
  double get saldoPendiente => throw _privateConstructorUsedError;
  DateTime get fechaCreacion => throw _privateConstructorUsedError;
  DateTime? get fechaInicioReparacion => throw _privateConstructorUsedError;
  DateTime? get fechaTerminado => throw _privateConstructorUsedError;

  /// Serializes this OrdenTrabajo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrdenTrabajo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrdenTrabajoCopyWith<OrdenTrabajo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrdenTrabajoCopyWith<$Res> {
  factory $OrdenTrabajoCopyWith(
    OrdenTrabajo value,
    $Res Function(OrdenTrabajo) then,
  ) = _$OrdenTrabajoCopyWithImpl<$Res, OrdenTrabajo>;
  @useResult
  $Res call({
    String id,
    String idMoto,
    String? idMecanico,
    EstadoOrdenTrabajo estado,
    String fallaReportada,
    double horasFacturables,
    double saldoPendiente,
    DateTime fechaCreacion,
    DateTime? fechaInicioReparacion,
    DateTime? fechaTerminado,
  });
}

/// @nodoc
class _$OrdenTrabajoCopyWithImpl<$Res, $Val extends OrdenTrabajo>
    implements $OrdenTrabajoCopyWith<$Res> {
  _$OrdenTrabajoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrdenTrabajo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idMoto = null,
    Object? idMecanico = freezed,
    Object? estado = null,
    Object? fallaReportada = null,
    Object? horasFacturables = null,
    Object? saldoPendiente = null,
    Object? fechaCreacion = null,
    Object? fechaInicioReparacion = freezed,
    Object? fechaTerminado = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            idMoto: null == idMoto
                ? _value.idMoto
                : idMoto // ignore: cast_nullable_to_non_nullable
                      as String,
            idMecanico: freezed == idMecanico
                ? _value.idMecanico
                : idMecanico // ignore: cast_nullable_to_non_nullable
                      as String?,
            estado: null == estado
                ? _value.estado
                : estado // ignore: cast_nullable_to_non_nullable
                      as EstadoOrdenTrabajo,
            fallaReportada: null == fallaReportada
                ? _value.fallaReportada
                : fallaReportada // ignore: cast_nullable_to_non_nullable
                      as String,
            horasFacturables: null == horasFacturables
                ? _value.horasFacturables
                : horasFacturables // ignore: cast_nullable_to_non_nullable
                      as double,
            saldoPendiente: null == saldoPendiente
                ? _value.saldoPendiente
                : saldoPendiente // ignore: cast_nullable_to_non_nullable
                      as double,
            fechaCreacion: null == fechaCreacion
                ? _value.fechaCreacion
                : fechaCreacion // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            fechaInicioReparacion: freezed == fechaInicioReparacion
                ? _value.fechaInicioReparacion
                : fechaInicioReparacion // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            fechaTerminado: freezed == fechaTerminado
                ? _value.fechaTerminado
                : fechaTerminado // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrdenTrabajoImplCopyWith<$Res>
    implements $OrdenTrabajoCopyWith<$Res> {
  factory _$$OrdenTrabajoImplCopyWith(
    _$OrdenTrabajoImpl value,
    $Res Function(_$OrdenTrabajoImpl) then,
  ) = __$$OrdenTrabajoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String idMoto,
    String? idMecanico,
    EstadoOrdenTrabajo estado,
    String fallaReportada,
    double horasFacturables,
    double saldoPendiente,
    DateTime fechaCreacion,
    DateTime? fechaInicioReparacion,
    DateTime? fechaTerminado,
  });
}

/// @nodoc
class __$$OrdenTrabajoImplCopyWithImpl<$Res>
    extends _$OrdenTrabajoCopyWithImpl<$Res, _$OrdenTrabajoImpl>
    implements _$$OrdenTrabajoImplCopyWith<$Res> {
  __$$OrdenTrabajoImplCopyWithImpl(
    _$OrdenTrabajoImpl _value,
    $Res Function(_$OrdenTrabajoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrdenTrabajo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idMoto = null,
    Object? idMecanico = freezed,
    Object? estado = null,
    Object? fallaReportada = null,
    Object? horasFacturables = null,
    Object? saldoPendiente = null,
    Object? fechaCreacion = null,
    Object? fechaInicioReparacion = freezed,
    Object? fechaTerminado = freezed,
  }) {
    return _then(
      _$OrdenTrabajoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        idMoto: null == idMoto
            ? _value.idMoto
            : idMoto // ignore: cast_nullable_to_non_nullable
                  as String,
        idMecanico: freezed == idMecanico
            ? _value.idMecanico
            : idMecanico // ignore: cast_nullable_to_non_nullable
                  as String?,
        estado: null == estado
            ? _value.estado
            : estado // ignore: cast_nullable_to_non_nullable
                  as EstadoOrdenTrabajo,
        fallaReportada: null == fallaReportada
            ? _value.fallaReportada
            : fallaReportada // ignore: cast_nullable_to_non_nullable
                  as String,
        horasFacturables: null == horasFacturables
            ? _value.horasFacturables
            : horasFacturables // ignore: cast_nullable_to_non_nullable
                  as double,
        saldoPendiente: null == saldoPendiente
            ? _value.saldoPendiente
            : saldoPendiente // ignore: cast_nullable_to_non_nullable
                  as double,
        fechaCreacion: null == fechaCreacion
            ? _value.fechaCreacion
            : fechaCreacion // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        fechaInicioReparacion: freezed == fechaInicioReparacion
            ? _value.fechaInicioReparacion
            : fechaInicioReparacion // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        fechaTerminado: freezed == fechaTerminado
            ? _value.fechaTerminado
            : fechaTerminado // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrdenTrabajoImpl extends _OrdenTrabajo {
  const _$OrdenTrabajoImpl({
    required this.id,
    required this.idMoto,
    this.idMecanico,
    required this.estado,
    required this.fallaReportada,
    this.horasFacturables = 0,
    this.saldoPendiente = 0,
    required this.fechaCreacion,
    this.fechaInicioReparacion,
    this.fechaTerminado,
  }) : super._();

  factory _$OrdenTrabajoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrdenTrabajoImplFromJson(json);

  @override
  final String id;
  @override
  final String idMoto;
  @override
  final String? idMecanico;
  @override
  final EstadoOrdenTrabajo estado;
  @override
  final String fallaReportada;
  @override
  @JsonKey()
  final double horasFacturables;
  @override
  @JsonKey()
  final double saldoPendiente;
  @override
  final DateTime fechaCreacion;
  @override
  final DateTime? fechaInicioReparacion;
  @override
  final DateTime? fechaTerminado;

  @override
  String toString() {
    return 'OrdenTrabajo(id: $id, idMoto: $idMoto, idMecanico: $idMecanico, estado: $estado, fallaReportada: $fallaReportada, horasFacturables: $horasFacturables, saldoPendiente: $saldoPendiente, fechaCreacion: $fechaCreacion, fechaInicioReparacion: $fechaInicioReparacion, fechaTerminado: $fechaTerminado)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrdenTrabajoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.idMoto, idMoto) || other.idMoto == idMoto) &&
            (identical(other.idMecanico, idMecanico) ||
                other.idMecanico == idMecanico) &&
            (identical(other.estado, estado) || other.estado == estado) &&
            (identical(other.fallaReportada, fallaReportada) ||
                other.fallaReportada == fallaReportada) &&
            (identical(other.horasFacturables, horasFacturables) ||
                other.horasFacturables == horasFacturables) &&
            (identical(other.saldoPendiente, saldoPendiente) ||
                other.saldoPendiente == saldoPendiente) &&
            (identical(other.fechaCreacion, fechaCreacion) ||
                other.fechaCreacion == fechaCreacion) &&
            (identical(other.fechaInicioReparacion, fechaInicioReparacion) ||
                other.fechaInicioReparacion == fechaInicioReparacion) &&
            (identical(other.fechaTerminado, fechaTerminado) ||
                other.fechaTerminado == fechaTerminado));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    idMoto,
    idMecanico,
    estado,
    fallaReportada,
    horasFacturables,
    saldoPendiente,
    fechaCreacion,
    fechaInicioReparacion,
    fechaTerminado,
  );

  /// Create a copy of OrdenTrabajo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrdenTrabajoImplCopyWith<_$OrdenTrabajoImpl> get copyWith =>
      __$$OrdenTrabajoImplCopyWithImpl<_$OrdenTrabajoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrdenTrabajoImplToJson(this);
  }
}

abstract class _OrdenTrabajo extends OrdenTrabajo {
  const factory _OrdenTrabajo({
    required final String id,
    required final String idMoto,
    final String? idMecanico,
    required final EstadoOrdenTrabajo estado,
    required final String fallaReportada,
    final double horasFacturables,
    final double saldoPendiente,
    required final DateTime fechaCreacion,
    final DateTime? fechaInicioReparacion,
    final DateTime? fechaTerminado,
  }) = _$OrdenTrabajoImpl;
  const _OrdenTrabajo._() : super._();

  factory _OrdenTrabajo.fromJson(Map<String, dynamic> json) =
      _$OrdenTrabajoImpl.fromJson;

  @override
  String get id;
  @override
  String get idMoto;
  @override
  String? get idMecanico;
  @override
  EstadoOrdenTrabajo get estado;
  @override
  String get fallaReportada;
  @override
  double get horasFacturables;
  @override
  double get saldoPendiente;
  @override
  DateTime get fechaCreacion;
  @override
  DateTime? get fechaInicioReparacion;
  @override
  DateTime? get fechaTerminado;

  /// Create a copy of OrdenTrabajo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrdenTrabajoImplCopyWith<_$OrdenTrabajoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
