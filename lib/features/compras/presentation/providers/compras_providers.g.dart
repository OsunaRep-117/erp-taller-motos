// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compras_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(comprasDataSource)
final comprasDataSourceProvider = ComprasDataSourceProvider._();

final class ComprasDataSourceProvider
    extends
        $FunctionalProvider<
          ComprasDataSource,
          ComprasDataSource,
          ComprasDataSource
        >
    with $Provider<ComprasDataSource> {
  ComprasDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'comprasDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$comprasDataSourceHash();

  @$internal
  @override
  $ProviderElement<ComprasDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ComprasDataSource create(Ref ref) {
    return comprasDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ComprasDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ComprasDataSource>(value),
    );
  }
}

String _$comprasDataSourceHash() => r'3e07761603d6dfd3d82dbeeb425d35acb94c8c3e';

@ProviderFor(comprasRepository)
final comprasRepositoryProvider = ComprasRepositoryProvider._();

final class ComprasRepositoryProvider
    extends
        $FunctionalProvider<
          ComprasRepository,
          ComprasRepository,
          ComprasRepository
        >
    with $Provider<ComprasRepository> {
  ComprasRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'comprasRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$comprasRepositoryHash();

  @$internal
  @override
  $ProviderElement<ComprasRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ComprasRepository create(Ref ref) {
    return comprasRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ComprasRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ComprasRepository>(value),
    );
  }
}

String _$comprasRepositoryHash() => r'91b206249f090273d2aaba0bbd10aaf68339ee29';

@ProviderFor(proveedoresDisponibles)
final proveedoresDisponiblesProvider = ProveedoresDisponiblesProvider._();

final class ProveedoresDisponiblesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Proveedor>>,
          List<Proveedor>,
          FutureOr<List<Proveedor>>
        >
    with $FutureModifier<List<Proveedor>>, $FutureProvider<List<Proveedor>> {
  ProveedoresDisponiblesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'proveedoresDisponiblesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$proveedoresDisponiblesHash();

  @$internal
  @override
  $FutureProviderElement<List<Proveedor>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Proveedor>> create(Ref ref) {
    return proveedoresDisponibles(ref);
  }
}

String _$proveedoresDisponiblesHash() =>
    r'6b529474b1e54bf6e984d26656df4bbc8977b626';

@ProviderFor(entradasInventario)
final entradasInventarioProvider = EntradasInventarioProvider._();

final class EntradasInventarioProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          FutureOr<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $FutureProvider<List<Map<String, dynamic>>> {
  EntradasInventarioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'entradasInventarioProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$entradasInventarioHash();

  @$internal
  @override
  $FutureProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Map<String, dynamic>>> create(Ref ref) {
    return entradasInventario(ref);
  }
}

String _$entradasInventarioHash() =>
    r'7ce5fbe7a113239c523c532dd932f6cffc098a05';

@ProviderFor(ordenesCompraList)
final ordenesCompraListProvider = OrdenesCompraListProvider._();

final class OrdenesCompraListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OrdenCompra>>,
          List<OrdenCompra>,
          FutureOr<List<OrdenCompra>>
        >
    with
        $FutureModifier<List<OrdenCompra>>,
        $FutureProvider<List<OrdenCompra>> {
  OrdenesCompraListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ordenesCompraListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ordenesCompraListHash();

  @$internal
  @override
  $FutureProviderElement<List<OrdenCompra>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<OrdenCompra>> create(Ref ref) {
    return ordenesCompraList(ref);
  }
}

String _$ordenesCompraListHash() => r'fb80aa0dba7e4c7f569efca7138eb89b3b7a0efd';

@ProviderFor(crearOrdenCompraUseCase)
final crearOrdenCompraUseCaseProvider = CrearOrdenCompraUseCaseProvider._();

final class CrearOrdenCompraUseCaseProvider
    extends
        $FunctionalProvider<
          CrearOrdenCompra,
          CrearOrdenCompra,
          CrearOrdenCompra
        >
    with $Provider<CrearOrdenCompra> {
  CrearOrdenCompraUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'crearOrdenCompraUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$crearOrdenCompraUseCaseHash();

  @$internal
  @override
  $ProviderElement<CrearOrdenCompra> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CrearOrdenCompra create(Ref ref) {
    return crearOrdenCompraUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CrearOrdenCompra value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CrearOrdenCompra>(value),
    );
  }
}

String _$crearOrdenCompraUseCaseHash() =>
    r'b7fec54674e96d16696216a41568a142d73784ff';

@ProviderFor(aprobarOrdenCompraUseCase)
final aprobarOrdenCompraUseCaseProvider = AprobarOrdenCompraUseCaseProvider._();

final class AprobarOrdenCompraUseCaseProvider
    extends
        $FunctionalProvider<
          AprobarOrdenCompra,
          AprobarOrdenCompra,
          AprobarOrdenCompra
        >
    with $Provider<AprobarOrdenCompra> {
  AprobarOrdenCompraUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aprobarOrdenCompraUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aprobarOrdenCompraUseCaseHash();

  @$internal
  @override
  $ProviderElement<AprobarOrdenCompra> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AprobarOrdenCompra create(Ref ref) {
    return aprobarOrdenCompraUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AprobarOrdenCompra value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AprobarOrdenCompra>(value),
    );
  }
}

String _$aprobarOrdenCompraUseCaseHash() =>
    r'8eab7502e9f1321caa9fc2df0469777b201a24e5';

@ProviderFor(recibirOrdenCompraUseCase)
final recibirOrdenCompraUseCaseProvider = RecibirOrdenCompraUseCaseProvider._();

final class RecibirOrdenCompraUseCaseProvider
    extends
        $FunctionalProvider<
          RecibirOrdenCompra,
          RecibirOrdenCompra,
          RecibirOrdenCompra
        >
    with $Provider<RecibirOrdenCompra> {
  RecibirOrdenCompraUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recibirOrdenCompraUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recibirOrdenCompraUseCaseHash();

  @$internal
  @override
  $ProviderElement<RecibirOrdenCompra> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecibirOrdenCompra create(Ref ref) {
    return recibirOrdenCompraUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecibirOrdenCompra value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecibirOrdenCompra>(value),
    );
  }
}

String _$recibirOrdenCompraUseCaseHash() =>
    r'8e13ea52d83b4fa96dd1bff3ac2e94005d570a28';
