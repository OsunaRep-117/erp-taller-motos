// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cliente.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Cliente _$ClienteFromJson(Map<String, dynamic> json) {
  return _Cliente.fromJson(json);
}

/// @nodoc
mixin _$Cliente {
  String get id => throw _privateConstructorUsedError;
  String get nombreCompleto => throw _privateConstructorUsedError;
  String get telefono => throw _privateConstructorUsedError;
  String? get rfc => throw _privateConstructorUsedError;
  double get limiteCredito => throw _privateConstructorUsedError;
  bool get esFlotilla => throw _privateConstructorUsedError;

  /// Serializes this Cliente to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Cliente
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClienteCopyWith<Cliente> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClienteCopyWith<$Res> {
  factory $ClienteCopyWith(Cliente value, $Res Function(Cliente) then) =
      _$ClienteCopyWithImpl<$Res, Cliente>;
  @useResult
  $Res call({
    String id,
    String nombreCompleto,
    String telefono,
    String? rfc,
    double limiteCredito,
    bool esFlotilla,
  });
}

/// @nodoc
class _$ClienteCopyWithImpl<$Res, $Val extends Cliente>
    implements $ClienteCopyWith<$Res> {
  _$ClienteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Cliente
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombreCompleto = null,
    Object? telefono = null,
    Object? rfc = freezed,
    Object? limiteCredito = null,
    Object? esFlotilla = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            nombreCompleto: null == nombreCompleto
                ? _value.nombreCompleto
                : nombreCompleto // ignore: cast_nullable_to_non_nullable
                      as String,
            telefono: null == telefono
                ? _value.telefono
                : telefono // ignore: cast_nullable_to_non_nullable
                      as String,
            rfc: freezed == rfc
                ? _value.rfc
                : rfc // ignore: cast_nullable_to_non_nullable
                      as String?,
            limiteCredito: null == limiteCredito
                ? _value.limiteCredito
                : limiteCredito // ignore: cast_nullable_to_non_nullable
                      as double,
            esFlotilla: null == esFlotilla
                ? _value.esFlotilla
                : esFlotilla // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ClienteImplCopyWith<$Res> implements $ClienteCopyWith<$Res> {
  factory _$$ClienteImplCopyWith(
    _$ClienteImpl value,
    $Res Function(_$ClienteImpl) then,
  ) = __$$ClienteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String nombreCompleto,
    String telefono,
    String? rfc,
    double limiteCredito,
    bool esFlotilla,
  });
}

/// @nodoc
class __$$ClienteImplCopyWithImpl<$Res>
    extends _$ClienteCopyWithImpl<$Res, _$ClienteImpl>
    implements _$$ClienteImplCopyWith<$Res> {
  __$$ClienteImplCopyWithImpl(
    _$ClienteImpl _value,
    $Res Function(_$ClienteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Cliente
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombreCompleto = null,
    Object? telefono = null,
    Object? rfc = freezed,
    Object? limiteCredito = null,
    Object? esFlotilla = null,
  }) {
    return _then(
      _$ClienteImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        nombreCompleto: null == nombreCompleto
            ? _value.nombreCompleto
            : nombreCompleto // ignore: cast_nullable_to_non_nullable
                  as String,
        telefono: null == telefono
            ? _value.telefono
            : telefono // ignore: cast_nullable_to_non_nullable
                  as String,
        rfc: freezed == rfc
            ? _value.rfc
            : rfc // ignore: cast_nullable_to_non_nullable
                  as String?,
        limiteCredito: null == limiteCredito
            ? _value.limiteCredito
            : limiteCredito // ignore: cast_nullable_to_non_nullable
                  as double,
        esFlotilla: null == esFlotilla
            ? _value.esFlotilla
            : esFlotilla // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ClienteImpl extends _Cliente {
  const _$ClienteImpl({
    required this.id,
    required this.nombreCompleto,
    required this.telefono,
    this.rfc,
    this.limiteCredito = 0,
    this.esFlotilla = false,
  }) : super._();

  factory _$ClienteImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClienteImplFromJson(json);

  @override
  final String id;
  @override
  final String nombreCompleto;
  @override
  final String telefono;
  @override
  final String? rfc;
  @override
  @JsonKey()
  final double limiteCredito;
  @override
  @JsonKey()
  final bool esFlotilla;

  @override
  String toString() {
    return 'Cliente(id: $id, nombreCompleto: $nombreCompleto, telefono: $telefono, rfc: $rfc, limiteCredito: $limiteCredito, esFlotilla: $esFlotilla)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClienteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombreCompleto, nombreCompleto) ||
                other.nombreCompleto == nombreCompleto) &&
            (identical(other.telefono, telefono) ||
                other.telefono == telefono) &&
            (identical(other.rfc, rfc) || other.rfc == rfc) &&
            (identical(other.limiteCredito, limiteCredito) ||
                other.limiteCredito == limiteCredito) &&
            (identical(other.esFlotilla, esFlotilla) ||
                other.esFlotilla == esFlotilla));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    nombreCompleto,
    telefono,
    rfc,
    limiteCredito,
    esFlotilla,
  );

  /// Create a copy of Cliente
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClienteImplCopyWith<_$ClienteImpl> get copyWith =>
      __$$ClienteImplCopyWithImpl<_$ClienteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClienteImplToJson(this);
  }
}

abstract class _Cliente extends Cliente {
  const factory _Cliente({
    required final String id,
    required final String nombreCompleto,
    required final String telefono,
    final String? rfc,
    final double limiteCredito,
    final bool esFlotilla,
  }) = _$ClienteImpl;
  const _Cliente._() : super._();

  factory _Cliente.fromJson(Map<String, dynamic> json) = _$ClienteImpl.fromJson;

  @override
  String get id;
  @override
  String get nombreCompleto;
  @override
  String get telefono;
  @override
  String? get rfc;
  @override
  double get limiteCredito;
  @override
  bool get esFlotilla;

  /// Create a copy of Cliente
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClienteImplCopyWith<_$ClienteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
