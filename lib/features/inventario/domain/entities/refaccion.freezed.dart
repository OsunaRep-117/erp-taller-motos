// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'refaccion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Refaccion _$RefaccionFromJson(Map<String, dynamic> json) {
  return _Refaccion.fromJson(json);
}

/// @nodoc
mixin _$Refaccion {
  String get sku => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  double get precioCosto => throw _privateConstructorUsedError;
  double get precioVenta => throw _privateConstructorUsedError;
  int get stockActual => throw _privateConstructorUsedError;
  int get stockReservado => throw _privateConstructorUsedError;
  int get stockMinimo => throw _privateConstructorUsedError;
  bool get inactivo => throw _privateConstructorUsedError;

  /// Serializes this Refaccion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Refaccion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RefaccionCopyWith<Refaccion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefaccionCopyWith<$Res> {
  factory $RefaccionCopyWith(Refaccion value, $Res Function(Refaccion) then) =
      _$RefaccionCopyWithImpl<$Res, Refaccion>;
  @useResult
  $Res call({
    String sku,
    String nombre,
    double precioCosto,
    double precioVenta,
    int stockActual,
    int stockReservado,
    int stockMinimo,
    bool inactivo,
  });
}

/// @nodoc
class _$RefaccionCopyWithImpl<$Res, $Val extends Refaccion>
    implements $RefaccionCopyWith<$Res> {
  _$RefaccionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Refaccion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sku = null,
    Object? nombre = null,
    Object? precioCosto = null,
    Object? precioVenta = null,
    Object? stockActual = null,
    Object? stockReservado = null,
    Object? stockMinimo = null,
    Object? inactivo = null,
  }) {
    return _then(
      _value.copyWith(
            sku: null == sku
                ? _value.sku
                : sku // ignore: cast_nullable_to_non_nullable
                      as String,
            nombre: null == nombre
                ? _value.nombre
                : nombre // ignore: cast_nullable_to_non_nullable
                      as String,
            precioCosto: null == precioCosto
                ? _value.precioCosto
                : precioCosto // ignore: cast_nullable_to_non_nullable
                      as double,
            precioVenta: null == precioVenta
                ? _value.precioVenta
                : precioVenta // ignore: cast_nullable_to_non_nullable
                      as double,
            stockActual: null == stockActual
                ? _value.stockActual
                : stockActual // ignore: cast_nullable_to_non_nullable
                      as int,
            stockReservado: null == stockReservado
                ? _value.stockReservado
                : stockReservado // ignore: cast_nullable_to_non_nullable
                      as int,
            stockMinimo: null == stockMinimo
                ? _value.stockMinimo
                : stockMinimo // ignore: cast_nullable_to_non_nullable
                      as int,
            inactivo: null == inactivo
                ? _value.inactivo
                : inactivo // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RefaccionImplCopyWith<$Res>
    implements $RefaccionCopyWith<$Res> {
  factory _$$RefaccionImplCopyWith(
    _$RefaccionImpl value,
    $Res Function(_$RefaccionImpl) then,
  ) = __$$RefaccionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String sku,
    String nombre,
    double precioCosto,
    double precioVenta,
    int stockActual,
    int stockReservado,
    int stockMinimo,
    bool inactivo,
  });
}

/// @nodoc
class __$$RefaccionImplCopyWithImpl<$Res>
    extends _$RefaccionCopyWithImpl<$Res, _$RefaccionImpl>
    implements _$$RefaccionImplCopyWith<$Res> {
  __$$RefaccionImplCopyWithImpl(
    _$RefaccionImpl _value,
    $Res Function(_$RefaccionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Refaccion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sku = null,
    Object? nombre = null,
    Object? precioCosto = null,
    Object? precioVenta = null,
    Object? stockActual = null,
    Object? stockReservado = null,
    Object? stockMinimo = null,
    Object? inactivo = null,
  }) {
    return _then(
      _$RefaccionImpl(
        sku: null == sku
            ? _value.sku
            : sku // ignore: cast_nullable_to_non_nullable
                  as String,
        nombre: null == nombre
            ? _value.nombre
            : nombre // ignore: cast_nullable_to_non_nullable
                  as String,
        precioCosto: null == precioCosto
            ? _value.precioCosto
            : precioCosto // ignore: cast_nullable_to_non_nullable
                  as double,
        precioVenta: null == precioVenta
            ? _value.precioVenta
            : precioVenta // ignore: cast_nullable_to_non_nullable
                  as double,
        stockActual: null == stockActual
            ? _value.stockActual
            : stockActual // ignore: cast_nullable_to_non_nullable
                  as int,
        stockReservado: null == stockReservado
            ? _value.stockReservado
            : stockReservado // ignore: cast_nullable_to_non_nullable
                  as int,
        stockMinimo: null == stockMinimo
            ? _value.stockMinimo
            : stockMinimo // ignore: cast_nullable_to_non_nullable
                  as int,
        inactivo: null == inactivo
            ? _value.inactivo
            : inactivo // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RefaccionImpl extends _Refaccion {
  const _$RefaccionImpl({
    required this.sku,
    required this.nombre,
    required this.precioCosto,
    required this.precioVenta,
    required this.stockActual,
    required this.stockReservado,
    required this.stockMinimo,
    this.inactivo = false,
  }) : super._();

  factory _$RefaccionImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefaccionImplFromJson(json);

  @override
  final String sku;
  @override
  final String nombre;
  @override
  final double precioCosto;
  @override
  final double precioVenta;
  @override
  final int stockActual;
  @override
  final int stockReservado;
  @override
  final int stockMinimo;
  @override
  @JsonKey()
  final bool inactivo;

  @override
  String toString() {
    return 'Refaccion(sku: $sku, nombre: $nombre, precioCosto: $precioCosto, precioVenta: $precioVenta, stockActual: $stockActual, stockReservado: $stockReservado, stockMinimo: $stockMinimo, inactivo: $inactivo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefaccionImpl &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.precioCosto, precioCosto) ||
                other.precioCosto == precioCosto) &&
            (identical(other.precioVenta, precioVenta) ||
                other.precioVenta == precioVenta) &&
            (identical(other.stockActual, stockActual) ||
                other.stockActual == stockActual) &&
            (identical(other.stockReservado, stockReservado) ||
                other.stockReservado == stockReservado) &&
            (identical(other.stockMinimo, stockMinimo) ||
                other.stockMinimo == stockMinimo) &&
            (identical(other.inactivo, inactivo) ||
                other.inactivo == inactivo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    sku,
    nombre,
    precioCosto,
    precioVenta,
    stockActual,
    stockReservado,
    stockMinimo,
    inactivo,
  );

  /// Create a copy of Refaccion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefaccionImplCopyWith<_$RefaccionImpl> get copyWith =>
      __$$RefaccionImplCopyWithImpl<_$RefaccionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RefaccionImplToJson(this);
  }
}

abstract class _Refaccion extends Refaccion {
  const factory _Refaccion({
    required final String sku,
    required final String nombre,
    required final double precioCosto,
    required final double precioVenta,
    required final int stockActual,
    required final int stockReservado,
    required final int stockMinimo,
    final bool inactivo,
  }) = _$RefaccionImpl;
  const _Refaccion._() : super._();

  factory _Refaccion.fromJson(Map<String, dynamic> json) =
      _$RefaccionImpl.fromJson;

  @override
  String get sku;
  @override
  String get nombre;
  @override
  double get precioCosto;
  @override
  double get precioVenta;
  @override
  int get stockActual;
  @override
  int get stockReservado;
  @override
  int get stockMinimo;
  @override
  bool get inactivo;

  /// Create a copy of Refaccion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefaccionImplCopyWith<_$RefaccionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
