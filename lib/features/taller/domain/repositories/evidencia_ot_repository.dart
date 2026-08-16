import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/evidencia_ot.dart';

abstract class EvidenciaOtRepository {
  Future<Either<Failure, String>> subirEvidencia({
    required String idOrden,
    required Uint8List bytes,
    required String nombreArchivo,
    required String etapa,
  });

  Future<Either<Failure, List<EvidenciaOt>>> listarPorOrden(String idOrden);
}
