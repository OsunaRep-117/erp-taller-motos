import '../../features/taller/domain/entities/orden_trabajo.dart';

class ReporteOperativoService {
  const ReporteOperativoService._();

  static String _estadoLabel(Object? estado) {
    if (estado == null) return '';
    if (estado is String) return estado;
    return estado.toString().split('.').last;
  }

  static Map<String, dynamic> buildSnapshot({
    required List<dynamic> ordenes,
    required List<dynamic> refacciones,
  }) {
    final totalOt = ordenes.length;
    final enProceso = ordenes
        .where((o) => o.estado == EstadoOrdenTrabajo.enProceso)
        .length;
    final pendientesPago = ordenes.where((o) => o.requierePago).length;
    final criticas = refacciones.where((r) {
      final stock = (r['stock_actual'] as int?) ?? 0;
      final minimo = (r['stock_minimo'] as int?) ?? 0;
      return stock <= minimo;
    }).length;

    return {
      'otAbiertas': totalOt,
      'otEnProceso': enProceso,
      'otPendientesPago': pendientesPago,
      'refaccionesCriticas': criticas,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  static String exportCsv({
    required List<dynamic> ordenes,
    required List<dynamic> refacciones,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('id,estado,saldoPendiente,requierePago');
    for (final orden in ordenes) {
      final estado = _estadoLabel(orden.estado);
      final saldo = orden.saldoPendiente;
      final requierePago = orden.requierePago ? 'true' : 'false';
      buffer.writeln('${orden.id},$estado,$saldo,$requierePago');
    }

    buffer.writeln('');
    buffer.writeln('sku,nombre,stock_actual,stock_minimo');
    for (final item in refacciones) {
      final sku = item['sku'] as String? ?? '';
      final nombre = item['nombre'] as String? ?? '';
      final stockActual = item['stock_actual'] as int? ?? 0;
      final stockMinimo = item['stock_minimo'] as int? ?? 0;
      buffer.writeln('$sku,$nombre,$stockActual,$stockMinimo');
    }

    return buffer.toString();
  }
}
