import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/app_config.dart';

class EvidenciaOtRemoteDatasource {
  final SupabaseClient client;
  const EvidenciaOtRemoteDatasource(this.client);

  static const _bucket = AppConfig.evidenciasBucket;

  /// Sube los bytes de la foto al bucket y registra la fila en
  /// evidencias_ot (Anexo B, Sección 3.2). Devuelve el storage_path.
  Future<String> subirEvidencia({
    required String idOrden,
    required Uint8List bytes,
    required String nombreArchivo,
    required String etapa,
    required String subidaPor,
  }) async {
    final path = '$idOrden/${DateTime.now().millisecondsSinceEpoch}_$nombreArchivo';

    await client.storage.from(_bucket).uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(upsert: false),
        );

    await client.from('evidencias_ot').insert({
      'id_orden': idOrden,
      'storage_path': path,
      'etapa': etapa,
      'subida_por': subidaPor,
    });

    return path;
  }
}
