import 'package:dartz/dartz.dart';
import 'package:erp_flutter/core/errors/failures.dart';
import 'package:erp_flutter/features/inventario/domain/entities/refaccion.dart';
import 'package:erp_flutter/features/inventario/domain/repositories/inventario_repository.dart';
import 'package:erp_flutter/features/inventario/domain/usecases/solicitar_refaccion_para_orden.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockInventarioRepository extends Mock implements InventarioRepository {}

void main() {
  late _MockInventarioRepository repository;
  late SolicitarRefaccionParaOrden useCase;

  setUp(() {
    repository = _MockInventarioRepository();
    useCase = SolicitarRefaccionParaOrden(repository);
  });

  const refaccionConStock = Refaccion(
    sku: 'BUJIA-01',
    nombre: 'Bujía',
    precioCosto: 45,
    precioVenta: 90,
    stockActual: 10,
    stockReservado: 2,
    stockMinimo: 5,
  );

  group('SolicitarRefaccionParaOrden', () {
    test('rechaza cantidad <= 0 sin consultar el repositorio', () async {
      final resultado = await useCase(idOrden: 'ORD-1', sku: 'BUJIA-01', cantidad: 0);

      expect(resultado, isA<Left<Failure, void>>());
      verifyNever(() => repository.obtenerPorSku(any()));
    });

    test('Regla Soft Allocation: rechaza si excede stock disponible', () async {
      // Disponible = 10 - 2 = 8; se solicitan 9.
      when(() => repository.obtenerPorSku('BUJIA-01'))
          .thenAnswer((_) async => const Right(refaccionConStock));

      final resultado = await useCase(idOrden: 'ORD-1', sku: 'BUJIA-01', cantidad: 9);

      expect(resultado, isA<Left<Failure, void>>());
      resultado.fold(
        (failure) => expect(failure.mensaje, contains('Stock insuficiente')),
        (_) => fail('Debió rechazar por stock insuficiente'),
      );
      verifyNever(() => repository.reservarParaOrden(
            idOrden: any(named: 'idOrden'),
            sku: any(named: 'sku'),
            cantidad: any(named: 'cantidad'),
            precioUnitarioVenta: any(named: 'precioUnitarioVenta'),
          ));
    });

    test('rechaza si la refacción está inactiva (dada de baja)', () async {
      when(() => repository.obtenerPorSku('BUJIA-01')).thenAnswer(
        (_) async => Right(refaccionConStock.copyWithInactivo(true)),
      );

      final resultado = await useCase(idOrden: 'ORD-1', sku: 'BUJIA-01', cantidad: 1);

      expect(resultado, isA<Left<Failure, void>>());
      resultado.fold(
        (failure) => expect(failure.mensaje, contains('dada de baja')),
        (_) => fail('Debió rechazar por refacción inactiva'),
      );
    });

    test('reserva correctamente cuando hay stock suficiente y está activa', () async {
      when(() => repository.obtenerPorSku('BUJIA-01'))
          .thenAnswer((_) async => const Right(refaccionConStock));
      when(() => repository.reservarParaOrden(
            idOrden: 'ORD-1',
            sku: 'BUJIA-01',
            cantidad: 3,
            precioUnitarioVenta: 90,
          )).thenAnswer((_) async => const Right(null));

      final resultado = await useCase(idOrden: 'ORD-1', sku: 'BUJIA-01', cantidad: 3);

      expect(resultado, const Right(null));
      verify(() => repository.reservarParaOrden(
            idOrden: 'ORD-1',
            sku: 'BUJIA-01',
            cantidad: 3,
            precioUnitarioVenta: 90,
          )).called(1);
    });
  });
}

extension on Refaccion {
  Refaccion copyWithInactivo(bool inactivo) => Refaccion(
        sku: sku,
        nombre: nombre,
        precioCosto: precioCosto,
        precioVenta: precioVenta,
        stockActual: stockActual,
        stockReservado: stockReservado,
        stockMinimo: stockMinimo,
        inactivo: inactivo,
      );
}
