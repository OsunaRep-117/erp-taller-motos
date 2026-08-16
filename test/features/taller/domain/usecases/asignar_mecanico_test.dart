import 'package:dartz/dartz.dart';
import 'package:erp_flutter/core/errors/failures.dart';
import 'package:erp_flutter/features/taller/domain/entities/orden_trabajo.dart';
import 'package:erp_flutter/features/taller/domain/repositories/orden_trabajo_repository.dart';
import 'package:erp_flutter/features/taller/domain/usecases/asignar_mecanico.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOrdenTrabajoRepository extends Mock
    implements OrdenTrabajoRepository {}

void main() {
  late AsignarMecanico useCase;
  late MockOrdenTrabajoRepository mockRepository;

  setUp(() {
    mockRepository = MockOrdenTrabajoRepository();
    useCase = AsignarMecanico(mockRepository);
  });

  const tIdOrden = 'ORD-1';
  const tIdMecanico = 'MEC-1';
  final tOrden = OrdenTrabajo(
    id: tIdOrden,
    idMoto: 'MOTO-1',
    idMecanico: tIdMecanico,
    estado: EstadoOrdenTrabajo.enProceso,
    fallaReportada: 'Falla',
    fechaCreacion: DateTime.now(),
  );

  test('debe asignar mecánico a la orden a través del repositorio', () async {
    // arrange
    when(
      () => mockRepository.asignarMecanico(
        idOrden: any(named: 'idOrden'),
        idMecanico: any(named: 'idMecanico'),
      ),
    ).thenAnswer((_) async => Right(tOrden));

    // act
    final result = await useCase(idOrden: tIdOrden, idMecanico: tIdMecanico);

    // assert
    expect(result, Right(tOrden));
    verify(
      () => mockRepository.asignarMecanico(
        idOrden: tIdOrden,
        idMecanico: tIdMecanico,
      ),
    );
    verifyNoMoreInteractions(mockRepository);
  });

  test(
    'debe devolver ReglaDeNegocioFailure cuando el mecánico excede el límite',
    () async {
      // arrange
      when(
        () => mockRepository.asignarMecanico(
          idOrden: any(named: 'idOrden'),
          idMecanico: any(named: 'idMecanico'),
        ),
      ).thenAnswer(
        (_) async => const Left(ReglaDeNegocioFailure('Límite excedido')),
      );

      // act
      final result = await useCase(idOrden: tIdOrden, idMecanico: tIdMecanico);

      // assert
      expect(result, const Left(ReglaDeNegocioFailure('Límite excedido')));
      verify(
        () => mockRepository.asignarMecanico(
          idOrden: tIdOrden,
          idMecanico: tIdMecanico,
        ),
      );
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
