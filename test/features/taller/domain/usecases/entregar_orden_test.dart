import 'package:dartz/dartz.dart';
import 'package:erp_flutter/core/errors/failures.dart';
import 'package:erp_flutter/features/crm/domain/entities/cliente.dart';
import 'package:erp_flutter/features/crm/domain/entities/motocicleta.dart';
import 'package:erp_flutter/features/crm/domain/repositories/crm_repository.dart';
import 'package:erp_flutter/features/taller/domain/entities/orden_trabajo.dart';
import 'package:erp_flutter/features/taller/domain/repositories/orden_trabajo_repository.dart';
import 'package:erp_flutter/features/taller/domain/usecases/entregar_orden.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOrdenTrabajoRepository extends Mock
    implements OrdenTrabajoRepository {}

class MockCrmRepository extends Mock implements CrmRepository {}

void main() {
  late EntregarOrden useCase;
  late MockOrdenTrabajoRepository mockOrdenRepository;
  late MockCrmRepository mockCrmRepository;

  setUp(() {
    mockOrdenRepository = MockOrdenTrabajoRepository();
    mockCrmRepository = MockCrmRepository();
    useCase = EntregarOrden(mockOrdenRepository, mockCrmRepository);
  });

  const tIdOrden = 'ORD-1';
  const tVin = 'VIN-123';
  const tIdCliente = 'CLI-1';

  final tOrdenTerminadaConSaldo = OrdenTrabajo(
    id: tIdOrden,
    idMoto: tVin,
    estado: EstadoOrdenTrabajo.terminado,
    fallaReportada: 'Falla',
    saldoPendiente: 1000,
    fechaCreacion: DateTime.now(),
  );

  final tMoto = Motocicleta(
    vin: tVin,
    placa: 'ABC-123',
    marca: 'Honda',
    modelo: 'CBR',
    anio: 2023,
    idCliente: tIdCliente,
  );

  test('debe permitir entrega si saldo es 0', () async {
    final ordenSinSaldo = OrdenTrabajo(
      id: tIdOrden,
      idMoto: tVin,
      estado: EstadoOrdenTrabajo.terminado,
      fallaReportada: 'Falla',
      saldoPendiente: 0,
      fechaCreacion: DateTime.now(),
    );

    when(
      () => mockOrdenRepository.obtenerOrdenPorId(tIdOrden),
    ).thenAnswer((_) async => Right(ordenSinSaldo));
    when(
      () => mockOrdenRepository.marcarComoEntregada(tIdOrden),
    ).thenAnswer((_) async => Right(ordenSinSaldo));

    final result = await useCase(tIdOrden);

    expect(result, Right(ordenSinSaldo));
    verify(() => mockOrdenRepository.marcarComoEntregada(tIdOrden));
  });

  test('debe fallar entrega con saldo si el cliente NO es flotilla', () async {
    final clienteParticular = Cliente(
      id: tIdCliente,
      nombreCompleto: 'Juan',
      telefono: '123',
      esFlotilla: false,
    );

    when(
      () => mockOrdenRepository.obtenerOrdenPorId(tIdOrden),
    ).thenAnswer((_) async => Right(tOrdenTerminadaConSaldo));
    when(
      () => mockCrmRepository.obtenerMotocicletaPorVin(tVin),
    ).thenAnswer((_) async => Right(tMoto));
    when(
      () => mockCrmRepository.obtenerClientePorId(tIdCliente),
    ).thenAnswer((_) async => Right(clienteParticular));

    final result = await useCase(tIdOrden);

    expect(
      result,
      const Left(
        ReglaDeNegocioFailure(
          'Clientes particulares no pueden retirar vehículos con saldo pendiente.',
        ),
      ),
    );
  });

  test(
    'debe permitir entrega con saldo si el cliente ES flotilla y tiene crédito suficiente',
    () async {
      final clienteFlotilla = Cliente(
        id: tIdCliente,
        nombreCompleto: 'Empresa X',
        telefono: '123',
        esFlotilla: true,
        limiteCredito: 5000,
      );

      when(
        () => mockOrdenRepository.obtenerOrdenPorId(tIdOrden),
      ).thenAnswer((_) async => Right(tOrdenTerminadaConSaldo));
      when(
        () => mockCrmRepository.obtenerMotocicletaPorVin(tVin),
      ).thenAnswer((_) async => Right(tMoto));
      when(
        () => mockCrmRepository.obtenerClientePorId(tIdCliente),
      ).thenAnswer((_) async => Right(clienteFlotilla));
      when(
        () => mockCrmRepository.calcularExposicionCredito(tIdCliente),
      ).thenAnswer((_) async => const Right(1000));
      when(
        () => mockOrdenRepository.marcarComoEntregada(tIdOrden),
      ).thenAnswer((_) async => Right(tOrdenTerminadaConSaldo));

      final result = await useCase(tIdOrden);

      expect(result, Right(tOrdenTerminadaConSaldo));
      verify(() => mockOrdenRepository.marcarComoEntregada(tIdOrden));
      verify(() => mockCrmRepository.calcularExposicionCredito(tIdCliente));
    },
  );

  test(
    'debe fallar entrega con saldo si la exposición supera el límite de crédito',
    () async {
      final clienteFlotilla = Cliente(
        id: tIdCliente,
        nombreCompleto: 'Empresa X',
        telefono: '123',
        esFlotilla: true,
        limiteCredito: 500,
      );

      when(
        () => mockOrdenRepository.obtenerOrdenPorId(tIdOrden),
      ).thenAnswer((_) async => Right(tOrdenTerminadaConSaldo));
      when(
        () => mockCrmRepository.obtenerMotocicletaPorVin(tVin),
      ).thenAnswer((_) async => Right(tMoto));
      when(
        () => mockCrmRepository.obtenerClientePorId(tIdCliente),
      ).thenAnswer((_) async => Right(clienteFlotilla));
      when(
        () => mockCrmRepository.calcularExposicionCredito(tIdCliente),
      ).thenAnswer((_) async => const Right(1000));

      final result = await useCase(tIdOrden);

      expect(result.isLeft(), true);
      verifyNever(() => mockOrdenRepository.marcarComoEntregada(any()));
    },
  );
}
