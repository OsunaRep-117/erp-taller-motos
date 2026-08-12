import 'package:dartz/dartz.dart';
import 'package:erp_flutter/core/errors/failures.dart';
import 'package:erp_flutter/features/inventario/domain/usecases/confirmar_salida_inventario.dart';
import 'package:erp_flutter/features/taller/domain/entities/orden_trabajo.dart';
import 'package:erp_flutter/features/taller/domain/repositories/orden_trabajo_repository.dart';
import 'package:erp_flutter/features/taller/domain/usecases/terminar_orden.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOrdenTrabajoRepository extends Mock implements OrdenTrabajoRepository {}
class MockConfirmarSalidaInventario extends Mock implements ConfirmarSalidaInventario {}

void main() {
  late TerminarOrden useCase;
  late MockOrdenTrabajoRepository mockOrdenRepository;
  late MockConfirmarSalidaInventario mockInventarioUseCase;

  setUp(() {
    mockOrdenRepository = MockOrdenTrabajoRepository();
    mockInventarioUseCase = MockConfirmarSalidaInventario();
    useCase = TerminarOrden(mockOrdenRepository, mockInventarioUseCase);
  });

  const tIdOrden = 'ORD-1';
  final tOrden = OrdenTrabajo(
    id: tIdOrden,
    idMoto: 'MOTO-1',
    estado: EstadoOrdenTrabajo.terminado,
    fallaReportada: 'Falla',
    fechaCreacion: DateTime.now(),
  );

  test('debe confirmar salida de inventario y luego marcar orden como terminada', () async {
    // arrange
    when(() => mockInventarioUseCase(any())).thenAnswer((_) async => const Right(null));
    when(() => mockOrdenRepository.marcarComoTerminada(any())).thenAnswer((_) async => Right(tOrden));

    // act
    final result = await useCase(tIdOrden);

    // assert
    expect(result, Right(tOrden));
    verify(() => mockInventarioUseCase(tIdOrden));
    verify(() => mockOrdenRepository.marcarComoTerminada(tIdOrden));
  });

  test('debe fallar si la confirmación de inventario falla', () async {
    // arrange
    const tFailure = ServerFailure('Error en inventario');
    when(() => mockInventarioUseCase(any())).thenAnswer((_) async => const Left(tFailure));

    // act
    final result = await useCase(tIdOrden);

    // assert
    expect(result, const Left(tFailure));
    verify(() => mockInventarioUseCase(tIdOrden));
    verifyNever(() => mockOrdenRepository.marcarComoTerminada(any()));
  });
}
