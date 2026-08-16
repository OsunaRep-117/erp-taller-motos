// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventario_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(inventarioDataSource)
final inventarioDataSourceProvider = InventarioDataSourceProvider._();

final class InventarioDataSourceProvider
    extends
        $FunctionalProvider<
          InventarioDataSource,
          InventarioDataSource,
          InventarioDataSource
        >
    with $Provider<InventarioDataSource> {
  InventarioDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventarioDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventarioDataSourceHash();

  @$internal
  @override
  $ProviderElement<InventarioDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InventarioDataSource create(Ref ref) {
    return inventarioDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InventarioDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InventarioDataSource>(value),
    );
  }
}

String _$inventarioDataSourceHash() =>
    r'80f9b5c71f4e8a6a00a80511a7594917cec16ef1';

@ProviderFor(inventarioRepository)
final inventarioRepositoryProvider = InventarioRepositoryProvider._();

final class InventarioRepositoryProvider
    extends
        $FunctionalProvider<
          InventarioRepository,
          InventarioRepository,
          InventarioRepository
        >
    with $Provider<InventarioRepository> {
  InventarioRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventarioRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventarioRepositoryHash();

  @$internal
  @override
  $ProviderElement<InventarioRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InventarioRepository create(Ref ref) {
    return inventarioRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InventarioRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InventarioRepository>(value),
    );
  }
}

String _$inventarioRepositoryHash() =>
    r'a34cd8d730f15233a4e48c1887dc5c92681826d0';

@ProviderFor(solicitarRefaccionUseCase)
final solicitarRefaccionUseCaseProvider = SolicitarRefaccionUseCaseProvider._();

final class SolicitarRefaccionUseCaseProvider
    extends
        $FunctionalProvider<
          SolicitarRefaccionParaOrden,
          SolicitarRefaccionParaOrden,
          SolicitarRefaccionParaOrden
        >
    with $Provider<SolicitarRefaccionParaOrden> {
  SolicitarRefaccionUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'solicitarRefaccionUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$solicitarRefaccionUseCaseHash();

  @$internal
  @override
  $ProviderElement<SolicitarRefaccionParaOrden> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SolicitarRefaccionParaOrden create(Ref ref) {
    return solicitarRefaccionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SolicitarRefaccionParaOrden value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SolicitarRefaccionParaOrden>(value),
    );
  }
}

String _$solicitarRefaccionUseCaseHash() =>
    r'be2565add7781836cf5322b96bddb80bccbf12eb';

@ProviderFor(confirmarSalidaUseCase)
final confirmarSalidaUseCaseProvider = ConfirmarSalidaUseCaseProvider._();

final class ConfirmarSalidaUseCaseProvider
    extends
        $FunctionalProvider<
          ConfirmarSalidaInventario,
          ConfirmarSalidaInventario,
          ConfirmarSalidaInventario
        >
    with $Provider<ConfirmarSalidaInventario> {
  ConfirmarSalidaUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'confirmarSalidaUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$confirmarSalidaUseCaseHash();

  @$internal
  @override
  $ProviderElement<ConfirmarSalidaInventario> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConfirmarSalidaInventario create(Ref ref) {
    return confirmarSalidaUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConfirmarSalidaInventario value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConfirmarSalidaInventario>(value),
    );
  }
}

String _$confirmarSalidaUseCaseHash() =>
    r'b64463959256d739e47238916a1cb2b7d4aa2879';

@ProviderFor(ajustarInventarioUseCase)
final ajustarInventarioUseCaseProvider = AjustarInventarioUseCaseProvider._();

final class AjustarInventarioUseCaseProvider
    extends
        $FunctionalProvider<
          AjustarInventarioManual,
          AjustarInventarioManual,
          AjustarInventarioManual
        >
    with $Provider<AjustarInventarioManual> {
  AjustarInventarioUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ajustarInventarioUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ajustarInventarioUseCaseHash();

  @$internal
  @override
  $ProviderElement<AjustarInventarioManual> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AjustarInventarioManual create(Ref ref) {
    return ajustarInventarioUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AjustarInventarioManual value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AjustarInventarioManual>(value),
    );
  }
}

String _$ajustarInventarioUseCaseHash() =>
    r'778903ff465c6da0c2d4d8c675eefe3bf4cfd3e3';

