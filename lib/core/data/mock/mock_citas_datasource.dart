import '../../../features/crm/data/datasources/citas_datasource.dart';
import '../../../features/crm/domain/entities/cita.dart';
import 'mock_data_store.dart';

class MockCitasDatasource implements CitasDataSource {
  final MockDataStore store;
  const MockCitasDatasource(this.store);

  @override
  Future<List<Cita>> listarCitas() async {
    store.ensureSeeded();
    return List.from(store.citas);
  }

  @override
  Future<Cita> agendarCita({
    required String idCliente,
    required DateTime fechaCita,
    required String motivo,
    String? idMoto,
  }) async {
    return store.agendarCita(
      idCliente: idCliente,
      fechaCita: fechaCita,
      motivo: motivo,
      idMoto: idMoto,
    );
  }

  @override
  Future<Cita> confirmarCita(String idCita) async =>
      store.confirmarCita(idCita);

  @override
  Future<Cita> cancelarCita(String idCita) async => store.cancelarCita(idCita);

  @override
  Future<Cita> completarCita({
    required String idCita,
    required String idMoto,
    required String idOrden,
  }) async {
    return store.completarCita(
      idCita: idCita,
      idMoto: idMoto,
      idOrden: idOrden,
    );
  }
}
