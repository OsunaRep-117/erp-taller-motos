import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/evidencia_ot.dart';
import '../../domain/repositories/evidencia_ot_repository.dart';
import '../datasources/evidencia_ot_remote_datasource.dart';

class EvidenciaOtRepositoryImpl implements EvidenciaOtRepository {
  final EvidenciaOtRemoteDatasource remote;
  final String Function() obtenerUsuarioActualId;

  const EvidenciaOtRepositoryImpl(this.remote, this.obtenerUsuarioActualId);

  @override
  Future<Either<Failure, String>> subirEvidencia({
    required String idOrden,
    required Uint8List bytes,
    required String nombreArchivo,
    required String etapa,
  }) async {
    try {
      final path = await remote.subirEvidencia(
        idOrden: idOrden,
        bytes: bytes,
        nombreArchivo: nombreArchivo,
        etapa: etapa,
        subidaPor: obtenerUsuarioActualId(),
      );
      return Right(path);
    } on StorageException catch (e) {
      return Left(ServerFailure('Error al subir la foto: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EvidenciaOt>>> listarPorOrden(
    String idOrden,
  ) async {
    try {
      return Right(await remote.listarPorOrden(idOrden));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
