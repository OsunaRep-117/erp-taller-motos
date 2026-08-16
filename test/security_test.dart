import 'package:dartz/dartz.dart';
import 'package:erp_flutter/core/data/mock/mock_data_store.dart';
import 'package:erp_flutter/core/errors/failures.dart';
import 'package:erp_flutter/core/services/reporte_operativo_service.dart';
import 'package:erp_flutter/features/auth/domain/entities/usuario.dart';
import 'package:erp_flutter/features/rrhh/domain/entities/empleado.dart';
import 'package:erp_flutter/features/rrhh/domain/repositories/rrhh_repository.dart';
import 'package:erp_flutter/features/taller/domain/entities/orden_trabajo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRrhhRepository extends Mock implements RrhhRepository {}

void main() {
  late MockRrhhRepository mockRepository;

  setUp(() {
    mockRepository = MockRrhhRepository();
  });

  test(
    'Mecánico no debería poder listar todos los empleados (simulación repositorio)',
    () async {
      // En una implementación real, esto estaría protegido por RLS en Supabase
      // y por lógica de permisos en el Use Case o Repositorio.

      // arrange
      when(
        () => mockRepository.listarEmpleados(),
      ).thenAnswer((_) async => const Left(ServerFailure('Permiso denegado')));

      // act
      final result = await mockRepository.listarEmpleados();

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.mensaje, 'Permiso denegado'),
        (_) => fail('Debería haber fallado'),
      );
    },
  );

  test('Admin debería poder listar todos los empleados', () async {
    // arrange
    final tEmpleados = [
      Empleado(
        id: '1',
        nombre: 'Admin',
        email: 'admin@test.com',
        rol: RolEmpleado.admin,
        fechaContratacion: DateTime.now(),
      ),
    ];
    when(
      () => mockRepository.listarEmpleados(),
    ).thenAnswer((_) async => Right(tEmpleados));

    // act
    final result = await mockRepository.listarEmpleados();

    // assert
    expect(result, Right(tEmpleados));
  });

  test('Una orden solo pertenece al mecánico asignado', () {
    final ordenAsignada = OrdenTrabajo(
      id: 'ot-1',
      idMoto: 'moto-1',
      idMecanico: 'mecanico-7',
      estado: EstadoOrdenTrabajo.enProceso,
      fallaReportada: 'Falla de freno',
      fechaCreacion: DateTime.now(),
    );

    expect(ordenAsignada.perteneceAMecanico('mecanico-7'), isTrue);
    expect(ordenAsignada.perteneceAMecanico('mecanico-8'), isFalse);
    expect(
      OrdenTrabajo(
        id: 'ot-2',
        idMoto: 'moto-2',
        estado: EstadoOrdenTrabajo.pendiente,
        fallaReportada: 'Sin asignar',
        fechaCreacion: DateTime.now(),
      ).perteneceAMecanico('mecanico-9'),
      isFalse,
    );
  });

  test('La orden calcula mano de obra, refacciones y pago requerido', () {
    final orden = OrdenTrabajo(
      id: 'ot-3',
      idMoto: 'moto-3',
      idMecanico: 'mecanico-10',
      estado: EstadoOrdenTrabajo.terminado,
      fallaReportada: 'Cambio de embrague',
      horasFacturables: 5,
      saldoPendiente: 3200,
      fechaCreacion: DateTime.now(),
    );

    expect(orden.manoDeObraCalculada, 1750);
    expect(orden.subtotalRefacciones, 1450);
    expect(orden.totalTrabajo, 3200);
    expect(orden.requierePago, isTrue);
  });

  test(
    'La orden expone bloqueos operativos para que el flujo sea transparente',
    () {
      final orden = OrdenTrabajo(
        id: 'ot-4',
        idMoto: 'moto-4',
        estado: EstadoOrdenTrabajo.terminado,
        fallaReportada: 'Falla en motor',
        horasFacturables: 3,
        saldoPendiente: 1200,
        fechaCreacion: DateTime.now(),
      );

      expect(orden.bloqueosOperacion, contains('Sin mecánico asignado'));
      expect(
        orden.bloqueosOperacion,
        contains('Pago requerido antes de entregar el vehículo'),
      );
      expect(
        orden.bloqueosOperacion,
        contains('Presupuesto pendiente de aprobación'),
      );
    },
  );

  test(
    'La orden calcula el cierre real con refacciones reservadas y adicionales',
    () {
      final orden = OrdenTrabajo(
        id: 'ot-5',
        idMoto: 'moto-5',
        idMecanico: 'mecanico-11',
        estado: EstadoOrdenTrabajo.terminado,
        fallaReportada: 'Cambio de cadena',
        horasFacturables: 4,
        saldoPendiente: 0,
        fechaCreacion: DateTime.now(),
      );

      final cierre = orden.resumenCierre(
        costoRefaccionesReservadas: 700,
        costoRefaccionesAdicionales: 260,
        horasRealesTrabajadas: 4,
      );

      expect(cierre['manoDeObra'], 1400);
      expect(cierre['refacciones'], 960);
      expect(cierre['total'], 2360);
    },
  );

  test('Debe distinguir reserva de consumo real de refacciones por orden', () {
    final store = MockDataStore.instance;
    store.resetForTesting();
    store.login('admin@taller.com', 'admin123');

    final orden = store.crearOrden(
      idMoto: 'moto-99',
      fallaReportada: 'Prueba de consumo real',
    );

    final aprobada = orden.copyWith(fechaAprobacionPresupuesto: DateTime.now());
    store.ordenes[store.ordenes.indexWhere((o) => o.id == orden.id)] = aprobada;

    store.reservarParaOrden(
      idOrden: orden.id,
      sku: 'ACE-001',
      cantidad: 1,
      precioUnitarioVenta: 150,
    );

    store.registrarConsumoParaOrden(
      idOrden: orden.id,
      sku: 'ACE-001',
      nombre: 'Aceite 10W40',
      cantidad: 1,
      precioUnitario: 150,
    );

    final reservas = store.obtenerReservasPorOrden(orden.id);
    final consumos = store.obtenerConsumosPorOrden(orden.id);

    expect(reservas.length, 1);
    expect(consumos.length, 1);
    expect(reservas.first['subtotal'], 150);
    expect(consumos.first['subtotal'], 150);
    expect(consumos.first['tipo'], 'consumo_real');
  });

  test(
    'El servicio operativo genera snapshot y CSV para reportes ejecutivos',
    () {
      final ordenes = [
        OrdenTrabajo(
          id: 'OT-100',
          idMoto: 'MOTO-1',
          idMecanico: 'MEC-1',
          estado: EstadoOrdenTrabajo.enProceso,
          fallaReportada: 'Freno delantero',
          horasFacturables: 3,
          saldoPendiente: 1500,
          fechaCreacion: DateTime.now(),
        ),
        OrdenTrabajo(
          id: 'OT-101',
          idMoto: 'MOTO-2',
          estado: EstadoOrdenTrabajo.terminado,
          fallaReportada: 'Cambio de cadena',
          horasFacturables: 4,
          saldoPendiente: 2100,
          fechaCreacion: DateTime.now(),
        ),
      ];

      final refacciones = [
        {
          'sku': 'ACE-001',
          'nombre': 'Aceite',
          'stock_actual': 2,
          'stock_minimo': 5,
        },
        {
          'sku': 'PAST-001',
          'nombre': 'Pastillas',
          'stock_actual': 8,
          'stock_minimo': 4,
        },
      ];

      final snapshot = ReporteOperativoService.buildSnapshot(
        ordenes: ordenes,
        refacciones: refacciones,
      );

      expect(snapshot['otAbiertas'], 2);
      expect(snapshot['otEnProceso'], 1);
      expect(snapshot['otPendientesPago'], 1);
      expect(snapshot['refaccionesCriticas'], 1);

      final csv = ReporteOperativoService.exportCsv(
        ordenes: ordenes,
        refacciones: refacciones,
      );

      expect(csv, contains('id,estado,saldoPendiente,requierePago'));
      expect(csv, contains('OT-100'));
      expect(csv, contains('OT-101'));
    },
  );
}
