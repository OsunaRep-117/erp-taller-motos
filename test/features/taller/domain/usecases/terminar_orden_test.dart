import 'package:dartz/dartz.dart';
import 'package:erp_flutter/core/errors/failures.dart';
import 'package:erp_flutter/features/taller/domain/entities/orden_trabajo.dart';
import 'package:erp_flutter/features/taller/domain/repositories/orden_trabajo_repository.dart';
import 'package:erp_flutter/features/taller/domain/usecases/terminar_orden.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOrdenTrabajoRepository extends Mock
    implements OrdenTrabajoRepository {}

void main() {
  late TerminarOrden useCase;
  late MockOrdenTrabajoRepository mockOrdenRepository;

  setUp(() {
    mockOrdenRepository = MockOrdenTrabajoRepository();
    useCase = TerminarOrden(mockOrdenRepository);
  });

  const tIdOrden = 'ORD-1';
  const tIdMecanico = 'emp-mec';

  final tOrdenAsignada = OrdenTrabajo(
    id: tIdOrden,
    idMoto: 'MOTO-1',
    idMecanico: tIdMecanico,
    estado: EstadoOrdenTrabajo.enProceso,
    fallaReportada: 'Falla',
    fechaCreacion: DateTime.now(),
  );

  final tOrdenTerminada = tOrdenAsignada.copyWith(
    estado: EstadoOrdenTrabajo.terminado,
    saldoPendiente: 700,
  );

  test(
    'debe marcar orden como terminada cuando el mecánico asignado la termina',
    () async {
      when(
        () => mockOrdenRepository.obtenerOrdenPorId(tIdOrden),
      ).thenAnswer((_) async => Right(tOrdenAsignada));
      when(
        () => mockOrdenRepository.marcarComoTerminada(tIdOrden),
      ).thenAnswer((_) async => Right(tOrdenTerminada));

      final result = await useCase(
        idOrden: tIdOrden,
        idEmpleadoActual: tIdMecanico,
      );

      expect(result, Right(tOrdenTerminada));
      verify(() => mockOrdenRepository.marcarComoTerminada(tIdOrden));
    },
  );

  test('debe fallar si la orden no tiene mecánico asignado', () async {
    final sinMecanico = tOrdenAsignada.copyWith(idMecanico: null);
    when(
      () => mockOrdenRepository.obtenerOrdenPorId(tIdOrden),
    ).thenAnswer((_) async => Right(sinMecanico));

    final result = await useCase(
      idOrden: tIdOrden,
      idEmpleadoActual: tIdMecanico,
    );

    expect(
      result,
      const Left(ReglaDeNegocioFailure('La orden no tiene mecánico asignado.')),
    );
    verifyNever(() => mockOrdenRepository.marcarComoTerminada(any()));
  });

  test('debe fallar si quien termina no es el mecánico asignado', () async {
    when(
      () => mockOrdenRepository.obtenerOrdenPorId(tIdOrden),
    ).thenAnswer((_) async => Right(tOrdenAsignada));

    final result = await useCase(
      idOrden: tIdOrden,
      idEmpleadoActual: 'otro-empleado',
    );

    expect(
      result,
      const Left(
        ReglaDeNegocioFailure(
          'Solo el mecánico asignado puede marcar la orden como terminada.',
        ),
      ),
    );
    verifyNever(() => mockOrdenRepository.marcarComoTerminada(any()));
  });
}
