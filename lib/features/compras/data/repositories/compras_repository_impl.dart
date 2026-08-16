import 'package:dartz/dartz.dart';
import 'package:postgrest/postgrest.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/proveedor.dart';
import '../../domain/entities/orden_compra.dart';
import '../../domain/repositories/compras_repository.dart';
import '../datasources/compras_datasource.dart';

EstadoOrdenCompra _estadoFromString(String value) {
  switch (value) {
    case 'aprobada':
      return EstadoOrdenCompra.aprobada;
    case 'recibida':
      return EstadoOrdenCompra.recibida;
    case 'cancelada':
      return EstadoOrdenCompra.cancelada;
    default:
      return EstadoOrdenCompra.borrador;
  }
}

OrdenCompra _ocFromJson(Map<String, dynamic> json) => OrdenCompra(
  id: json['id'] as String,
  idProveedor: json['id_proveedor'] as String,
  fechaCreacion: DateTime.parse(json['fecha_creacion'] as String),
  estado: _estadoFromString(json['estado'] as String? ?? 'borrador'),
  total: (json['total'] as num?)?.toDouble() ?? 0,
);

class ComprasRepositoryImpl implements ComprasRepository {
  final ComprasDataSource remote;
  const ComprasRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<Proveedor>>> listarProveedores() async {
    try {
      final data = await remote.listarProveedores();
      return Right(
        data
            .map(
              (json) => Proveedor(
                id: json['id'] as String,
                nombre: json['nombre'] as String,
                contacto: json['contacto'] as String,
                rfc: json['rfc'] as String?,
              ),
            )
            .toList(),
      );
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, Proveedor>> crearProveedor({
    required String nombre,
    required String contacto,
    String? rfc,
  }) async {
    try {
      final data = await remote.crearProveedor(
        nombre: nombre,
        contacto: contacto,
        rfc: rfc,
      );
      return Right(
        Proveedor(
          id: data['id'] as String,
          nombre: data['nombre'] as String,
          contacto: data['contacto'] as String,
          rfc: data['rfc'] as String?,
        ),
      );
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> listarEntradas() async {
    try {
      return Right(await remote.listarEntradas());
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, void>> recibirMercancia({
    required String sku,
    required int cantidad,
    required double costoUnitario,
    required String idProveedor,
  }) async {
    try {
      await remote.registrarEntrada(
        sku: sku,
        cantidad: cantidad,
        costoUnitario: costoUnitario,
        idProveedor: idProveedor,
      );
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, List<OrdenCompra>>> listarOrdenesCompra() async {
    try {
      final data = await remote.listarOrdenesCompra();
      return Right(data.map(_ocFromJson).toList());
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, List<CompraDetalle>>> obtenerDetalleCompra(
    String idCompra,
  ) async {
    try {
      final data = await remote.detalleOrdenCompra(idCompra);
      return Right(
        data
            .map(
              (d) => CompraDetalle(
                idCompra: idCompra,
                skuRefaccion:
                    d['sku_refaccion'] as String? ?? d['sku'] as String,
                cantidad: d['cantidad'] as int,
                precioCompra: (d['precio_compra'] as num).toDouble(),
              ),
            )
            .toList(),
      );
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, OrdenCompra>> crearOrdenCompra({
    required String idProveedor,
    required List<CompraDetalle> items,
  }) async {
    try {
      final data = await remote.crearOrdenCompra(
        idProveedor: idProveedor,
        items: items
            .map(
              (i) => {
                'sku': i.skuRefaccion,
                'cantidad': i.cantidad,
                'precio_compra': i.precioCompra,
              },
            )
            .toList(),
      );
      return Right(_ocFromJson(data));
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, OrdenCompra>> aprobarOrdenCompra(
    String idCompra,
  ) async {
    try {
      final data = await remote.aprobarOrdenCompra(idCompra);
      return Right(_ocFromJson(data));
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(_mapException(e));
    }
  }

  @override
  Future<Either<Failure, void>> recibirOrdenCompra(String idCompra) async {
    try {
      await remote.recibirOrdenCompra(idCompra);
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(_mapException(e));
    }
  }

  Failure _mapException(Object e) {
    final msg = e.toString().replaceFirst('Exception: ', '');
    return ReglaDeNegocioFailure(msg);
  }
}
