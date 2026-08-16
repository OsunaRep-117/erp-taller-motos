import '../../domain/entities/cita.dart';

abstract class CitasDataSource {
  Future<List<Cita>> listarCitas();

  Future<Cita> agendarCita({
    required String idCliente,
    required DateTime fechaCita,
    required String motivo,
    String? idMoto,
  });

  Future<Cita> confirmarCita(String idCita);

  Future<Cita> cancelarCita(String idCita);

  Future<Cita> completarCita({
    required String idCita,
    required String idMoto,
    required String idOrden,
  });
}
