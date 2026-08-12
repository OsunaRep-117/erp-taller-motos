// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventario_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$inventarioDataSourceHash() =>
    r'80f9b5c71f4e8a6a00a80511a7594917cec16ef1';

/// See also [inventarioDataSource].
@ProviderFor(inventarioDataSource)
final inventarioDataSourceProvider =
    AutoDisposeProvider<InventarioDataSource>.internal(
      inventarioDataSource,
      name: r'inventarioDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$inventarioDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InventarioDataSourceRef = AutoDisposeProviderRef<InventarioDataSource>;
String _$inventarioRepositoryHash() =>
    r'a34cd8d730f15233a4e48c1887dc5c92681826d0';

/// See also [inventarioRepository].
@ProviderFor(inventarioRepository)
final inventarioRepositoryProvider =
    AutoDisposeProvider<InventarioRepository>.internal(
      inventarioRepository,
      name: r'inventarioRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$inventarioRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InventarioRepositoryRef = AutoDisposeProviderRef<InventarioRepository>;
String _$solicitarRefaccionUseCaseHash() =>
    r'4f83476b8a865e8a725d71b52e747bd2a0120a78';

/// See also [solicitarRefaccionUseCase].
@ProviderFor(solicitarRefaccionUseCase)
final solicitarRefaccionUseCaseProvider =
    AutoDisposeProvider<SolicitarRefaccionParaOrden>.internal(
      solicitarRefaccionUseCase,
      name: r'solicitarRefaccionUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$solicitarRefaccionUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SolicitarRefaccionUseCaseRef =
    AutoDisposeProviderRef<SolicitarRefaccionParaOrden>;
String _$confirmarSalidaUseCaseHash() =>
    r'b64463959256d739e47238916a1cb2b7d4aa2879';

/// See also [confirmarSalidaUseCase].
@ProviderFor(confirmarSalidaUseCase)
final confirmarSalidaUseCaseProvider =
    AutoDisposeProvider<ConfirmarSalidaInventario>.internal(
      confirmarSalidaUseCase,
      name: r'confirmarSalidaUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$confirmarSalidaUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConfirmarSalidaUseCaseRef =
    AutoDisposeProviderRef<ConfirmarSalidaInventario>;
String _$ajustarInventarioUseCaseHash() =>
    r'778903ff465c6da0c2d4d8c675eefe3bf4cfd3e3';

/// See also [ajustarInventarioUseCase].
@ProviderFor(ajustarInventarioUseCase)
final ajustarInventarioUseCaseProvider =
    AutoDisposeProvider<AjustarInventarioManual>.internal(
      ajustarInventarioUseCase,
      name: r'ajustarInventarioUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$ajustarInventarioUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AjustarInventarioUseCaseRef =
    AutoDisposeProviderRef<AjustarInventarioManual>;
String _$refaccionesDisponiblesHash() =>
    r'7e38e78977fcf63a401a2abae809f02f104a10d0';

/// See also [refaccionesDisponibles].
@ProviderFor(refaccionesDisponibles)
final refaccionesDisponiblesProvider =
    AutoDisposeFutureProvider<List<Refaccion>>.internal(
      refaccionesDisponibles,
      name: r'refaccionesDisponiblesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$refaccionesDisponiblesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RefaccionesDisponiblesRef =
    AutoDisposeFutureProviderRef<List<Refaccion>>;
String _$refaccionPorSkuHash() => r'56fa4ab5f65bc63e0c2ac10b772fa80510444dcc';

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

/// See also [refaccionPorSku].
@ProviderFor(refaccionPorSku)
const refaccionPorSkuProvider = RefaccionPorSkuFamily();

/// See also [refaccionPorSku].
class RefaccionPorSkuFamily extends Family<AsyncValue<Refaccion>> {
  /// See also [refaccionPorSku].
  const RefaccionPorSkuFamily();

  /// See also [refaccionPorSku].
  RefaccionPorSkuProvider call(String sku) {
    return RefaccionPorSkuProvider(sku);
  }

  @override
  RefaccionPorSkuProvider getProviderOverride(
    covariant RefaccionPorSkuProvider provider,
  ) {
    return call(provider.sku);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'refaccionPorSkuProvider';
}

/// See also [refaccionPorSku].
class RefaccionPorSkuProvider extends AutoDisposeFutureProvider<Refaccion> {
  /// See also [refaccionPorSku].
  RefaccionPorSkuProvider(String sku)
    : this._internal(
        (ref) => refaccionPorSku(ref as RefaccionPorSkuRef, sku),
        from: refaccionPorSkuProvider,
        name: r'refaccionPorSkuProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$refaccionPorSkuHash,
        dependencies: RefaccionPorSkuFamily._dependencies,
        allTransitiveDependencies:
            RefaccionPorSkuFamily._allTransitiveDependencies,
        sku: sku,
      );

  RefaccionPorSkuProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sku,
  }) : super.internal();

  final String sku;

  @override
  Override overrideWith(
    FutureOr<Refaccion> Function(RefaccionPorSkuRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RefaccionPorSkuProvider._internal(
        (ref) => create(ref as RefaccionPorSkuRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sku: sku,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Refaccion> createElement() {
    return _RefaccionPorSkuProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RefaccionPorSkuProvider && other.sku == sku;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sku.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RefaccionPorSkuRef on AutoDisposeFutureProviderRef<Refaccion> {
  /// The parameter `sku` of this provider.
  String get sku;
}

class _RefaccionPorSkuProviderElement
    extends AutoDisposeFutureProviderElement<Refaccion>
    with RefaccionPorSkuRef {
  _RefaccionPorSkuProviderElement(super.provider);

  @override
  String get sku => (origin as RefaccionPorSkuProvider).sku;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
