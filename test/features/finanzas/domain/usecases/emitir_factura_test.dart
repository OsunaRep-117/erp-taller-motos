import 'package:dartz/dartz.dart';
import 'package:erp_flutter/features/finanzas/domain/entities/factura.dart';
import 'package:erp_flutter/features/finanzas/domain/repositories/finanzas_repository.dart';
import 'package:erp_flutter/features/finanzas/domain/usecases/emitir_factura.dart';
import 'package:erp_flutter/features/taller/domain/entities/orden_trabajo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFinanzasRepository extends Mock implements FinanzasRepository {}

void main() {
  late _MockFinanzasRepository repository;
  late EmitirFactura useCase;

  setUp(() {
    repository = _MockFinanzasRepository();
    useCase = EmitirFactura(repository);
  });

  final ordenConSaldo = OrdenTrabajo(
    id: 'ORD-1',
    idMoto: 'VIN1',
    estado: EstadoOrdenTrabajo.terminado,
    fallaReportada: 'x',
    fechaCreacion: DateTime(2026, 1, 1),
    saldoPendiente: 200,
  );

  final ordenSaldada = OrdenTrabajo(
    id: 'ORD-1',
    idMoto: 'VIN1',
    estado: EstadoOrdenTrabajo.pagado,
    fallaReportada: 'x',
    fechaCreacion: DateTime(2026, 1, 1),
    saldoPendiente: 0,
  );

  group('EmitirFactura', () {
    test('Sección 6.10: rechaza si la orden todavía tiene saldo pendiente', () async {
      final resultado = await useCase(orden: ordenConSaldo, rfcReceptor: 'ABC123456XYZ');

      expect(resultado.isLeft(), true);
      verifyNever(() => repository.emitirFactura(
            idOrden: any(named: 'idOrden'),
            rfcReceptor: any(named: 'rfcReceptor'),
          ));
    });

    test('rechaza RFC vacío aunque el saldo esté en cero', () async {
      final resultado = await useCase(orden: ordenSaldada, rfcReceptor: '   ');
      expect(resultado.isLeft(), true);
    });

    test('emite factura cuando el saldo es cero y el RFC es válido', () async {
      final facturaEsperada = Factura(
        id: 'F1',
        idOrden: 'ORD-1',
        folioFiscal: 'FOLIO-1',
        rfcReceptor: 'ABC123456XYZ',
        estado: EstadoFactura.vigente,
        fechaEmision: DateTime(2026, 1, 2),
      );
      when(() => repository.emitirFactura(idOrden: 'ORD-1', rfcReceptor: 'ABC123456XYZ'))
          .thenAnswer((_) async => Right(facturaEsperada));

      final resultado = await useCase(orden: ordenSaldada, rfcReceptor: 'ABC123456XYZ');

      expect(resultado, Right(facturaEsperada));
    });
  });
}
