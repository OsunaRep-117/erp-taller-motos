// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finanzas_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(finanzasDataSource)
final finanzasDataSourceProvider = FinanzasDataSourceProvider._();

final class FinanzasDataSourceProvider
    extends
        $FunctionalProvider<
          FinanzasDataSource,
          FinanzasDataSource,
          FinanzasDataSource
        >
    with $Provider<FinanzasDataSource> {
  FinanzasDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'finanzasDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$finanzasDataSourceHash();

  @$internal
  @override
  $ProviderElement<FinanzasDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FinanzasDataSource create(Ref ref) {
    return finanzasDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FinanzasDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FinanzasDataSource>(value),
    );
  }
}

String _$finanzasDataSourceHash() =>
    r'3c041308adc9448b0f2a7af3103c93709dfd53ac';

@ProviderFor(finanzasRepository)
final finanzasRepositoryProvider = FinanzasRepositoryProvider._();

final class FinanzasRepositoryProvider
    extends
        $FunctionalProvider<
          FinanzasRepository,
          FinanzasRepository,
          FinanzasRepository
        >
    with $Provider<FinanzasRepository> {
  FinanzasRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'finanzasRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$finanzasRepositoryHash();

  @$internal
  @override
  $ProviderElement<FinanzasRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FinanzasRepository create(Ref ref) {
    return finanzasRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FinanzasRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FinanzasRepository>(value),
    );
  }
}

String _$finanzasRepositoryHash() =>
    r'803168c802a536b1fe4f330b832acd6e073a9421';

@ProviderFor(registrarPagoUseCase)
final registrarPagoUseCaseProvider = RegistrarPagoUseCaseProvider._();

final class RegistrarPagoUseCaseProvider
    extends $FunctionalProvider<RegistrarPago, RegistrarPago, RegistrarPago>
    with $Provider<RegistrarPago> {
  RegistrarPagoUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registrarPagoUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registrarPagoUseCaseHash();

  @$internal
  @override
  $ProviderElement<RegistrarPago> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RegistrarPago create(Ref ref) {
    return registrarPagoUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegistrarPago value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegistrarPago>(value),
    );
  }
}

String _$registrarPagoUseCaseHash() =>
    r'd551a0e6fee525e8cf18956a1f59bdc0c8212244';

@ProviderFor(emitirFacturaUseCase)
final emitirFacturaUseCaseProvider = EmitirFacturaUseCaseProvider._();

final class EmitirFacturaUseCaseProvider
    extends $FunctionalProvider<EmitirFactura, EmitirFactura, EmitirFactura>
    with $Provider<EmitirFactura> {
  EmitirFacturaUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emitirFacturaUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emitirFacturaUseCaseHash();

  @$internal
  @override
  $ProviderElement<EmitirFactura> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EmitirFactura create(Ref ref) {
    return emitirFacturaUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmitirFactura value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmitirFactura>(value),
    );
  }
}

String _$emitirFacturaUseCaseHash() =>
    r'7fee879dfa9fd5dc7fcf00974e919c8c90a01989';

@ProviderFor(generarNotaCreditoUseCase)
final generarNotaCreditoUseCaseProvider = GenerarNotaCreditoUseCaseProvider._();

final class GenerarNotaCreditoUseCaseProvider
    extends
        $FunctionalProvider<
          GenerarNotaCredito,
          GenerarNotaCredito,
          GenerarNotaCredito
        >
    with $Provider<GenerarNotaCredito> {
  GenerarNotaCreditoUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'generarNotaCreditoUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$generarNotaCreditoUseCaseHash();

  @$internal
  @override
  $ProviderElement<GenerarNotaCredito> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GenerarNotaCredito create(Ref ref) {
    return generarNotaCreditoUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GenerarNotaCredito value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GenerarNotaCredito>(value),
    );
  }
}

String _$generarNotaCreditoUseCaseHash() =>
    r'5afb1d48e7ddcd88598ef60367b331956f975fc6';

@ProviderFor(revertirPagoUseCase)
final revertirPagoUseCaseProvider = RevertirPagoUseCaseProvider._();

final class RevertirPagoUseCaseProvider
    extends $FunctionalProvider<RevertirPago, RevertirPago, RevertirPago>
    with $Provider<RevertirPago> {
  RevertirPagoUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'revertirPagoUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$revertirPagoUseCaseHash();

  @$internal
  @override
  $ProviderElement<RevertirPago> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RevertirPago create(Ref ref) {
    return revertirPagoUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RevertirPago value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RevertirPago>(value),
    );
  }
}

String _$revertirPagoUseCaseHash() =>
    r'd82b0630211fb72546784bb247e774f2c7c5aba4';

