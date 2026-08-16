import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:erp_flutter/core/errors/failures.dart';
import '../entities/evidencia_ot.dart';

abstract class FotosOtRepository {
  Future<Either<Failure, String>> subirEvidencia({
    required String idOrden,
    required Uint8List bytes,
    required String nombreArchivo,
    required String etapa,
  });

  Future<Either<Failure, List<EvidenciaOt>>> obtenerEvidencias(String idOrden);
}
