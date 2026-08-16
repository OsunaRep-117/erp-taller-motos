import 'package:dartz/dartz.dart';
import 'package:erp_flutter/core/errors/failures.dart';
import 'package:erp_flutter/features/inventario/domain/entities/refaccion.dart';
import 'package:erp_flutter/features/inventario/domain/repositories/inventario_repository.dart';
import 'package:erp_flutter/features/inventario/domain/usecases/solicitar_refaccion_para_orden.dart';
import 'package:erp_flutter/features/taller/domain/entities/orden_trabajo.dart';
import 'package:erp_flutter/features/taller/domain/repositories/orden_trabajo_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockInventarioRepository extends Mock implements InventarioRepository {}

class _MockOrdenTrabajoRepository extends Mock
    implements OrdenTrabajoRepository {}

void main() {
  late _MockInventarioRepository inventarioRepository;
  late _MockOrdenTrabajoRepository ordenRepository;
  late SolicitarRefaccionParaOrden useCase;

  setUp(() {
    inventarioRepository = _MockInventarioRepository();
    ordenRepository = _MockOrdenTrabajoRepository();
    useCase = SolicitarRefaccionParaOrden(
      inventarioRepository,
      ordenRepository,
    );
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

  final ordenAprobada = OrdenTrabajo(
    id: 'ORD-1',
    idMoto: 'MOTO-1',
    estado: EstadoOrdenTrabajo.enProceso,
    fallaReportada: 'Falla',
    fechaCreacion: DateTime.now(),
    fechaAprobacionPresupuesto: DateTime.now(),
  );

  group('SolicitarRefaccionParaOrden', () {
    test('rechaza cantidad <= 0 sin consultar el repositorio', () async {
      final resultado = await useCase(
        idOrden: 'ORD-1',
        sku: 'BUJIA-01',
        cantidad: 0,
      );

      expect(resultado, isA<Left<Failure, void>>());
      verifyNever(() => inventarioRepository.obtenerPorSku(any()));
    });

    test('rechaza si el presupuesto no está aprobado', () async {
      final sinAprobacion = ordenAprobada.copyWith(
        fechaAprobacionPresupuesto: null,
      );
      when(
        () => ordenRepository.obtenerOrdenPorId('ORD-1'),
      ).thenAnswer((_) async => Right(sinAprobacion));

      final resultado = await useCase(
        idOrden: 'ORD-1',
        sku: 'BUJIA-01',
        cantidad: 1,
      );

      expect(
        resultado,
        const Left(
          ReglaDeNegocioFailure(
            'Debe aprobar el presupuesto antes de reservar refacciones.',
          ),
        ),
      );
    });

    test('Regla Soft Allocation: rechaza si excede stock disponible', () async {
      when(
        () => ordenRepository.obtenerOrdenPorId('ORD-1'),
      ).thenAnswer((_) async => Right(ordenAprobada));
      when(
        () => inventarioRepository.obtenerPorSku('BUJIA-01'),
      ).thenAnswer((_) async => const Right(refaccionConStock));

      final resultado = await useCase(
        idOrden: 'ORD-1',
        sku: 'BUJIA-01',
        cantidad: 9,
      );

      expect(resultado, isA<Left<Failure, void>>());
      verifyNever(
        () => inventarioRepository.reservarParaOrden(
          idOrden: any(named: 'idOrden'),
          sku: any(named: 'sku'),
          cantidad: any(named: 'cantidad'),
          precioUnitarioVenta: any(named: 'precioUnitarioVenta'),
        ),
      );
    });

    test(
      'reserva correctamente cuando hay stock suficiente y presupuesto aprobado',
      () async {
        when(
          () => ordenRepository.obtenerOrdenPorId('ORD-1'),
        ).thenAnswer((_) async => Right(ordenAprobada));
        when(
          () => inventarioRepository.obtenerPorSku('BUJIA-01'),
        ).thenAnswer((_) async => const Right(refaccionConStock));
        when(
          () => inventarioRepository.reservarParaOrden(
            idOrden: 'ORD-1',
            sku: 'BUJIA-01',
            cantidad: 3,
            precioUnitarioVenta: 90,
          ),
        ).thenAnswer((_) async => const Right(null));

        final resultado = await useCase(
          idOrden: 'ORD-1',
          sku: 'BUJIA-01',
          cantidad: 3,
        );

        expect(resultado, const Right(null));
      },
    );
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
