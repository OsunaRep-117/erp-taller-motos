import 'package:dartz/dartz.dart';
import 'package:erp_flutter/core/errors/failures.dart';
import 'package:erp_flutter/features/finanzas/domain/entities/pago.dart';
import 'package:erp_flutter/features/pos/domain/entities/item_carrito.dart';
import 'package:erp_flutter/features/taller/domain/entities/orden_trabajo.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/mock_integration_harness.dart';

/// Reglas Fase 0 alineadas al documento maestro §5.
void main() {
  late MockIntegrationHarness h;

  setUp(() => h = MockIntegrationHarness());

  test('solo el mecánico asignado puede terminar la OT', () async {
    await h.loginRecepcion();

    const idOrden = 'ot-002';
    await h.asignarMecanico(idOrden: idOrden, idMecanico: 'emp-mec');
    await h.aprobarPresupuesto(idOrden);

    final rechazada = await h.terminarOrdenUseCase(
      idOrden: idOrden,
      idEmpleadoActual: 'emp-recep',
    );

    expect(
      rechazada,
      const Left(
        ReglaDeNegocioFailure(
          'Solo el mecánico asignado puede marcar la orden como terminada.',
        ),
      ),
    );

    await h.loginMecanico();
    final aceptada = await h.terminarOrdenUseCase(
      idOrden: idOrden,
      idEmpleadoActual: 'emp-mec',
    );
    expect(aceptada.isRight(), true);
  });

  test('comisión al liquidar OT se calcula solo sobre mano de obra', () async {
    await h.loginRecepcion();

    const idOrden = 'ot-002';
    await h.asignarMecanico(idOrden: idOrden, idMecanico: 'emp-mec');
    await h.aprobarPresupuesto(idOrden);
    await h.solicitarRefaccion(idOrden: idOrden, sku: 'ACE-001', cantidad: 1);
    await h.ordenRepo.actualizarHorasFacturables(idOrden: idOrden, horas: 2);

    await h.loginMecanico();
    final terminada = await h.terminarOrdenUseCase(
      idOrden: idOrden,
      idEmpleadoActual: 'emp-mec',
    );
    final ot = terminada.getOrElse(() => throw StateError(''));
    expect(ot.saldoPendiente, greaterThan(700));

    await h.loginAdmin();
    final pago = await h.registrarPago(
      idOrden: idOrden,
      monto: ot.saldoPendiente,
      metodoPago: MetodoPago.efectivo,
    );
    expect(pago, const Right(null));

    final comisionOt = h.store.comisiones.firstWhere(
      (c) => c.idOrden == idOrden,
    );
    expect(comisionOt.monto, closeTo(2 * 350 * 0.08, 0.01));
  });

  test('POS rechaza venta con precio menor al costo', () async {
    await h.loginRecepcion();

    final venta = await h.registrarVenta([
      const ItemCarrito(
        sku: 'ACE-001',
        nombre: 'Aceite 10W40',
        cantidad: 1,
        precioUnitario: 50,
      ),
    ]);

    expect(venta.isLeft(), true);
  });

  test(
    'calcularExposicionCredito suma saldo de OT activas del cliente',
    () async {
      h.store.ensureSeeded();

      const idClienteFlotilla = 'cli-002';
      final exposicion = await h.crmRepo.calcularExposicionCredito(
        idClienteFlotilla,
      );

      expect(exposicion.isRight(), true);
      final total = exposicion.getOrElse(() => throw StateError(''));
      expect(total, greaterThanOrEqualTo(0));
    },
  );
}
