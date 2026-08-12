// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crear_orden_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$evidenciaOtRemoteDatasourceHash() =>
    r'176b963c9e04eb64d5e7af3f2aafca29a0af67ae';

/// See also [evidenciaOtRemoteDatasource].
@ProviderFor(evidenciaOtRemoteDatasource)
final evidenciaOtRemoteDatasourceProvider =
    AutoDisposeProvider<EvidenciaOtRemoteDatasource>.internal(
      evidenciaOtRemoteDatasource,
      name: r'evidenciaOtRemoteDatasourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$evidenciaOtRemoteDatasourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EvidenciaOtRemoteDatasourceRef =
    AutoDisposeProviderRef<EvidenciaOtRemoteDatasource>;
String _$evidenciaOtMockDatasourceHash() =>
    r'8c003fc76cb95697e9072753afcc81e08fa91c4d';

/// See also [evidenciaOtMockDatasource].
@ProviderFor(evidenciaOtMockDatasource)
final evidenciaOtMockDatasourceProvider =
    AutoDisposeProvider<MockEvidenciaOtDatasource>.internal(
      evidenciaOtMockDatasource,
      name: r'evidenciaOtMockDatasourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$evidenciaOtMockDatasourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EvidenciaOtMockDatasourceRef =
    AutoDisposeProviderRef<MockEvidenciaOtDatasource>;
String _$evidenciaOtRepositoryHash() =>
    r'2689ee51bae005a2e9c46240ffabc6262c26aab0';

/// See also [evidenciaOtRepository].
@ProviderFor(evidenciaOtRepository)
final evidenciaOtRepositoryProvider =
    AutoDisposeProvider<EvidenciaOtRepository>.internal(
      evidenciaOtRepository,
      name: r'evidenciaOtRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$evidenciaOtRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EvidenciaOtRepositoryRef =
    AutoDisposeProviderRef<EvidenciaOtRepository>;
String _$subirEvidenciaOtUseCaseHash() =>
    r'b50a1483e6686e748a32a69e42dbb869096acacb';

/// See also [subirEvidenciaOtUseCase].
@ProviderFor(subirEvidenciaOtUseCase)
final subirEvidenciaOtUseCaseProvider =
    AutoDisposeProvider<SubirEvidenciaOT>.internal(
      subirEvidenciaOtUseCase,
      name: r'subirEvidenciaOtUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$subirEvidenciaOtUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubirEvidenciaOtUseCaseRef = AutoDisposeProviderRef<SubirEvidenciaOT>;
String _$evidenciasPorOrdenHash() =>
    r'0c926643b09ca9d517bec1c2be78e4ee89bd8570';

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

/// See also [evidenciasPorOrden].
@ProviderFor(evidenciasPorOrden)
const evidenciasPorOrdenProvider = EvidenciasPorOrdenFamily();

/// See also [evidenciasPorOrden].
class EvidenciasPorOrdenFamily extends Family<AsyncValue<List<EvidenciaOt>>> {
  /// See also [evidenciasPorOrden].
  const EvidenciasPorOrdenFamily();

  /// See also [evidenciasPorOrden].
  EvidenciasPorOrdenProvider call(String idOrden) {
    return EvidenciasPorOrdenProvider(idOrden);
  }

  @override
  EvidenciasPorOrdenProvider getProviderOverride(
    covariant EvidenciasPorOrdenProvider provider,
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
  String? get name => r'evidenciasPorOrdenProvider';
}

/// See also [evidenciasPorOrden].
class EvidenciasPorOrdenProvider
    extends AutoDisposeFutureProvider<List<EvidenciaOt>> {
  /// See also [evidenciasPorOrden].
  EvidenciasPorOrdenProvider(String idOrden)
    : this._internal(
        (ref) => evidenciasPorOrden(ref as EvidenciasPorOrdenRef, idOrden),
        from: evidenciasPorOrdenProvider,
        name: r'evidenciasPorOrdenProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$evidenciasPorOrdenHash,
        dependencies: EvidenciasPorOrdenFamily._dependencies,
        allTransitiveDependencies:
            EvidenciasPorOrdenFamily._allTransitiveDependencies,
        idOrden: idOrden,
      );

  EvidenciasPorOrdenProvider._internal(
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
    FutureOr<List<EvidenciaOt>> Function(EvidenciasPorOrdenRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EvidenciasPorOrdenProvider._internal(
        (ref) => create(ref as EvidenciasPorOrdenRef),
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
  AutoDisposeFutureProviderElement<List<EvidenciaOt>> createElement() {
    return _EvidenciasPorOrdenProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EvidenciasPorOrdenProvider && other.idOrden == idOrden;
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
mixin EvidenciasPorOrdenRef on AutoDisposeFutureProviderRef<List<EvidenciaOt>> {
  /// The parameter `idOrden` of this provider.
  String get idOrden;
}

class _EvidenciasPorOrdenProviderElement
    extends AutoDisposeFutureProviderElement<List<EvidenciaOt>>
    with EvidenciasPorOrdenRef {
  _EvidenciasPorOrdenProviderElement(super.provider);

  @override
  String get idOrden => (origin as EvidenciasPorOrdenProvider).idOrden;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
