/// Evidencia fotográfica de una orden de trabajo.
///
/// [urlFirmada] es una signed URL temporal generada por Supabase Storage
/// (el bucket `evidencias-ot` es privado), válida por un tiempo limitado.
/// En modo mock, es un data-URL en base64 generado en memoria.
class EvidenciaOt {
  final String id;
  final String idOrden;
  final String storagePath;
  final String etapa;
  final String subidaPor;
  final String urlFirmada;
  final DateTime fechaSubida;

  const EvidenciaOt({
    required this.id,
    required this.idOrden,
    required this.storagePath,
    required this.etapa,
    required this.subidaPor,
    required this.urlFirmada,
    required this.fechaSubida,
  });
}