@ProviderFor(refaccionesDisponibles)
final refaccionesDisponiblesProvider = RefaccionesDisponiblesProvider._();

final class RefaccionesDisponiblesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Refaccion>>,
          List<Refaccion>,
          FutureOr<List<Refaccion>>
        >
    with $FutureModifier<List<Refaccion>>, $FutureProvider<List<Refaccion>> {
  RefaccionesDisponiblesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refaccionesDisponiblesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refaccionesDisponiblesHash();

  @$internal
  @override
  $FutureProviderElement<List<Refaccion>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Refaccion>> create(Ref ref) {
    return refaccionesDisponibles(ref);
  }
}

String _$refaccionesDisponiblesHash() =>
    r'7e38e78977fcf63a401a2abae809f02f104a10d0';

@ProviderFor(reservasPorOrden)
final reservasPorOrdenProvider = ReservasPorOrdenFamily._();

final class ReservasPorOrdenProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          FutureOr<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $FutureProvider<List<Map<String, dynamic>>> {
  ReservasPorOrdenProvider._({
    required ReservasPorOrdenFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'reservasPorOrdenProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$reservasPorOrdenHash();

  @override
  String toString() {
    return r'reservasPorOrdenProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Map<String, dynamic>>> create(Ref ref) {
    final argument = this.argument as String;
    return reservasPorOrden(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ReservasPorOrdenProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reservasPorOrdenHash() => r'14c74e88128e71cb16e9d0e148685b86d36d51da';

final class ReservasPorOrdenFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Map<String, dynamic>>>,
          String
        > {
  ReservasPorOrdenFamily._()
    : super(
        retry: null,
        name: r'reservasPorOrdenProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ReservasPorOrdenProvider call(String idOrden) =>
      ReservasPorOrdenProvider._(argument: idOrden, from: this);

  @override
  String toString() => r'reservasPorOrdenProvider';
}

@ProviderFor(consumosPorOrden)
final consumosPorOrdenProvider = ConsumosPorOrdenFamily._();

final class ConsumosPorOrdenProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          FutureOr<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $FutureProvider<List<Map<String, dynamic>>> {
  ConsumosPorOrdenProvider._({
    required ConsumosPorOrdenFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'consumosPorOrdenProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$consumosPorOrdenHash();

  @override
  String toString() {
    return r'consumosPorOrdenProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Map<String, dynamic>>> create(Ref ref) {
    final argument = this.argument as String;
    return consumosPorOrden(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ConsumosPorOrdenProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$consumosPorOrdenHash() => r'92625b6aea94c631e0415ae6077219db1d61ad26';

final class ConsumosPorOrdenFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Map<String, dynamic>>>,
          String
        > {
  ConsumosPorOrdenFamily._()
    : super(
        retry: null,
        name: r'consumosPorOrdenProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ConsumosPorOrdenProvider call(String idOrden) =>
      ConsumosPorOrdenProvider._(argument: idOrden, from: this);

  @override
  String toString() => r'consumosPorOrdenProvider';
}

@ProviderFor(refaccionPorSku)
final refaccionPorSkuProvider = RefaccionPorSkuFamily._();

final class RefaccionPorSkuProvider
    extends
        $FunctionalProvider<
          AsyncValue<Refaccion>,
          Refaccion,
          FutureOr<Refaccion>
        >
    with $FutureModifier<Refaccion>, $FutureProvider<Refaccion> {
  RefaccionPorSkuProvider._({
    required RefaccionPorSkuFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'refaccionPorSkuProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$refaccionPorSkuHash();

  @override
  String toString() {
    return r'refaccionPorSkuProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Refaccion> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Refaccion> create(Ref ref) {
    final argument = this.argument as String;
    return refaccionPorSku(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RefaccionPorSkuProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$refaccionPorSkuHash() => r'56fa4ab5f65bc63e0c2ac10b772fa80510444dcc';

final class RefaccionPorSkuFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Refaccion>, String> {
  RefaccionPorSkuFamily._()
    : super(
        retry: null,
        name: r'refaccionPorSkuProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RefaccionPorSkuProvider call(String sku) =>
      RefaccionPorSkuProvider._(argument: sku, from: this);

  @override
  String toString() => r'refaccionPorSkuProvider';
}
