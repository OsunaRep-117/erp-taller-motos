import 'package:dartz/dartz.dart';
import 'package:erp_flutter/features/crm/domain/entities/cliente.dart';
import 'package:erp_flutter/features/crm/domain/repositories/crm_repository.dart';
import 'package:erp_flutter/features/crm/domain/usecases/crear_cliente.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrmRepository extends Mock implements CrmRepository {}

void main() {
  late _MockCrmRepository repository;
  late CrearCliente useCase;

  setUp(() {
    repository = _MockCrmRepository();
    useCase = CrearCliente(repository);
  });

  group('CrearCliente', () {
    test('Sección 6.1: rechaza flotilla sin RFC', () async {
      final resultado = await useCase(
        nombreCompleto: 'Pizzería Don Beto',
        telefono: '7710000000',
        esFlotilla: true,
        rfc: null,
      );

      expect(resultado.isLeft(), true);
      resultado.fold(
        (failure) => expect(failure.mensaje, contains('RFC')),
        (_) => fail('Debió exigir RFC para flotilla'),
      );
      verifyNever(() => repository.crearCliente(
            nombreCompleto: any(named: 'nombreCompleto'),
            telefono: any(named: 'telefono'),
            rfc: any(named: 'rfc'),
            esFlotilla: any(named: 'esFlotilla'),
          ));
    });

    test('permite flotilla con RFC', () async {
      const clienteEsperado = Cliente(
        id: '1',
        nombreCompleto: 'Pizzería Don Beto',
        telefono: '7710000000',
        rfc: 'PDB850101ABC',
        esFlotilla: true,
      );
      when(() => repository.crearCliente(
            nombreCompleto: 'Pizzería Don Beto',
            telefono: '7710000000',
            rfc: 'PDB850101ABC',
            esFlotilla: true,
          )).thenAnswer((_) async => const Right(clienteEsperado));

      final resultado = await useCase(
        nombreCompleto: 'Pizzería Don Beto',
        telefono: '7710000000',
        esFlotilla: true,
        rfc: 'PDB850101ABC',
      );

      expect(resultado, const Right(clienteEsperado));
    });

    test('rechaza teléfono vacío para cliente normal (no flotilla)', () async {
      final resultado = await useCase(
        nombreCompleto: 'Carlos',
        telefono: '',
        esFlotilla: false,
      );

      expect(resultado.isLeft(), true);
    });
  });
}
