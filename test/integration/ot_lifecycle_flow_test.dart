import 'package:dartz/dartz.dart';
import 'package:erp_flutter/features/finanzas/domain/entities/pago.dart';
import 'package:erp_flutter/features/taller/domain/entities/orden_trabajo.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/mock_integration_harness.dart';

/// Flujo completo de una OT: crear → asignar → reservar pieza → terminar → pagar → entregar.
void main() {
  late MockIntegrationHarness h;

  setUp(() => h = MockIntegrationHarness());

  test('flujo OT de punta a punta (mock)', () async {
    await h.loginRecepcion();

    final creada = await h.crearOrden(
      idMoto: '1HGBH41JXMN109186',
      fallaReportada: 'Falla de prueba automatizada',
      fotosEvidencia: const ['evidencia_test.jpg'],
    );
    expect(creada.isRight(), true);
    final idOrden = creada.getOrElse(() => throw StateError('sin orden')).id;

    final asignada = await h.asignarMecanico(
      idOrden: idOrden,
      idMecanico: 'emp-mec',
    );
    expect(asignada.isRight(), true);
    expect(asignada.getOrElse(() => throw StateError('')).estado, EstadoOrdenTrabajo.enProceso);

    final reserva = await h.solicitarRefaccion(
      idOrden: idOrden,
      sku: 'ACE-001',
      cantidad: 1,
    );
    expect(reserva, const Right(null));

    final horas = await h.ordenRepo.actualizarHorasFacturables(idOrden: idOrden, horas: 2);
    expect(horas.isRight(), true);

    final terminada = await h.terminarOrden(idOrden);
    expect(terminada.isRight(), true);
    final otTerminada = terminada.getOrElse(() => throw StateError(''));
    expect(otTerminada.estado, EstadoOrdenTrabajo.terminado);
    expect(otTerminada.saldoPendiente, greaterThan(0));

    final pago = await h.registrarPago(
      idOrden: idOrden,
      monto: otTerminada.saldoPendiente,
      metodoPago: MetodoPago.efectivo,
    );
    expect(pago, const Right(null));

    final pagada = await h.orden(idOrden);
    expect(pagada.estado, EstadoOrdenTrabajo.pagado);
    expect(pagada.saldoPendiente, lessThanOrEqualTo(0.01));

    final entregada = await h.entregarOrden(idOrden);
    expect(entregada.isRight(), true);
    expect(entregada.getOrElse(() => throw StateError('')).estado, EstadoOrdenTrabajo.entregado);
  });

  test('flujo OT existente ot-002: asignar mecánico y reservar pieza', () async {
    await h.loginAdmin();

    const idOrden = 'ot-002';

    final asignada = await h.asignarMecanico(idOrden: idOrden, idMecanico: 'emp-mec');
    expect(asignada.isRight(), true);

    final reserva = await h.solicitarRefaccion(
      idOrden: idOrden,
      sku: 'PAST-001',
      cantidad: 1,
    );
    expect(reserva, const Right(null));

    final ot = await h.orden(idOrden);
    expect(ot.idMecanico, 'emp-mec');
    expect(ot.estado, EstadoOrdenTrabajo.enProceso);
  });
}
