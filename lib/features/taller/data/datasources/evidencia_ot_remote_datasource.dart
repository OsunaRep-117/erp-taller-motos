import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/entities/evidencia_ot.dart';

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
    final path =
        '$idOrden/${DateTime.now().millisecondsSinceEpoch}_$nombreArchivo';

    await client.storage
        .from(_bucket)
        .uploadBinary(
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

  /// Lista las evidencias de una orden, generando una signed URL temporal
  /// para cada foto (el bucket `evidencias-ot` es privado).
  Future<List<EvidenciaOt>> listarPorOrden(String idOrden) async {
    final rows = await client
        .from('evidencias_ot')
        .select()
        .eq('id_orden', idOrden)
        .order('created_at', ascending: true);

    final lista = (rows as List).cast<Map<String, dynamic>>();
    if (lista.isEmpty) return [];

    final urls = await Future.wait(
      lista.map(
        (r) => client.storage
            .from(_bucket)
            .createSignedUrl(r['storage_path'] as String, 3600),
      ),
    );

    return List.generate(lista.length, (i) {
      final row = lista[i];
      return EvidenciaOt(
        id: row['id'] as String,
        idOrden: row['id_orden'] as String,
        storagePath: row['storage_path'] as String,
        etapa: row['etapa'] as String? ?? '',
        subidaPor: row['subida_por'] as String? ?? '',
        urlFirmada: urls[i],
        fechaSubida: row['created_at'] != null
            ? DateTime.parse(row['created_at'] as String)
            : DateTime.now(),
      );
    });
  }
}
