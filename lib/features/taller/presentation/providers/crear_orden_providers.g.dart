// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crear_orden_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(evidenciaOtRemoteDatasource)
final evidenciaOtRemoteDatasourceProvider =
    EvidenciaOtRemoteDatasourceProvider._();

final class EvidenciaOtRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          EvidenciaOtRemoteDatasource,
          EvidenciaOtRemoteDatasource,
          EvidenciaOtRemoteDatasource
        >
    with $Provider<EvidenciaOtRemoteDatasource> {
  EvidenciaOtRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'evidenciaOtRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$evidenciaOtRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<EvidenciaOtRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EvidenciaOtRemoteDatasource create(Ref ref) {
    return evidenciaOtRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EvidenciaOtRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EvidenciaOtRemoteDatasource>(value),
    );
  }
}

String _$evidenciaOtRemoteDatasourceHash() =>
    r'176b963c9e04eb64d5e7af3f2aafca29a0af67ae';

@ProviderFor(evidenciaOtMockDatasource)
final evidenciaOtMockDatasourceProvider = EvidenciaOtMockDatasourceProvider._();

final class EvidenciaOtMockDatasourceProvider
    extends
        $FunctionalProvider<
          MockEvidenciaOtDatasource,
          MockEvidenciaOtDatasource,
          MockEvidenciaOtDatasource
        >
    with $Provider<MockEvidenciaOtDatasource> {
  EvidenciaOtMockDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'evidenciaOtMockDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$evidenciaOtMockDatasourceHash();

  @$internal
  @override
  $ProviderElement<MockEvidenciaOtDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MockEvidenciaOtDatasource create(Ref ref) {
    return evidenciaOtMockDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MockEvidenciaOtDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MockEvidenciaOtDatasource>(value),
    );
  }
}

String _$evidenciaOtMockDatasourceHash() =>
    r'8c003fc76cb95697e9072753afcc81e08fa91c4d';

@ProviderFor(evidenciaOtRepository)
final evidenciaOtRepositoryProvider = EvidenciaOtRepositoryProvider._();

final class EvidenciaOtRepositoryProvider
    extends
        $FunctionalProvider<
          EvidenciaOtRepository,
          EvidenciaOtRepository,
          EvidenciaOtRepository
        >
    with $Provider<EvidenciaOtRepository> {
  EvidenciaOtRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'evidenciaOtRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$evidenciaOtRepositoryHash();

  @$internal
  @override
  $ProviderElement<EvidenciaOtRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EvidenciaOtRepository create(Ref ref) {
    return evidenciaOtRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EvidenciaOtRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EvidenciaOtRepository>(value),
    );
  }
}

String _$evidenciaOtRepositoryHash() =>
    r'2689ee51bae005a2e9c46240ffabc6262c26aab0';

@ProviderFor(subirEvidenciaOtUseCase)
final subirEvidenciaOtUseCaseProvider = SubirEvidenciaOtUseCaseProvider._();

final class SubirEvidenciaOtUseCaseProvider
    extends
        $FunctionalProvider<
          SubirEvidenciaOT,
          SubirEvidenciaOT,
          SubirEvidenciaOT
        >
    with $Provider<SubirEvidenciaOT> {
  SubirEvidenciaOtUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subirEvidenciaOtUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subirEvidenciaOtUseCaseHash();

  @$internal
  @override
  $ProviderElement<SubirEvidenciaOT> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SubirEvidenciaOT create(Ref ref) {
    return subirEvidenciaOtUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubirEvidenciaOT value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubirEvidenciaOT>(value),
    );
  }
}

String _$subirEvidenciaOtUseCaseHash() =>
    r'b50a1483e6686e748a32a69e42dbb869096acacb';

@ProviderFor(evidenciasPorOrden)
final evidenciasPorOrdenProvider = EvidenciasPorOrdenFamily._();

final class EvidenciasPorOrdenProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EvidenciaOt>>,
          List<EvidenciaOt>,
          FutureOr<List<EvidenciaOt>>
        >
    with
        $FutureModifier<List<EvidenciaOt>>,
        $FutureProvider<List<EvidenciaOt>> {
  EvidenciasPorOrdenProvider._({
    required EvidenciasPorOrdenFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'evidenciasPorOrdenProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$evidenciasPorOrdenHash();

  @override
  String toString() {
    return r'evidenciasPorOrdenProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<EvidenciaOt>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<EvidenciaOt>> create(Ref ref) {
    final argument = this.argument as String;
    return evidenciasPorOrden(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EvidenciasPorOrdenProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$evidenciasPorOrdenHash() =>
    r'a7cf9982cbdeaae31f739b33b3ce6a3cba1a35b4';

final class EvidenciasPorOrdenFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<EvidenciaOt>>, String> {
  EvidenciasPorOrdenFamily._()
    : super(
        retry: null,
        name: r'evidenciasPorOrdenProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EvidenciasPorOrdenProvider call(String idOrden) =>
      EvidenciasPorOrdenProvider._(argument: idOrden, from: this);

  @override
  String toString() => r'evidenciasPorOrdenProvider';
}
