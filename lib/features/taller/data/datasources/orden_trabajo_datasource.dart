import '../../domain/entities/orden_trabajo.dart';

abstract class OrdenTrabajoDataSource {
  Future<List<OrdenTrabajo>> obtenerOrdenes();
  Future<OrdenTrabajo> obtenerOrdenPorId(String id);
  Future<OrdenTrabajo> crearOrden(OrdenTrabajo orden);
  Future<int> contarOrdenesEnProcesoDeMecanico(String idMecanico);
  Future<OrdenTrabajo> asignarMecanico({required String idOrden, required String idMecanico});
  Future<OrdenTrabajo> actualizarHorasFacturables({required String idOrden, required double horas});
  Future<OrdenTrabajo> marcarComoTerminada(String idOrden);
  Future<OrdenTrabajo> marcarComoEntregada(String idOrden);
  Future<OrdenTrabajo> cancelarOrden(String idOrden, String motivo);
  Future<OrdenTrabajo> cambiarEstado({required String idOrden, required EstadoOrdenTrabajo nuevoEstado});
  Stream<List<OrdenTrabajo>> observarOrdenes();
  Future<List<Map<String, dynamic>>> obtenerHistorial(String idOrden);
}
