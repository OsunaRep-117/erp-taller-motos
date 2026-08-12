// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'motocicleta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Motocicleta _$MotocicletaFromJson(Map<String, dynamic> json) {
  return _Motocicleta.fromJson(json);
}

/// @nodoc
mixin _$Motocicleta {
  String get vin => throw _privateConstructorUsedError;
  String get placa => throw _privateConstructorUsedError;
  String get marca => throw _privateConstructorUsedError;
  String get modelo => throw _privateConstructorUsedError;
  int get anio => throw _privateConstructorUsedError;
  String get idCliente => throw _privateConstructorUsedError;

  /// Serializes this Motocicleta to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Motocicleta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MotocicletaCopyWith<Motocicleta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MotocicletaCopyWith<$Res> {
  factory $MotocicletaCopyWith(
    Motocicleta value,
    $Res Function(Motocicleta) then,
  ) = _$MotocicletaCopyWithImpl<$Res, Motocicleta>;
  @useResult
  $Res call({
    String vin,
    String placa,
    String marca,
    String modelo,
    int anio,
    String idCliente,
  });
}

/// @nodoc
class _$MotocicletaCopyWithImpl<$Res, $Val extends Motocicleta>
    implements $MotocicletaCopyWith<$Res> {
  _$MotocicletaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Motocicleta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vin = null,
    Object? placa = null,
    Object? marca = null,
    Object? modelo = null,
    Object? anio = null,
    Object? idCliente = null,
  }) {
    return _then(
      _value.copyWith(
            vin: null == vin
                ? _value.vin
                : vin // ignore: cast_nullable_to_non_nullable
                      as String,
            placa: null == placa
                ? _value.placa
                : placa // ignore: cast_nullable_to_non_nullable
                      as String,
            marca: null == marca
                ? _value.marca
                : marca // ignore: cast_nullable_to_non_nullable
                      as String,
            modelo: null == modelo
                ? _value.modelo
                : modelo // ignore: cast_nullable_to_non_nullable
                      as String,
            anio: null == anio
                ? _value.anio
                : anio // ignore: cast_nullable_to_non_nullable
                      as int,
            idCliente: null == idCliente
                ? _value.idCliente
                : idCliente // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MotocicletaImplCopyWith<$Res>
    implements $MotocicletaCopyWith<$Res> {
  factory _$$MotocicletaImplCopyWith(
    _$MotocicletaImpl value,
    $Res Function(_$MotocicletaImpl) then,
  ) = __$$MotocicletaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String vin,
    String placa,
    String marca,
    String modelo,
    int anio,
    String idCliente,
  });
}

/// @nodoc
class __$$MotocicletaImplCopyWithImpl<$Res>
    extends _$MotocicletaCopyWithImpl<$Res, _$MotocicletaImpl>
    implements _$$MotocicletaImplCopyWith<$Res> {
  __$$MotocicletaImplCopyWithImpl(
    _$MotocicletaImpl _value,
    $Res Function(_$MotocicletaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Motocicleta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vin = null,
    Object? placa = null,
    Object? marca = null,
    Object? modelo = null,
    Object? anio = null,
    Object? idCliente = null,
  }) {
    return _then(
      _$MotocicletaImpl(
        vin: null == vin
            ? _value.vin
            : vin // ignore: cast_nullable_to_non_nullable
                  as String,
        placa: null == placa
            ? _value.placa
            : placa // ignore: cast_nullable_to_non_nullable
                  as String,
        marca: null == marca
            ? _value.marca
            : marca // ignore: cast_nullable_to_non_nullable
                  as String,
        modelo: null == modelo
            ? _value.modelo
            : modelo // ignore: cast_nullable_to_non_nullable
                  as String,
        anio: null == anio
            ? _value.anio
            : anio // ignore: cast_nullable_to_non_nullable
                  as int,
        idCliente: null == idCliente
            ? _value.idCliente
            : idCliente // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MotocicletaImpl implements _Motocicleta {
  const _$MotocicletaImpl({
    required this.vin,
    required this.placa,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.idCliente,
  });

  factory _$MotocicletaImpl.fromJson(Map<String, dynamic> json) =>
      _$$MotocicletaImplFromJson(json);

  @override
  final String vin;
  @override
  final String placa;
  @override
  final String marca;
  @override
  final String modelo;
  @override
  final int anio;
  @override
  final String idCliente;

  @override
  String toString() {
    return 'Motocicleta(vin: $vin, placa: $placa, marca: $marca, modelo: $modelo, anio: $anio, idCliente: $idCliente)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MotocicletaImpl &&
            (identical(other.vin, vin) || other.vin == vin) &&
            (identical(other.placa, placa) || other.placa == placa) &&
            (identical(other.marca, marca) || other.marca == marca) &&
            (identical(other.modelo, modelo) || other.modelo == modelo) &&
            (identical(other.anio, anio) || other.anio == anio) &&
            (identical(other.idCliente, idCliente) ||
                other.idCliente == idCliente));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, vin, placa, marca, modelo, anio, idCliente);

  /// Create a copy of Motocicleta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MotocicletaImplCopyWith<_$MotocicletaImpl> get copyWith =>
      __$$MotocicletaImplCopyWithImpl<_$MotocicletaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MotocicletaImplToJson(this);
  }
}

abstract class _Motocicleta implements Motocicleta {
  const factory _Motocicleta({
    required final String vin,
    required final String placa,
    required final String marca,
    required final String modelo,
    required final int anio,
    required final String idCliente,
  }) = _$MotocicletaImpl;

  factory _Motocicleta.fromJson(Map<String, dynamic> json) =
      _$MotocicletaImpl.fromJson;

  @override
  String get vin;
  @override
  String get placa;
  @override
  String get marca;
  @override
  String get modelo;
  @override
  int get anio;
  @override
  String get idCliente;

  /// Create a copy of Motocicleta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MotocicletaImplCopyWith<_$MotocicletaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
