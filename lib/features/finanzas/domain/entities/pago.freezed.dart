// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pago.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Pago _$PagoFromJson(Map<String, dynamic> json) {
  return _Pago.fromJson(json);
}

/// @nodoc
mixin _$Pago {
  String get id => throw _privateConstructorUsedError;
  String get idOrden => throw _privateConstructorUsedError;
  double get monto => throw _privateConstructorUsedError;
  MetodoPago get metodoPago => throw _privateConstructorUsedError;
  String? get idPagoRevertido => throw _privateConstructorUsedError;
  DateTime get fechaPago => throw _privateConstructorUsedError;

  /// Serializes this Pago to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Pago
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PagoCopyWith<Pago> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PagoCopyWith<$Res> {
  factory $PagoCopyWith(Pago value, $Res Function(Pago) then) =
      _$PagoCopyWithImpl<$Res, Pago>;
  @useResult
  $Res call({
    String id,
    String idOrden,
    double monto,
    MetodoPago metodoPago,
    String? idPagoRevertido,
    DateTime fechaPago,
  });
}

/// @nodoc
class _$PagoCopyWithImpl<$Res, $Val extends Pago>
    implements $PagoCopyWith<$Res> {
  _$PagoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Pago
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idOrden = null,
    Object? monto = null,
    Object? metodoPago = null,
    Object? idPagoRevertido = freezed,
    Object? fechaPago = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            idOrden: null == idOrden
                ? _value.idOrden
                : idOrden // ignore: cast_nullable_to_non_nullable
                      as String,
            monto: null == monto
                ? _value.monto
                : monto // ignore: cast_nullable_to_non_nullable
                      as double,
            metodoPago: null == metodoPago
                ? _value.metodoPago
                : metodoPago // ignore: cast_nullable_to_non_nullable
                      as MetodoPago,
            idPagoRevertido: freezed == idPagoRevertido
                ? _value.idPagoRevertido
                : idPagoRevertido // ignore: cast_nullable_to_non_nullable
                      as String?,
            fechaPago: null == fechaPago
                ? _value.fechaPago
                : fechaPago // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PagoImplCopyWith<$Res> implements $PagoCopyWith<$Res> {
  factory _$$PagoImplCopyWith(
    _$PagoImpl value,
    $Res Function(_$PagoImpl) then,
  ) = __$$PagoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String idOrden,
    double monto,
    MetodoPago metodoPago,
    String? idPagoRevertido,
    DateTime fechaPago,
  });
}

/// @nodoc
class __$$PagoImplCopyWithImpl<$Res>
    extends _$PagoCopyWithImpl<$Res, _$PagoImpl>
    implements _$$PagoImplCopyWith<$Res> {
  __$$PagoImplCopyWithImpl(_$PagoImpl _value, $Res Function(_$PagoImpl) _then)
    : super(_value, _then);

  /// Create a copy of Pago
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? idOrden = null,
    Object? monto = null,
    Object? metodoPago = null,
    Object? idPagoRevertido = freezed,
    Object? fechaPago = null,
  }) {
    return _then(
      _$PagoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        idOrden: null == idOrden
            ? _value.idOrden
            : idOrden // ignore: cast_nullable_to_non_nullable
                  as String,
        monto: null == monto
            ? _value.monto
            : monto // ignore: cast_nullable_to_non_nullable
                  as double,
        metodoPago: null == metodoPago
            ? _value.metodoPago
            : metodoPago // ignore: cast_nullable_to_non_nullable
                  as MetodoPago,
        idPagoRevertido: freezed == idPagoRevertido
            ? _value.idPagoRevertido
            : idPagoRevertido // ignore: cast_nullable_to_non_nullable
                  as String?,
        fechaPago: null == fechaPago
            ? _value.fechaPago
            : fechaPago // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PagoImpl extends _Pago {
  const _$PagoImpl({
    required this.id,
    required this.idOrden,
    required this.monto,
    required this.metodoPago,
    this.idPagoRevertido,
    required this.fechaPago,
  }) : super._();

  factory _$PagoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PagoImplFromJson(json);

  @override
  final String id;
  @override
  final String idOrden;
  @override
  final double monto;
  @override
  final MetodoPago metodoPago;
  @override
  final String? idPagoRevertido;
  @override
  final DateTime fechaPago;

  @override
  String toString() {
    return 'Pago(id: $id, idOrden: $idOrden, monto: $monto, metodoPago: $metodoPago, idPagoRevertido: $idPagoRevertido, fechaPago: $fechaPago)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PagoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.idOrden, idOrden) || other.idOrden == idOrden) &&
            (identical(other.monto, monto) || other.monto == monto) &&
            (identical(other.metodoPago, metodoPago) ||
                other.metodoPago == metodoPago) &&
            (identical(other.idPagoRevertido, idPagoRevertido) ||
                other.idPagoRevertido == idPagoRevertido) &&
            (identical(other.fechaPago, fechaPago) ||
                other.fechaPago == fechaPago));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    idOrden,
    monto,
    metodoPago,
    idPagoRevertido,
    fechaPago,
  );

  /// Create a copy of Pago
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PagoImplCopyWith<_$PagoImpl> get copyWith =>
      __$$PagoImplCopyWithImpl<_$PagoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PagoImplToJson(this);
  }
}

abstract class _Pago extends Pago {
  const factory _Pago({
    required final String id,
    required final String idOrden,
    required final double monto,
    required final MetodoPago metodoPago,
    final String? idPagoRevertido,
    required final DateTime fechaPago,
  }) = _$PagoImpl;
  const _Pago._() : super._();

  factory _Pago.fromJson(Map<String, dynamic> json) = _$PagoImpl.fromJson;

  @override
  String get id;
  @override
  String get idOrden;
  @override
  double get monto;
  @override
  MetodoPago get metodoPago;
  @override
  String? get idPagoRevertido;
  @override
  DateTime get fechaPago;

  /// Create a copy of Pago
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PagoImplCopyWith<_$PagoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
