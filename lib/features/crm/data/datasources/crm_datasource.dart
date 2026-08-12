import '../../domain/entities/cliente.dart';
import '../../domain/entities/motocicleta.dart';

abstract class CrmDataSource {
  Future<List<Cliente>> listarClientes();
  Future<Cliente> obtenerClientePorId(String id);
  Future<Cliente> crearCliente({
    required String nombreCompleto,
    required String telefono,
    String? rfc,
    required bool esFlotilla,
  });
  Future<Cliente> actualizarCliente(Cliente cliente);
  Future<List<Motocicleta>> listarMotocicletas();
  Future<Motocicleta> obtenerMotocicletaPorVin(String vin);
  Future<Motocicleta> actualizarMotocicleta({
    required String vin,
    required String placa,
    required String marca,
    required String modelo,
    required int anio,
    required String idCliente,
  });
  Future<Motocicleta> crearMotocicleta({
    required String vin,
    required String placa,
    required String marca,
    required String modelo,
    required int anio,
    required String idCliente,
  });
}
