import 'package:erp_flutter/core/data/mock/mock_citas_datasource.dart';
import 'package:erp_flutter/features/crm/data/repositories/citas_repository_impl.dart';
import 'package:erp_flutter/features/crm/domain/entities/cita.dart';
import 'package:erp_flutter/features/crm/domain/usecases/agendar_cita.dart';
import 'package:erp_flutter/features/crm/domain/usecases/completar_cita.dart';
import 'package:erp_flutter/features/crm/domain/usecases/confirmar_cita.dart';
import 'package:erp_flutter/features/taller/domain/entities/orden_trabajo.dart';
import '../helpers/mock_integration_harness.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MockIntegrationHarness h;
  late AgendarCita agendarCita;
  late ConfirmarCita confirmarCita;
  late CompletarCita completarCita;

  setUp(() {
    h = MockIntegrationHarness();
    final citasRepo = CitasRepositoryImpl(MockCitasDatasource(h.store));
    agendarCita = AgendarCita(citasRepo);
    confirmarCita = ConfirmarCita(citasRepo);
    completarCita = CompletarCita(citasRepo, h.crearOrden);
  });

  test('agendar cita respeta anti-sobrecupo por hora', () async {
    final base = DateTime(2026, 3, 15, 10, 0);

    for (var i = 0; i < 3; i++) {
      final r = await agendarCita(
        idCliente: 'cli-001',
        fechaCita: base.add(Duration(minutes: i * 15)),
        motivo: 'Servicio $i',
      );
      expect(r.isRight(), true);
    }

    final saturado = await agendarCita(
      idCliente: 'cli-001',
      fechaCita: base.add(const Duration(minutes: 45)),
      motivo: 'Extra',
    );
    expect(saturado.isLeft(), true);
  });

  test('completar cita confirmada crea OT vinculada', () async {
    await h.loginRecepcion();
    final agendada = (await agendarCita(
      idCliente: 'cli-001',
      fechaCita: DateTime.now().add(const Duration(days: 1)),
      motivo: 'Afinación mayor',
      idMoto: '1HGBH41JXMN109186',
    )).fold((f) => throw Exception(f.mensaje), (c) => c);
    final idCita = agendada.id;

    await confirmarCita(idCita);

    final completada = await completarCita(
      idCita: idCita,
      idMoto: '1HGBH41JXMN109186',
      motivo: 'Afinación mayor',
      fotosEvidencia: const ['llegada.jpg'],
    );

    completada.fold((f) => fail(f.mensaje), (cita) {
      expect(cita.estado, EstadoCita.completada);
      expect(cita.idOrden, isNotNull);
      final ot = h.store.ordenes.firstWhere((o) => o.id == cita.idOrden);
      expect(ot.fallaReportada, 'Afinación mayor');
      expect(ot.estado, EstadoOrdenTrabajo.pendiente);
    });
  });

  test('morosidad flotilla bloquea nueva OT', () async {
    h.store.ensureSeeded();
    h.store.ordenes.add(
      OrdenTrabajo(
        id: 'OT-MOROSA',
        idMoto: 'JH2RC4670MK200001',
        estado: EstadoOrdenTrabajo.terminado,
        fallaReportada: 'Antigua',
        saldoPendiente: 5000,
        fechaCreacion: DateTime.now().subtract(const Duration(days: 45)),
      ),
    );

    expect(h.store.clienteFlotillaMoroso('cli-002'), true);

    final result = await h.crearOrden(
      idMoto: 'JH2RC4670MK200001',
      fallaReportada: 'Nueva recepción',
      fotosEvidencia: const ['f.jpg'],
    );
    expect(result.isLeft(), true);
  });

  test('SLA excedido cuando duración > 150% estimado', () {
    final inicio = DateTime(2026, 1, 1, 8);
    final fin = DateTime(2026, 1, 1, 12);
    final orden = OrdenTrabajo(
      id: 'OT-SLA',
      idMoto: 'VIN',
      estado: EstadoOrdenTrabajo.terminado,
      fallaReportada: 'Test',
      horasEstimadas: 2,
      fechaCreacion: inicio,
      fechaInicioReparacion: inicio,
      fechaTerminado: fin,
    );
    expect(orden.slaExcedido, true);
  });
}
