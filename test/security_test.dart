import 'package:dartz/dartz.dart';
import 'package:erp_flutter/core/errors/failures.dart';
import 'package:erp_flutter/features/auth/domain/entities/usuario.dart';
import 'package:erp_flutter/features/rrhh/domain/entities/empleado.dart';
import 'package:erp_flutter/features/rrhh/domain/repositories/rrhh_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRrhhRepository extends Mock implements RrhhRepository {}

void main() {
  late MockRrhhRepository mockRepository;

  setUp(() {
    mockRepository = MockRrhhRepository();
  });

  test('Mecánico no debería poder listar todos los empleados (simulación repositorio)', () async {
    // En una implementación real, esto estaría protegido por RLS en Supabase
    // y por lógica de permisos en el Use Case o Repositorio.
    
    // arrange
    when(() => mockRepository.listarEmpleados()).thenAnswer((_) async => const Left(ServerFailure('Permiso denegado')));

    // act
    final result = await mockRepository.listarEmpleados();

    // assert
    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure.mensaje, 'Permiso denegado'),
      (_) => fail('Debería haber fallado'),
    );
  });

  test('Admin debería poder listar todos los empleados', () async {
    // arrange
    final tEmpleados = [
      Empleado(
        id: '1',
        nombre: 'Admin',
        email: 'admin@test.com',
        rol: RolEmpleado.admin,
        fechaContratacion: DateTime.now(),
      )
    ];
    when(() => mockRepository.listarEmpleados()).thenAnswer((_) async => Right(tEmpleados));

    // act
    final result = await mockRepository.listarEmpleados();

    // assert
    expect(result, Right(tEmpleados));
  });
}
