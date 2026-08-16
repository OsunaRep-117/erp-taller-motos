// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rrhh_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(rrhhDataSource)
final rrhhDataSourceProvider = RrhhDataSourceProvider._();

final class RrhhDataSourceProvider
    extends $FunctionalProvider<RrhhDataSource, RrhhDataSource, RrhhDataSource>
    with $Provider<RrhhDataSource> {
  RrhhDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rrhhDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rrhhDataSourceHash();

  @$internal
  @override
  $ProviderElement<RrhhDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RrhhDataSource create(Ref ref) {
    return rrhhDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RrhhDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RrhhDataSource>(value),
    );
  }
}

String _$rrhhDataSourceHash() => r'8b3992d96ba21de1e5ad459b6d5f03dcf27f1a57';

@ProviderFor(rrhhRepository)
final rrhhRepositoryProvider = RrhhRepositoryProvider._();

final class RrhhRepositoryProvider
    extends $FunctionalProvider<RrhhRepository, RrhhRepository, RrhhRepository>
    with $Provider<RrhhRepository> {
  RrhhRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rrhhRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rrhhRepositoryHash();

  @$internal
  @override
  $ProviderElement<RrhhRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RrhhRepository create(Ref ref) {
    return rrhhRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RrhhRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RrhhRepository>(value),
    );
  }
}

String _$rrhhRepositoryHash() => r'b1052a8a8a6e9e668f3b563bf1eec0f4cdce4442';

@ProviderFor(comisionesVisibles)
final comisionesVisiblesProvider = ComisionesVisiblesProvider._();

final class ComisionesVisiblesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Comision>>,
          List<Comision>,
          FutureOr<List<Comision>>
        >
    with $FutureModifier<List<Comision>>, $FutureProvider<List<Comision>> {
  ComisionesVisiblesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'comisionesVisiblesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$comisionesVisiblesHash();

  @$internal
  @override
  $FutureProviderElement<List<Comision>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Comision>> create(Ref ref) {
    return comisionesVisibles(ref);
  }
}

String _$comisionesVisiblesHash() =>
    r'd14de7f25a7da0c5c16c89ffc1f2120b0239eaa3';

@ProviderFor(listaEmpleados)
final listaEmpleadosProvider = ListaEmpleadosProvider._();

final class ListaEmpleadosProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Empleado>>,
          List<Empleado>,
          FutureOr<List<Empleado>>
        >
    with $FutureModifier<List<Empleado>>, $FutureProvider<List<Empleado>> {
  ListaEmpleadosProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listaEmpleadosProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$listaEmpleadosHash();

  @$internal
  @override
  $FutureProviderElement<List<Empleado>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Empleado>> create(Ref ref) {
    return listaEmpleados(ref);
  }
}

String _$listaEmpleadosHash() => r'8eebe1ebc29e6a2d270da9fda6e9bad987c3cf36';

@ProviderFor(invitacionesPendientes)
final invitacionesPendientesProvider = InvitacionesPendientesProvider._();

final class InvitacionesPendientesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EmpleadoInvitacion>>,
          List<EmpleadoInvitacion>,
          FutureOr<List<EmpleadoInvitacion>>
        >
    with
        $FutureModifier<List<EmpleadoInvitacion>>,
        $FutureProvider<List<EmpleadoInvitacion>> {
  InvitacionesPendientesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'invitacionesPendientesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$invitacionesPendientesHash();

  @$internal
  @override
  $FutureProviderElement<List<EmpleadoInvitacion>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<EmpleadoInvitacion>> create(Ref ref) {
    return invitacionesPendientes(ref);
  }
}

String _$invitacionesPendientesHash() =>
    r'0d60ac1996fc344ddc8aa772ba2242e675112e1f';
