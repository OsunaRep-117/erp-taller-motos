import 'package:dartz/dartz.dart';
import 'package:erp_flutter/features/pos/domain/entities/item_carrito.dart';
import 'package:erp_flutter/features/pos/domain/repositories/pos_repository.dart';
import 'package:erp_flutter/features/pos/domain/usecases/registrar_venta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPosRepository extends Mock implements PosRepository {}

void main() {
  late _MockPosRepository repository;
  late RegistrarVenta useCase;

  setUp(() {
    repository = _MockPosRepository();
    useCase = RegistrarVenta(repository);
  });

  group('RegistrarVenta', () {
    test('rechaza carrito vacío sin llamar al repositorio', () async {
      final resultado = await useCase([]);

      expect(resultado.isLeft(), true);
      verifyNever(() => repository.registrarVenta(any()));
    });

    test('delega al repositorio cuando hay items (validación de margen la hace el servidor)', () async {
      const items = [
        ItemCarrito(sku: 'BUJIA-01', nombre: 'Bujía', cantidad: 2, precioUnitario: 90),
      ];
      when(() => repository.registrarVenta(items)).thenAnswer((_) async => const Right('venta-1'));

      final resultado = await useCase(items);

      expect(resultado, const Right('venta-1'));
    });
  });
}
