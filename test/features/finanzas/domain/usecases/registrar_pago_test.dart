import 'package:dartz/dartz.dart';
import 'package:erp_flutter/features/finanzas/domain/entities/pago.dart';
import 'package:erp_flutter/features/finanzas/domain/repositories/finanzas_repository.dart';
import 'package:erp_flutter/features/finanzas/domain/usecases/registrar_pago.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFinanzasRepository extends Mock implements FinanzasRepository {}

void main() {
  late _MockFinanzasRepository repository;
  late RegistrarPago useCase;

  // mocktail necesita un valor "de relleno" para cualquier tipo no
  // primitivo usado con any() o captureAny() — MetodoPago es un enum
  // personalizado, así que hay que registrarlo una sola vez.
  setUpAll(() {
    registerFallbackValue(MetodoPago.efectivo);
  });

  setUp(() {
    repository = _MockFinanzasRepository();
    useCase = RegistrarPago(repository);
  });

  group('RegistrarPago', () {
    test('rechaza monto <= 0 sin llamar al repositorio', () async {
      final resultado = await useCase(
        idOrden: 'ORD-1',
        monto: 0,
        metodoPago: MetodoPago.efectivo,
      );

      expect(resultado.isLeft(), true);
      verifyNever(() => repository.registrarPago(
        idOrden: any(named: 'idOrden'),
        monto: any(named: 'monto'),
        metodoPago: any(named: 'metodoPago'),
      ));
    });

    test('delega al repositorio con monto válido (la validación de saldo la hace el servidor)', () async {
      when(() => repository.registrarPago(
        idOrden: 'ORD-1',
        monto: 500,
        metodoPago: MetodoPago.efectivo,
      )).thenAnswer((_) async => const Right(null));

      final resultado = await useCase(
        idOrden: 'ORD-1',
        monto: 500,
        metodoPago: MetodoPago.efectivo,
      );

      expect(resultado, const Right(null));
    });
  });
}