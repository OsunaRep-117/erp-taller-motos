// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(posDataSource)
final posDataSourceProvider = PosDataSourceProvider._();

final class PosDataSourceProvider
    extends $FunctionalProvider<PosDataSource, PosDataSource, PosDataSource>
    with $Provider<PosDataSource> {
  PosDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'posDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$posDataSourceHash();

  @$internal
  @override
  $ProviderElement<PosDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PosDataSource create(Ref ref) {
    return posDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PosDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PosDataSource>(value),
    );
  }
}

String _$posDataSourceHash() => r'd5571cf825758ad4cb35f5be28a004e17a7895be';

@ProviderFor(posRepository)
final posRepositoryProvider = PosRepositoryProvider._();

final class PosRepositoryProvider
    extends $FunctionalProvider<PosRepository, PosRepository, PosRepository>
    with $Provider<PosRepository> {
  PosRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'posRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$posRepositoryHash();

  @$internal
  @override
  $ProviderElement<PosRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PosRepository create(Ref ref) {
    return posRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PosRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PosRepository>(value),
    );
  }
}

String _$posRepositoryHash() => r'47838d4ca7120d9106583bd5c8158e305e66412e';

@ProviderFor(registrarVentaUseCase)
final registrarVentaUseCaseProvider = RegistrarVentaUseCaseProvider._();

final class RegistrarVentaUseCaseProvider
    extends $FunctionalProvider<RegistrarVenta, RegistrarVenta, RegistrarVenta>
    with $Provider<RegistrarVenta> {
  RegistrarVentaUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registrarVentaUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registrarVentaUseCaseHash();

  @$internal
  @override
  $ProviderElement<RegistrarVenta> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RegistrarVenta create(Ref ref) {
    return registrarVentaUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegistrarVenta value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegistrarVenta>(value),
    );
  }
}

String _$registrarVentaUseCaseHash() =>
    r'4c8c27644a2dca169e226042ab33bb679f964dc6';

@ProviderFor(cierreCajaCiegoUseCase)
final cierreCajaCiegoUseCaseProvider = CierreCajaCiegoUseCaseProvider._();

final class CierreCajaCiegoUseCaseProvider
    extends
        $FunctionalProvider<CierreCajaCiego, CierreCajaCiego, CierreCajaCiego>
    with $Provider<CierreCajaCiego> {
  CierreCajaCiegoUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cierreCajaCiegoUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cierreCajaCiegoUseCaseHash();

  @$internal
  @override
  $ProviderElement<CierreCajaCiego> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CierreCajaCiego create(Ref ref) {
    return cierreCajaCiegoUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CierreCajaCiego value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CierreCajaCiego>(value),
    );
  }
}

String _$cierreCajaCiegoUseCaseHash() =>
    r'aa9a76878bbe16c362bb235092d04dbdf313bddf';

@ProviderFor(devolverVentaPosUseCase)
final devolverVentaPosUseCaseProvider = DevolverVentaPosUseCaseProvider._();

final class DevolverVentaPosUseCaseProvider
    extends
        $FunctionalProvider<
          DevolverVentaPos,
          DevolverVentaPos,
          DevolverVentaPos
        >
    with $Provider<DevolverVentaPos> {
  DevolverVentaPosUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'devolverVentaPosUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$devolverVentaPosUseCaseHash();

  @$internal
  @override
  $ProviderElement<DevolverVentaPos> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DevolverVentaPos create(Ref ref) {
    return devolverVentaPosUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DevolverVentaPos value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DevolverVentaPos>(value),
    );
  }
}

String _$devolverVentaPosUseCaseHash() =>
    r'708da9d987fa0b7f45d1daccdf62f873e13a3b7a';

@ProviderFor(refaccionesPos)
final refaccionesPosProvider = RefaccionesPosProvider._();

final class RefaccionesPosProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          FutureOr<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $FutureProvider<List<Map<String, dynamic>>> {
  RefaccionesPosProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refaccionesPosProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refaccionesPosHash();

  @$internal
  @override
  $FutureProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Map<String, dynamic>>> create(Ref ref) {
    return refaccionesPos(ref);
  }
}

String _$refaccionesPosHash() => r'9d8f98c877b2c7987909dd98a77d65d2070a9a22';

@ProviderFor(ventasPosHistorial)
final ventasPosHistorialProvider = VentasPosHistorialProvider._();

final class VentasPosHistorialProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          FutureOr<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $FutureProvider<List<Map<String, dynamic>>> {
  VentasPosHistorialProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ventasPosHistorialProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ventasPosHistorialHash();

  @$internal
  @override
  $FutureProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Map<String, dynamic>>> create(Ref ref) {
    return ventasPosHistorial(ref);
  }
}

String _$ventasPosHistorialHash() =>
    r'a4533afa8144793acd0c7b89080d6170fef34a9e';
