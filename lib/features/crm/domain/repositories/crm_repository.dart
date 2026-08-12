import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/cliente.dart';
import '../entities/motocicleta.dart';

abstract class CrmRepository {
  Future<Either<Failure, List<Cliente>>> listarClientes();

  Future<Either<Failure, Cliente>> obtenerClientePorId(String id);

  Future<Either<Failure, Cliente>> crearCliente({
    required String nombreCompleto,
    required String telefono,
    String? rfc,
    bool esFlotilla,
  });

  Future<Either<Failure, Cliente>> actualizarCliente(Cliente cliente);

  Future<Either<Failure, List<Motocicleta>>> listarMotocicletas();

  Future<Either<Failure, Motocicleta>> obtenerMotocicletaPorVin(String vin);

  Future<Either<Failure, Motocicleta>> actualizarMotocicleta({
    required String vin,
    required String placa,
    required String marca,
    required String modelo,
    required int anio,
    required String idCliente,
  });

  /// Regla de negocio (Sección 6.2): el VIN es inmutable y único.
  Future<Either<Failure, Motocicleta>> crearMotocicleta({
    required String vin,
    required String placa,
    required String marca,
    required String modelo,
    required int anio,
    required String idCliente,
  });
}
