import 'package:dartz/dartz.dart';
import 'package:postgrest/postgrest.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/cliente.dart';
import '../../domain/entities/motocicleta.dart';
import '../../domain/repositories/crm_repository.dart';
import '../datasources/crm_remote_datasource.dart';

import '../datasources/crm_datasource.dart';

class CrmRepositoryImpl implements CrmRepository {
  final CrmDataSource remote;
  const CrmRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<Cliente>>> listarClientes() async {
    try {
      final clientes = await remote.listarClientes();
      return Right(clientes);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cliente>> obtenerClientePorId(String id) async {
    try {
      final cliente = await remote.obtenerClientePorId(id);
      return Right(cliente);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cliente>> crearCliente({
    required String nombreCompleto,
    required String telefono,
    String? rfc,
    bool esFlotilla = false,
  }) async {
    try {
      final nuevoCliente = await remote.crearCliente(
        nombreCompleto: nombreCompleto,
        telefono: telefono,
        rfc: rfc,
        esFlotilla: esFlotilla,
      );
      return Right(nuevoCliente);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cliente>> actualizarCliente(Cliente cliente) async {
    try {
      if (!cliente.esValido) {
        return const Left(
          ReglaDeNegocioFailure('Datos del cliente inválidos.'),
        );
      }
      return Right(await remote.actualizarCliente(cliente));
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Motocicleta>>> listarMotocicletas() async {
    try {
      final motos = await remote.listarMotocicletas();
      return Right(motos);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Motocicleta>> obtenerMotocicletaPorVin(
    String vin,
  ) async {
    try {
      final moto = await remote.obtenerMotocicletaPorVin(vin);
      return Right(moto);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Motocicleta>> actualizarMotocicleta({
    required String vin,
    required String placa,
    required String marca,
    required String modelo,
    required int anio,
    required String idCliente,
  }) async {
    try {
      return Right(
        await remote.actualizarMotocicleta(
          vin: vin,
          placa: placa,
          marca: marca,
          modelo: modelo,
          anio: anio,
          idCliente: idCliente,
        ),
      );
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Motocicleta>> crearMotocicleta({
    required String vin,
    required String placa,
    required String marca,
    required String modelo,
    required int anio,
    required String idCliente,
  }) async {
    try {
      final nuevaMoto = await remote.crearMotocicleta(
        vin: vin,
        placa: placa,
        marca: marca,
        modelo: modelo,
        anio: anio,
        idCliente: idCliente,
      );
      return Right(nuevaMoto);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        return const Left(
          ReglaDeNegocioFailure(
            'Ya existe una motocicleta registrada con ese VIN.',
          ),
        );
      }
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> calcularExposicionCredito(
    String idCliente,
  ) async {
    try {
      final exposicion = await remote.calcularExposicionCredito(idCliente);
      return Right(exposicion);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> clienteFlotillaMoroso(String idCliente) async {
    try {
      final moroso = await remote.clienteFlotillaMoroso(idCliente);
      return Right(moroso);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
