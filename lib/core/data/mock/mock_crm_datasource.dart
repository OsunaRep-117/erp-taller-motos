import '../../../features/crm/data/datasources/crm_datasource.dart';
import '../../../features/crm/domain/entities/cliente.dart';
import '../../../features/crm/domain/entities/motocicleta.dart';
import 'mock_data_store.dart';

class MockCrmDatasource implements CrmDataSource {
  final MockDataStore store;
  const MockCrmDatasource(this.store);

  Future<List<Cliente>> listarClientes() async {
    store.ensureSeeded();
    return List.from(store.clientes);
  }

  Future<Cliente> obtenerClientePorId(String id) async {
    store.ensureSeeded();
    return store.clientes.firstWhere((c) => c.id == id);
  }

  Future<Cliente> crearCliente({
    required String nombreCompleto,
    required String telefono,
    String? rfc,
    required bool esFlotilla,
    double limiteCredito = 0,
  }) async {
    store.ensureSeeded();
    final cliente = Cliente(
      id: 'cli-${store.clientes.length + 1}'.padLeft(7, '0'),
      nombreCompleto: nombreCompleto,
      telefono: telefono,
      rfc: rfc,
      esFlotilla: esFlotilla,
      limiteCredito: limiteCredito,
    );
    store.clientes.add(cliente);
    return cliente;
  }

  Future<Cliente> actualizarCliente(Cliente cliente) async {
    final idx = store.clientes.indexWhere((c) => c.id == cliente.id);
    store.clientes[idx] = cliente;
    return cliente;
  }

  Future<List<Motocicleta>> listarMotocicletas() async {
    store.ensureSeeded();
    return List.from(store.motocicletas);
  }

  Future<Motocicleta> obtenerMotocicletaPorVin(String vin) async {
    store.ensureSeeded();
    return store.motocicletas.firstWhere((m) => m.vin == vin);
  }

  @override
  Future<Motocicleta> actualizarMotocicleta({
    required String vin,
    required String placa,
    required String marca,
    required String modelo,
    required int anio,
    required String idCliente,
  }) async {
    final idx = store.motocicletas.indexWhere((m) => m.vin == vin);
    final moto = Motocicleta(
      vin: vin,
      placa: placa.toUpperCase(),
      marca: marca,
      modelo: modelo,
      anio: anio,
      idCliente: idCliente,
    );
    store.motocicletas[idx] = moto;
    return moto;
  }

  Future<Motocicleta> crearMotocicleta({
    required String vin,
    required String placa,
    required String marca,
    required String modelo,
    required int anio,
    required String idCliente,
  }) async {
    store.ensureSeeded();
    final moto = Motocicleta(
      vin: vin,
      placa: placa,
      marca: marca,
      modelo: modelo,
      anio: anio,
      idCliente: idCliente,
    );
    store.motocicletas.add(moto);
    return moto;
  }
}
