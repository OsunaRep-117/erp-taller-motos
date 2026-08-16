import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/mock_integration_harness.dart';

void main() {
  late MockIntegrationHarness h;

  setUp(() => h = MockIntegrationHarness());

  test('aprobar presupuesto habilita reservar refacciones', () async {
    await h.loginRecepcion();
    const idOrden = 'ot-002';
    await h.asignarMecanico(idOrden: idOrden, idMecanico: 'emp-mec');

    final sinAprobar = await h.solicitarRefaccion(
      idOrden: idOrden,
      sku: 'ACE-001',
      cantidad: 1,
    );
    expect(sinAprobar.isLeft(), true);

    final aprobada = await h.aprobarPresupuesto(idOrden);
    expect(aprobada.isRight(), true);

    final reserva = await h.solicitarRefaccion(
      idOrden: idOrden,
      sku: 'ACE-001',
      cantidad: 1,
    );
    expect(reserva, isA<Right<dynamic, void>>());
  });

  test('admin puede reabrir orden terminada', () async {
    await h.loginRecepcion();
    const idOrden = 'ot-002';
    await h.asignarMecanico(idOrden: idOrden, idMecanico: 'emp-mec');
    await h.aprobarPresupuesto(idOrden);
    await h.solicitarRefaccion(idOrden: idOrden, sku: 'ACE-001', cantidad: 1);
    await h.ordenRepo.actualizarHorasFacturables(idOrden: idOrden, horas: 1);
    await h.loginMecanico();
    await h.terminarOrdenUseCase(idOrden: idOrden, idEmpleadoActual: 'emp-mec');

    final admin = await h.loginAdmin();
    final reabierta = await h.reabrirOrden(
      idOrden: idOrden,
      usuarioActual: admin,
    );
    expect(reabierta.isRight(), true);
    expect(
      reabierta.getOrElse(() => throw StateError('')).estado.name,
      'enProceso',
    );
  });
}
