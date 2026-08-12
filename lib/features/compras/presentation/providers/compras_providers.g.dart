// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compras_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$comprasDataSourceHash() => r'3e07761603d6dfd3d82dbeeb425d35acb94c8c3e';

/// See also [comprasDataSource].
@ProviderFor(comprasDataSource)
final comprasDataSourceProvider =
    AutoDisposeProvider<ComprasDataSource>.internal(
      comprasDataSource,
      name: r'comprasDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$comprasDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ComprasDataSourceRef = AutoDisposeProviderRef<ComprasDataSource>;
String _$comprasRepositoryHash() => r'91b206249f090273d2aaba0bbd10aaf68339ee29';

/// See also [comprasRepository].
@ProviderFor(comprasRepository)
final comprasRepositoryProvider =
    AutoDisposeProvider<ComprasRepository>.internal(
      comprasRepository,
      name: r'comprasRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$comprasRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ComprasRepositoryRef = AutoDisposeProviderRef<ComprasRepository>;
String _$proveedoresDisponiblesHash() =>
    r'6b529474b1e54bf6e984d26656df4bbc8977b626';

/// See also [proveedoresDisponibles].
@ProviderFor(proveedoresDisponibles)
final proveedoresDisponiblesProvider =
    AutoDisposeFutureProvider<List<Proveedor>>.internal(
      proveedoresDisponibles,
      name: r'proveedoresDisponiblesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$proveedoresDisponiblesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProveedoresDisponiblesRef =
    AutoDisposeFutureProviderRef<List<Proveedor>>;
String _$entradasInventarioHash() =>
    r'7ce5fbe7a113239c523c532dd932f6cffc098a05';

/// See also [entradasInventario].
@ProviderFor(entradasInventario)
final entradasInventarioProvider =
    AutoDisposeFutureProvider<List<Map<String, dynamic>>>.internal(
      entradasInventario,
      name: r'entradasInventarioProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$entradasInventarioHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EntradasInventarioRef =
    AutoDisposeFutureProviderRef<List<Map<String, dynamic>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