@ProviderFor(registrarGastoOperativoUseCase)
final registrarGastoOperativoUseCaseProvider =
    RegistrarGastoOperativoUseCaseProvider._();

final class RegistrarGastoOperativoUseCaseProvider
    extends
        $FunctionalProvider<
          RegistrarGastoOperativo,
          RegistrarGastoOperativo,
          RegistrarGastoOperativo
        >
    with $Provider<RegistrarGastoOperativo> {
  RegistrarGastoOperativoUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registrarGastoOperativoUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registrarGastoOperativoUseCaseHash();

  @$internal
  @override
  $ProviderElement<RegistrarGastoOperativo> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RegistrarGastoOperativo create(Ref ref) {
    return registrarGastoOperativoUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegistrarGastoOperativo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegistrarGastoOperativo>(value),
    );
  }
}

String _$registrarGastoOperativoUseCaseHash() =>
    r'bf2901f1da7b9ef1776c5c39e550da2982b8dedb';

@ProviderFor(pagosPorOrden)
final pagosPorOrdenProvider = PagosPorOrdenFamily._();

final class PagosPorOrdenProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Pago>>,
          List<Pago>,
          FutureOr<List<Pago>>
        >
    with $FutureModifier<List<Pago>>, $FutureProvider<List<Pago>> {
  PagosPorOrdenProvider._({
    required PagosPorOrdenFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'pagosPorOrdenProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pagosPorOrdenHash();

  @override
  String toString() {
    return r'pagosPorOrdenProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Pago>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Pago>> create(Ref ref) {
    final argument = this.argument as String;
    return pagosPorOrden(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PagosPorOrdenProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pagosPorOrdenHash() => r'ff1772d92c374d07387ef66823e01afea1455641';

final class PagosPorOrdenFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Pago>>, String> {
  PagosPorOrdenFamily._()
    : super(
        retry: null,
        name: r'pagosPorOrdenProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PagosPorOrdenProvider call(String idOrden) =>
      PagosPorOrdenProvider._(argument: idOrden, from: this);

  @override
  String toString() => r'pagosPorOrdenProvider';
}

@ProviderFor(todosLosPagos)
final todosLosPagosProvider = TodosLosPagosProvider._();

final class TodosLosPagosProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Pago>>,
          List<Pago>,
          FutureOr<List<Pago>>
        >
    with $FutureModifier<List<Pago>>, $FutureProvider<List<Pago>> {
  TodosLosPagosProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todosLosPagosProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todosLosPagosHash();

  @$internal
  @override
  $FutureProviderElement<List<Pago>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Pago>> create(Ref ref) {
    return todosLosPagos(ref);
  }
}

String _$todosLosPagosHash() => r'e4e018cc9895f18ed623c6c22d37248b1490d488';

@ProviderFor(todasLasFacturas)
final todasLasFacturasProvider = TodasLasFacturasProvider._();

final class TodasLasFacturasProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Factura>>,
          List<Factura>,
          FutureOr<List<Factura>>
        >
    with $FutureModifier<List<Factura>>, $FutureProvider<List<Factura>> {
  TodasLasFacturasProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todasLasFacturasProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todasLasFacturasHash();

  @$internal
  @override
  $FutureProviderElement<List<Factura>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Factura>> create(Ref ref) {
    return todasLasFacturas(ref);
  }
}

String _$todasLasFacturasHash() => r'89e8135933e28a532d524ff698ab64d406d02cec';

@ProviderFor(ingresosMensuales)
final ingresosMensualesProvider = IngresosMensualesProvider._();

final class IngresosMensualesProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  IngresosMensualesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ingresosMensualesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ingresosMensualesHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return ingresosMensuales(ref);
  }
}

String _$ingresosMensualesHash() => r'a846b2e8afb3403dff447710e6f9a6665385e960';

@ProviderFor(valorInventario)
final valorInventarioProvider = ValorInventarioProvider._();

final class ValorInventarioProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  ValorInventarioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'valorInventarioProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$valorInventarioHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return valorInventario(ref);
  }
}

String _$valorInventarioHash() => r'dbcecb63535509e83646894be4c36f7e8a612374';

@ProviderFor(gastosOperativosMes)
final gastosOperativosMesProvider = GastosOperativosMesProvider._();

final class GastosOperativosMesProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  GastosOperativosMesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gastosOperativosMesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gastosOperativosMesHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return gastosOperativosMes(ref);
  }
}

String _$gastosOperativosMesHash() =>
    r'a416c10f18964835592f225b6e7befed002ad63d';
