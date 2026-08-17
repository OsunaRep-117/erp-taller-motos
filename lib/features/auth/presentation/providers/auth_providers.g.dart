// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'4fffb19a69e9bfcfa5661689c46e52781ad9fdbf';

@ProviderFor(iniciarSesionUseCase)
final iniciarSesionUseCaseProvider = IniciarSesionUseCaseProvider._();

final class IniciarSesionUseCaseProvider
    extends $FunctionalProvider<IniciarSesion, IniciarSesion, IniciarSesion>
    with $Provider<IniciarSesion> {
  IniciarSesionUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'iniciarSesionUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$iniciarSesionUseCaseHash();

  @$internal
  @override
  $ProviderElement<IniciarSesion> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IniciarSesion create(Ref ref) {
    return iniciarSesionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IniciarSesion value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IniciarSesion>(value),
    );
  }
}

String _$iniciarSesionUseCaseHash() =>
    r'df03c4bf9d25e8c7cd55254b9361c1d8a7798599';

@ProviderFor(iniciarSesionConGoogleUseCase)
final iniciarSesionConGoogleUseCaseProvider =
    IniciarSesionConGoogleUseCaseProvider._();

final class IniciarSesionConGoogleUseCaseProvider
    extends
        $FunctionalProvider<
          IniciarSesionConGoogle,
          IniciarSesionConGoogle,
          IniciarSesionConGoogle
        >
    with $Provider<IniciarSesionConGoogle> {
  IniciarSesionConGoogleUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'iniciarSesionConGoogleUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$iniciarSesionConGoogleUseCaseHash();

  @$internal
  @override
  $ProviderElement<IniciarSesionConGoogle> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IniciarSesionConGoogle create(Ref ref) {
    return iniciarSesionConGoogleUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IniciarSesionConGoogle value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IniciarSesionConGoogle>(value),
    );
  }
}

String _$iniciarSesionConGoogleUseCaseHash() =>
    r'e96d314af30e3eacb14bc3f4c454bf1ef4bf5b9b';

@ProviderFor(cerrarSesionUseCase)
final cerrarSesionUseCaseProvider = CerrarSesionUseCaseProvider._();

final class CerrarSesionUseCaseProvider
    extends $FunctionalProvider<CerrarSesion, CerrarSesion, CerrarSesion>
    with $Provider<CerrarSesion> {
  CerrarSesionUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cerrarSesionUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cerrarSesionUseCaseHash();

  @$internal
  @override
  $ProviderElement<CerrarSesion> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CerrarSesion create(Ref ref) {
    return cerrarSesionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CerrarSesion value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CerrarSesion>(value),
    );
  }
}

String _$cerrarSesionUseCaseHash() =>
    r'b79e2a13859cc0cc7691823b8f99626e8c5c40db';

@ProviderFor(authState)
final authStateProvider = AuthStateProvider._();

final class AuthStateProvider
    extends
        $FunctionalProvider<AsyncValue<Usuario?>, Usuario?, Stream<Usuario?>>
    with $FutureModifier<Usuario?>, $StreamProvider<Usuario?> {
  AuthStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStateHash();

  @$internal
  @override
  $StreamProviderElement<Usuario?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Usuario?> create(Ref ref) {
    return authState(ref);
  }
}

String _$authStateHash() => r'eec05dc35b70037aaf5ee332b274006ed51fd2c9';
