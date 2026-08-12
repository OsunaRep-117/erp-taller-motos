// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finanzas_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$finanzasDataSourceHash() =>
    r'3c041308adc9448b0f2a7af3103c93709dfd53ac';

/// See also [finanzasDataSource].
@ProviderFor(finanzasDataSource)
final finanzasDataSourceProvider =
    AutoDisposeProvider<FinanzasDataSource>.internal(
      finanzasDataSource,
      name: r'finanzasDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$finanzasDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FinanzasDataSourceRef = AutoDisposeProviderRef<FinanzasDataSource>;
String _$finanzasRepositoryHash() =>
    r'803168c802a536b1fe4f330b832acd6e073a9421';

/// See also [finanzasRepository].
@ProviderFor(finanzasRepository)
final finanzasRepositoryProvider =
    AutoDisposeProvider<FinanzasRepository>.internal(
      finanzasRepository,
      name: r'finanzasRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$finanzasRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FinanzasRepositoryRef = AutoDisposeProviderRef<FinanzasRepository>;
String _$registrarPagoUseCaseHash() =>
    r'd551a0e6fee525e8cf18956a1f59bdc0c8212244';

/// See also [registrarPagoUseCase].
@ProviderFor(registrarPagoUseCase)
final registrarPagoUseCaseProvider =
    AutoDisposeProvider<RegistrarPago>.internal(
      registrarPagoUseCase,
      name: r'registrarPagoUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$registrarPagoUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RegistrarPagoUseCaseRef = AutoDisposeProviderRef<RegistrarPago>;
String _$emitirFacturaUseCaseHash() =>
    r'7fee879dfa9fd5dc7fcf00974e919c8c90a01989';

/// See also [emitirFacturaUseCase].
@ProviderFor(emitirFacturaUseCase)
final emitirFacturaUseCaseProvider =
    AutoDisposeProvider<EmitirFactura>.internal(
      emitirFacturaUseCase,
      name: r'emitirFacturaUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$emitirFacturaUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EmitirFacturaUseCaseRef = AutoDisposeProviderRef<EmitirFactura>;
String _$generarNotaCreditoUseCaseHash() =>
    r'5afb1d48e7ddcd88598ef60367b331956f975fc6';

/// See also [generarNotaCreditoUseCase].
@ProviderFor(generarNotaCreditoUseCase)
final generarNotaCreditoUseCaseProvider =
    AutoDisposeProvider<GenerarNotaCredito>.internal(
      generarNotaCreditoUseCase,
      name: r'generarNotaCreditoUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$generarNotaCreditoUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GenerarNotaCreditoUseCaseRef =
    AutoDisposeProviderRef<GenerarNotaCredito>;
String _$pagosPorOrdenHash() => r'ff1772d92c374d07387ef66823e01afea1455641';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [pagosPorOrden].
@ProviderFor(pagosPorOrden)
const pagosPorOrdenProvider = PagosPorOrdenFamily();

/// See also [pagosPorOrden].
class PagosPorOrdenFamily extends Family<AsyncValue<List<Pago>>> {
  /// See also [pagosPorOrden].
  const PagosPorOrdenFamily();

  /// See also [pagosPorOrden].
  PagosPorOrdenProvider call(String idOrden) {
    return PagosPorOrdenProvider(idOrden);
  }

  @override
  PagosPorOrdenProvider getProviderOverride(
    covariant PagosPorOrdenProvider provider,
  ) {
    return call(provider.idOrden);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'pagosPorOrdenProvider';
}

/// See also [pagosPorOrden].
class PagosPorOrdenProvider extends AutoDisposeFutureProvider<List<Pago>> {
  /// See also [pagosPorOrden].
  PagosPorOrdenProvider(String idOrden)
    : this._internal(
        (ref) => pagosPorOrden(ref as PagosPorOrdenRef, idOrden),
        from: pagosPorOrdenProvider,
        name: r'pagosPorOrdenProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$pagosPorOrdenHash,
        dependencies: PagosPorOrdenFamily._dependencies,
        allTransitiveDependencies:
            PagosPorOrdenFamily._allTransitiveDependencies,
        idOrden: idOrden,
      );

  PagosPorOrdenProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.idOrden,
  }) : super.internal();

  final String idOrden;

  @override
  Override overrideWith(
    FutureOr<List<Pago>> Function(PagosPorOrdenRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PagosPorOrdenProvider._internal(
        (ref) => create(ref as PagosPorOrdenRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        idOrden: idOrden,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Pago>> createElement() {
    return _PagosPorOrdenProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PagosPorOrdenProvider && other.idOrden == idOrden;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, idOrden.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PagosPorOrdenRef on AutoDisposeFutureProviderRef<List<Pago>> {
  /// The parameter `idOrden` of this provider.
  String get idOrden;
}

class _PagosPorOrdenProviderElement
    extends AutoDisposeFutureProviderElement<List<Pago>>
    with PagosPorOrdenRef {
  _PagosPorOrdenProviderElement(super.provider);

  @override
  String get idOrden => (origin as PagosPorOrdenProvider).idOrden;
}

String _$todosLosPagosHash() => r'e4e018cc9895f18ed623c6c22d37248b1490d488';

/// See also [todosLosPagos].
@ProviderFor(todosLosPagos)
final todosLosPagosProvider = AutoDisposeFutureProvider<List<Pago>>.internal(
  todosLosPagos,
  name: r'todosLosPagosProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todosLosPagosHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodosLosPagosRef = AutoDisposeFutureProviderRef<List<Pago>>;
String _$todasLasFacturasHash() => r'89e8135933e28a532d524ff698ab64d406d02cec';

/// See also [todasLasFacturas].
@ProviderFor(todasLasFacturas)
final todasLasFacturasProvider =
    AutoDisposeFutureProvider<List<Factura>>.internal(
      todasLasFacturas,
      name: r'todasLasFacturasProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todasLasFacturasHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodasLasFacturasRef = AutoDisposeFutureProviderRef<List<Factura>>;
String _$ingresosMensualesHash() => r'a846b2e8afb3403dff447710e6f9a6665385e960';

/// See also [ingresosMensuales].
@ProviderFor(ingresosMensuales)
final ingresosMensualesProvider = AutoDisposeFutureProvider<double>.internal(
  ingresosMensuales,
  name: r'ingresosMensualesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ingresosMensualesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IngresosMensualesRef = AutoDisposeFutureProviderRef<double>;
String _$valorInventarioHash() => r'dbcecb63535509e83646894be4c36f7e8a612374';

/// See also [valorInventario].
@ProviderFor(valorInventario)
final valorInventarioProvider = AutoDisposeFutureProvider<double>.internal(
  valorInventario,
  name: r'valorInventarioProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$valorInventarioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ValorInventarioRef = AutoDisposeFutureProviderRef<double>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
