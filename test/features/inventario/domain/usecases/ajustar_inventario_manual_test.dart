import 'package:dartz/dartz.dart';
import 'package:erp_flutter/features/auth/domain/entities/usuario.dart';
import 'package:erp_flutter/features/inventario/domain/repositories/inventario_repository.dart';
import 'package:erp_flutter/features/inventario/domain/usecases/ajustar_inventario_manual.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockInventarioRepository extends Mock implements InventarioRepository {}

void main() {
  late _MockInventarioRepository repository;
  late AjustarInventarioManual useCase;

  setUp(() {
    repository = _MockInventarioRepository();
    useCase = AjustarInventarioManual(repository);
  });

  const admin = Usuario(
    id: '1',
    email: 'a@a.com',
    nombre: 'Admin',
    rol: RolEmpleado.admin,
  );
  const mecanico = Usuario(
    id: '2',
    email: 'm@m.com',
    nombre: 'Mecánico',
    rol: RolEmpleado.mecanico,
  );

  group('AjustarInventarioManual', () {
    test('Sección 5.2: rechaza si quien ajusta no es Admin', () async {
      final resultado = await useCase(
        usuarioActual: mecanico,
        sku: 'BUJIA-01',
        cantidadAjuste: -2,
        justificacion: 'Merma por robo',
      );

      expect(resultado.isLeft(), true);
      resultado.fold(
        (failure) => expect(failure.mensaje, contains('administrador')),
        (_) => fail('Un mecánico no debería poder ajustar inventario'),
      );
      verifyNever(
        () => repository.ajustarInventarioManual(
          sku: any(named: 'sku'),
          cantidadAjuste: any(named: 'cantidadAjuste'),
          justificacion: any(named: 'justificacion'),
        ),
      );
    });

    test('Sección 5.2: rechaza sin justificación aunque sea Admin', () async {
      final resultado = await useCase(
        usuarioActual: admin,
        sku: 'BUJIA-01',
        cantidadAjuste: -2,
        justificacion: '  ',
      );

      expect(resultado.isLeft(), true);
    });

    test('permite el ajuste cuando es Admin y trae justificación', () async {
      when(
        () => repository.ajustarInventarioManual(
          sku: 'BUJIA-01',
          cantidadAjuste: -2,
          justificacion: 'Merma por robo',
        ),
      ).thenAnswer((_) async => const Right(null));

      final resultado = await useCase(
        usuarioActual: admin,
        sku: 'BUJIA-01',
        cantidadAjuste: -2,
        justificacion: 'Merma por robo',
      );

      expect(resultado, const Right(null));
    });
  });
}
