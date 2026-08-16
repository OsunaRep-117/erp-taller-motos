import 'package:dartz/dartz.dart';
import 'package:erp_flutter/core/errors/failures.dart';
import 'package:erp_flutter/features/crm/domain/entities/cliente.dart';
import 'package:erp_flutter/features/crm/domain/entities/motocicleta.dart';
import 'package:erp_flutter/features/crm/domain/repositories/crm_repository.dart';
import 'package:erp_flutter/features/taller/domain/entities/orden_trabajo.dart';
import 'package:erp_flutter/features/taller/domain/repositories/orden_trabajo_repository.dart';
import 'package:erp_flutter/features/taller/domain/usecases/crear_orden_trabajo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockOrdenTrabajoRepository extends Mock
    implements OrdenTrabajoRepository {}

class _MockCrmRepository extends Mock implements CrmRepository {}

void main() {
  late _MockOrdenTrabajoRepository repository;
  late _MockCrmRepository crmRepository;
  late CrearOrdenTrabajo useCase;

  setUp(() {
    repository = _MockOrdenTrabajoRepository();
    crmRepository = _MockCrmRepository();
    useCase = CrearOrdenTrabajo(repository, crmRepository);
  });

  const moto = Motocicleta(
    vin: 'VIN123',
    placa: 'ABC',
    marca: 'Honda',
    modelo: 'CBR',
    anio: 2022,
    idCliente: 'cli-001',
  );

  final ordenDePrueba = OrdenTrabajo(
    id: 'ORD-2026-TEST',
    idMoto: 'VIN123',
    estado: EstadoOrdenTrabajo.pendiente,
    fallaReportada: 'No enciende',
    fechaCreacion: DateTime(2026, 1, 1),
  );

  group('CrearOrdenTrabajo', () {
    test(
      'Regla de Evidencia (Sección 5.1): rechaza sin llamar al repositorio si no hay fotos',
      () async {
        final resultado = await useCase(
          idMoto: 'VIN123',
          fallaReportada: 'No enciende',
          fotosEvidencia: [],
        );

        expect(resultado, isA<Left<Failure, OrdenTrabajo>>());
        resultado.fold(
          (failure) => expect(failure, isA<ReglaDeNegocioFailure>()),
          (_) => fail('No debió crear la orden sin evidencia'),
        );
        verifyNever(() => crmRepository.obtenerMotocicletaPorVin(any()));
        verifyNever(
          () => repository.crearOrden(
            idMoto: any(named: 'idMoto'),
            fallaReportada: any(named: 'fallaReportada'),
            fotosEvidencia: any(named: 'fotosEvidencia'),
          ),
        );
      },
    );

    test('Con al menos una foto, delega la creación al repositorio', () async {
      when(
        () => crmRepository.obtenerMotocicletaPorVin('VIN123'),
      ).thenAnswer((_) async => const Right(moto));
      when(
        () => crmRepository.clienteFlotillaMoroso('cli-001'),
      ).thenAnswer((_) async => const Right(false));
      when(
        () => repository.crearOrden(
          idMoto: 'VIN123',
          fallaReportada: 'No enciende',
          fotosEvidencia: ['foto1.jpg'],
        ),
      ).thenAnswer((_) async => Right(ordenDePrueba));

      final resultado = await useCase(
        idMoto: 'VIN123',
        fallaReportada: 'No enciende',
        fotosEvidencia: ['foto1.jpg'],
      );

      expect(resultado, Right(ordenDePrueba));
      verify(
        () => repository.crearOrden(
          idMoto: 'VIN123',
          fallaReportada: 'No enciende',
          fotosEvidencia: ['foto1.jpg'],
        ),
      ).called(1);
    });

    test('Bloquea flotilla morosa (>30 días)', () async {
      const motoFlotilla = Motocicleta(
        vin: 'FLO-VIN',
        placa: 'FLO',
        marca: 'Kawa',
        modelo: 'Ninja',
        anio: 2023,
        idCliente: 'cli-002',
      );
      when(
        () => crmRepository.obtenerMotocicletaPorVin('FLO-VIN'),
      ).thenAnswer((_) async => const Right(motoFlotilla));
      when(
        () => crmRepository.clienteFlotillaMoroso('cli-002'),
      ).thenAnswer((_) async => const Right(true));

      final resultado = await useCase(
        idMoto: 'FLO-VIN',
        fallaReportada: 'Servicio',
        fotosEvidencia: ['f.jpg'],
      );

      expect(resultado, isA<Left<Failure, OrdenTrabajo>>());
      verifyNever(
        () => repository.crearOrden(
          idMoto: any(named: 'idMoto'),
          fallaReportada: any(named: 'fallaReportada'),
          fotosEvidencia: any(named: 'fotosEvidencia'),
        ),
      );
    });
  });
}
