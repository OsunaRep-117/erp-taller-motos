// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crm_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$crmDataSourceHash() => r'2b4d88968352012e18b2e0847ff75eba10617916';

/// See also [crmDataSource].
@ProviderFor(crmDataSource)
final crmDataSourceProvider = AutoDisposeProvider<CrmDataSource>.internal(
  crmDataSource,
  name: r'crmDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$crmDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CrmDataSourceRef = AutoDisposeProviderRef<CrmDataSource>;
String _$crmRepositoryHash() => r'fb2a6cdff4c82a72fca68a3cf9a524dbfcf2784b';

/// See also [crmRepository].
@ProviderFor(crmRepository)
final crmRepositoryProvider = AutoDisposeProvider<CrmRepository>.internal(
  crmRepository,
  name: r'crmRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$crmRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CrmRepositoryRef = AutoDisposeProviderRef<CrmRepository>;
String _$crearClienteUseCaseHash() =>
    r'6b94c94170d97fc08ff9da0374f5e0e52f5c2f61';

/// See also [crearClienteUseCase].
@ProviderFor(crearClienteUseCase)
final crearClienteUseCaseProvider = AutoDisposeProvider<CrearCliente>.internal(
  crearClienteUseCase,
  name: r'crearClienteUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$crearClienteUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CrearClienteUseCaseRef = AutoDisposeProviderRef<CrearCliente>;
String _$crearMotocicletaUseCaseHash() =>
    r'805138ca42102a4f82779402f7a885c730a0f602';

/// See also [crearMotocicletaUseCase].
@ProviderFor(crearMotocicletaUseCase)
final crearMotocicletaUseCaseProvider =
    AutoDisposeProvider<CrearMotocicleta>.internal(
      crearMotocicletaUseCase,
      name: r'crearMotocicletaUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$crearMotocicletaUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CrearMotocicletaUseCaseRef = AutoDisposeProviderRef<CrearMotocicleta>;
String _$actualizarClienteUseCaseHash() =>
    r'b542ca4eccb2e83e09146694e06bcd5d9f0bcac8';

/// See also [actualizarClienteUseCase].
@ProviderFor(actualizarClienteUseCase)
final actualizarClienteUseCaseProvider =
    AutoDisposeProvider<ActualizarCliente>.internal(
      actualizarClienteUseCase,
      name: r'actualizarClienteUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$actualizarClienteUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActualizarClienteUseCaseRef = AutoDisposeProviderRef<ActualizarCliente>;
String _$actualizarMotocicletaUseCaseHash() =>
    r'b27afb79a365f59770a2640b67af7a5ee48237df';

/// See also [actualizarMotocicletaUseCase].
@ProviderFor(actualizarMotocicletaUseCase)
final actualizarMotocicletaUseCaseProvider =
    AutoDisposeProvider<ActualizarMotocicleta>.internal(
      actualizarMotocicletaUseCase,
      name: r'actualizarMotocicletaUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$actualizarMotocicletaUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActualizarMotocicletaUseCaseRef =
    AutoDisposeProviderRef<ActualizarMotocicleta>;
String _$clientesDisponiblesHash() =>
    r'd35fb963ac0bda2531910aa7160f8e6953ba9622';

/// See also [clientesDisponibles].
@ProviderFor(clientesDisponibles)
final clientesDisponiblesProvider =
    AutoDisposeFutureProvider<List<Cliente>>.internal(
      clientesDisponibles,
      name: r'clientesDisponiblesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$clientesDisponiblesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ClientesDisponiblesRef = AutoDisposeFutureProviderRef<List<Cliente>>;
String _$motocicletasCrmHash() => r'33fc6d45cf229f4f3d61e4a39a8b90590a08eddb';

/// See also [motocicletasCrm].
@ProviderFor(motocicletasCrm)
final motocicletasCrmProvider =
    AutoDisposeFutureProvider<List<Motocicleta>>.internal(
      motocicletasCrm,
      name: r'motocicletasCrmProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$motocicletasCrmHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MotocicletasCrmRef = AutoDisposeFutureProviderRef<List<Motocicleta>>;
String _$clientePorIdHash() => r'2168151a164ecc724d7dc850b0cc82612fc7746a';

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

/// See also [clientePorId].
@ProviderFor(clientePorId)
const clientePorIdProvider = ClientePorIdFamily();

/// See also [clientePorId].
class ClientePorIdFamily extends Family<AsyncValue<Cliente>> {
  /// See also [clientePorId].
  const ClientePorIdFamily();

  /// See also [clientePorId].
  ClientePorIdProvider call(String id) {
    return ClientePorIdProvider(id);
  }

  @override
  ClientePorIdProvider getProviderOverride(
    covariant ClientePorIdProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'clientePorIdProvider';
}

/// See also [clientePorId].
class ClientePorIdProvider extends AutoDisposeFutureProvider<Cliente> {
  /// See also [clientePorId].
  ClientePorIdProvider(String id)
    : this._internal(
        (ref) => clientePorId(ref as ClientePorIdRef, id),
        from: clientePorIdProvider,
        name: r'clientePorIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$clientePorIdHash,
        dependencies: ClientePorIdFamily._dependencies,
        allTransitiveDependencies:
            ClientePorIdFamily._allTransitiveDependencies,
        id: id,
      );

  ClientePorIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Cliente> Function(ClientePorIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ClientePorIdProvider._internal(
        (ref) => create(ref as ClientePorIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Cliente> createElement() {
    return _ClientePorIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ClientePorIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ClientePorIdRef on AutoDisposeFutureProviderRef<Cliente> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ClientePorIdProviderElement
    extends AutoDisposeFutureProviderElement<Cliente>
    with ClientePorIdRef {
  _ClientePorIdProviderElement(super.provider);

  @override
  String get id => (origin as ClientePorIdProvider).id;
}

String _$motocicletaPorVinHash() => r'3a41a7e625f7f4da524e0fc2ffe3373df8b157fe';

/// See also [motocicletaPorVin].
@ProviderFor(motocicletaPorVin)
const motocicletaPorVinProvider = MotocicletaPorVinFamily();

/// See also [motocicletaPorVin].
class MotocicletaPorVinFamily extends Family<AsyncValue<Motocicleta>> {
  /// See also [motocicletaPorVin].
  const MotocicletaPorVinFamily();

  /// See also [motocicletaPorVin].
  MotocicletaPorVinProvider call(String vin) {
    return MotocicletaPorVinProvider(vin);
  }

  @override
  MotocicletaPorVinProvider getProviderOverride(
    covariant MotocicletaPorVinProvider provider,
  ) {
    return call(provider.vin);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'motocicletaPorVinProvider';
}

/// See also [motocicletaPorVin].
class MotocicletaPorVinProvider extends AutoDisposeFutureProvider<Motocicleta> {
  /// See also [motocicletaPorVin].
  MotocicletaPorVinProvider(String vin)
    : this._internal(
        (ref) => motocicletaPorVin(ref as MotocicletaPorVinRef, vin),
        from: motocicletaPorVinProvider,
        name: r'motocicletaPorVinProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$motocicletaPorVinHash,
        dependencies: MotocicletaPorVinFamily._dependencies,
        allTransitiveDependencies:
            MotocicletaPorVinFamily._allTransitiveDependencies,
        vin: vin,
      );

  MotocicletaPorVinProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.vin,
  }) : super.internal();

  final String vin;

  @override
  Override overrideWith(
    FutureOr<Motocicleta> Function(MotocicletaPorVinRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MotocicletaPorVinProvider._internal(
        (ref) => create(ref as MotocicletaPorVinRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        vin: vin,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Motocicleta> createElement() {
    return _MotocicletaPorVinProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MotocicletaPorVinProvider && other.vin == vin;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, vin.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MotocicletaPorVinRef on AutoDisposeFutureProviderRef<Motocicleta> {
  /// The parameter `vin` of this provider.
  String get vin;
}

class _MotocicletaPorVinProviderElement
    extends AutoDisposeFutureProviderElement<Motocicleta>
    with MotocicletaPorVinRef {
  _MotocicletaPorVinProviderElement(super.provider);

  @override
  String get vin => (origin as MotocicletaPorVinProvider).vin;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
