import 'package:dartz/dartz.dart';
import 'package:erp_flutter/core/errors/failures.dart';
import 'package:erp_flutter/features/crm/domain/repositories/crm_repository.dart';
import 'package:erp_flutter/features/crm/domain/usecases/crear_motocicleta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrmRepository extends Mock implements CrmRepository {}

void main() {
  late _MockCrmRepository repository;
  late CrearMotocicleta useCase;

  setUp(() {
    repository = _MockCrmRepository();
    useCase = CrearMotocicleta(repository);
  });

  group('CrearMotocicleta', () {
    test('Sección 6.2: rechaza VIN que no tiene exactamente 17 caracteres', () async {
      final resultado = await useCase(
        vin: 'CORTO123',
        placa: 'HGO-1234',
        marca: 'Honda',
        modelo: 'CB190R',
        anio: 2024,
        idCliente: 'cliente-1',
      );

      expect(resultado.isLeft(), true);
      resultado.fold(
        (failure) => expect(failure.mensaje, contains('17 caracteres')),
        (_) => fail('Debió rechazar VIN corto'),
      );
    });

    test('rechaza año fuera de rango razonable', () async {
      final resultado = await useCase(
        vin: '3HGCM82644B009913',
        placa: 'HGO-1234',
        marca: 'Honda',
        modelo: 'CB190R',
        anio: 1950,
        idCliente: 'cliente-1',
      );

      expect(resultado.isLeft(), true);
    });

    test('normaliza VIN y placa a mayúsculas antes de enviar al repositorio', () async {
      when(() => repository.crearMotocicleta(
            vin: '3HGCM82644B009913',
            placa: 'HGO-1234',
            marca: 'Honda',
            modelo: 'CB190R',
            anio: 2024,
            idCliente: 'cliente-1',
          )).thenAnswer((_) async => const Left(ReglaDeNegocioFailure('no importa para este test')));

      await useCase(
        vin: '3hgcm82644b009913',
        placa: 'hgo-1234',
        marca: 'Honda',
        modelo: 'CB190R',
        anio: 2024,
        idCliente: 'cliente-1',
      );

      verify(() => repository.crearMotocicleta(
            vin: '3HGCM82644B009913',
            placa: 'HGO-1234',
            marca: 'Honda',
            modelo: 'CB190R',
            anio: 2024,
            idCliente: 'cliente-1',
          )).called(1);
    });
  });
}
