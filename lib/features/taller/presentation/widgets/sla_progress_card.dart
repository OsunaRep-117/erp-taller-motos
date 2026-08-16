import 'dart:async';

import 'package:flutter/material.dart';

import '../../domain/entities/orden_trabajo.dart';

/// Cronómetro visual vs tiempo estimado (§5.2 — alerta al 150%).
class SlaProgressCard extends StatefulWidget {
  final OrdenTrabajo orden;
  const SlaProgressCard({super.key, required this.orden});

  @override
  State<SlaProgressCard> createState() => _SlaProgressCardState();
}

class _SlaProgressCardState extends State<SlaProgressCard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (_mostrarActivo) {
      _timer = Timer.periodic(const Duration(seconds: 30), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void didUpdateWidget(covariant SlaProgressCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_mostrarActivo && _timer == null) {
      _timer = Timer.periodic(const Duration(seconds: 30), (_) {
        if (mounted) setState(() {});
      });
    } else if (!_mostrarActivo) {
      _timer?.cancel();
      _timer = null;
    }
  }

  bool get _mostrarActivo =>
      widget.orden.estado == EstadoOrdenTrabajo.enProceso &&
      widget.orden.fechaInicioReparacion != null;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatHoras(double horas) {
    final h = horas.floor();
    final m = ((horas - h) * 60).round();
    return '${h}h ${m.toString().padLeft(2, '0')}m';
  }

  @override
  Widget build(BuildContext context) {
    final orden = widget.orden;
    if (orden.fechaInicioReparacion == null) return const SizedBox.shrink();

    final limiteHoras = orden.horasEstimadas * 1.5;
    final horasTranscurridas = orden.estado == EstadoOrdenTrabajo.enProceso
        ? DateTime.now().difference(orden.fechaInicioReparacion!).inMinutes /
              60.0
        : orden.fechaTerminado != null
        ? orden.fechaTerminado!
                  .difference(orden.fechaInicioReparacion!)
                  .inMinutes /
              60.0
        : 0.0;

    final progreso = limiteHoras > 0
        ? (horasTranscurridas / limiteHoras).clamp(0.0, 1.5)
        : 0.0;
    final excedido =
        orden.slaExcedido ||
        (orden.estado == EstadoOrdenTrabajo.enProceso &&
            horasTranscurridas > limiteHoras);
    final color = excedido
        ? Colors.red.shade700
        : progreso > 0.85
        ? Colors.orange.shade800
        : Colors.teal.shade700;

    return Card(
      color: excedido ? Colors.red.shade50 : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timer_outlined, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Auditoría SLA',
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Estimado: ${orden.horasEstimadas.toStringAsFixed(1)} h · '
              'Límite 150%: ${limiteHoras.toStringAsFixed(1)} h',
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              'Transcurrido: ${_formatHoras(horasTranscurridas)}',
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progreso.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              color: color,
            ),
            if (excedido) ...[
              const SizedBox(height: 8),
              Text(
                orden.estado == EstadoOrdenTrabajo.enProceso
                    ? 'Alerta: tiempo de reparación supera el 150% estimado.'
                    : 'Ineficiencia registrada: duración superó el 150% del estándar.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
