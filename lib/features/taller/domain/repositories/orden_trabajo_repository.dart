import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/estado_historial.dart';
import '../entities/orden_trabajo.dart';

abstract class OrdenTrabajoRepository {
  Future<Either<Failure, List<OrdenTrabajo>>> obtenerOrdenes();

  Future<Either<Failure, OrdenTrabajo>> obtenerOrdenPorId(String id);

  Future<Either<Failure, OrdenTrabajo>> crearOrden({
    required String idMoto,
    required String fallaReportada,
    required List<String> fotosEvidencia,
  });

  Future<Either<Failure, OrdenTrabajo>> asignarMecanico({
    required String idOrden,
    required String idMecanico,
  });

  Future<Either<Failure, OrdenTrabajo>> actualizarHorasFacturables({
    required String idOrden,
    required double horas,
  });

  /// Cambia el estado a "terminado" Y calcula saldo_pendiente
  /// (refacciones + mano de obra) vía RPC — Secciones 5.1 y 6.9.
  Future<Either<Failure, OrdenTrabajo>> marcarComoTerminada(String idOrden);

  Future<Either<Failure, OrdenTrabajo>> marcarComoEntregada(String idOrden);

  Future<Either<Failure, OrdenTrabajo>> cancelarOrden({
    required String idOrden,
    required String motivo,
  });

  Future<Either<Failure, OrdenTrabajo>> cambiarEstado({
    required String idOrden,
    required EstadoOrdenTrabajo nuevoEstado,
  });

  Future<Either<Failure, List<EstadoHistorial>>> obtenerHistorial(String idOrden);

  Stream<List<OrdenTrabajo>> observarOrdenes();
}
