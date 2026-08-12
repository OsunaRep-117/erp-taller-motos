import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/evidencia_ot_repository.dart';

const _kMaxTamanioBytes = 8 * 1024 * 1024; // 8 MB

class SubirEvidenciaOT {
  final EvidenciaOtRepository repository;
  const SubirEvidenciaOT(this.repository);

  Future<Either<Failure, String>> call({
    required String idOrden,
    required Uint8List bytes,
    required String nombreArchivo,
    required String etapa,
  }) {
    if (bytes.length > _kMaxTamanioBytes) {
      return Future.value(
        const Left(ReglaDeNegocioFailure('La foto no puede pesar más de 8 MB.')),
      );
    }

    final extensionesValidas = ['.jpg', '.jpeg', '.png', '.webp'];
    final tieneExtensionValida = extensionesValidas
        .any((ext) => nombreArchivo.toLowerCase().endsWith(ext));

    if (!tieneExtensionValida) {
      return Future.value(
        const Left(ReglaDeNegocioFailure('Formato de imagen no soportado.')),
      );
    }

    return repository.subirEvidencia(
      idOrden: idOrden,
      bytes: bytes,
      nombreArchivo: nombreArchivo,
      etapa: etapa,
    );
  }
}
