import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/xp_window.dart';
import '../../domain/entities/orden_trabajo.dart';

class OrdenCard extends StatelessWidget {
  final OrdenTrabajo orden;
  const OrdenCard({super.key, required this.orden});

  Color _getStatusColor(EstadoOrdenTrabajo estado) {
    switch (estado) {
      case EstadoOrdenTrabajo.pendiente:
        return Colors.orange.shade700;
      case EstadoOrdenTrabajo.enProceso:
        return XpColors.selection;
      case EstadoOrdenTrabajo.terminado:
        return Colors.green.shade700;
      case EstadoOrdenTrabajo.pagado:
        return Colors.teal.shade700;
      case EstadoOrdenTrabajo.entregado:
        return Colors.grey.shade600;
      case EstadoOrdenTrabajo.cancelada:
        return Colors.red.shade700;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return XpEntityCard(
      onTap: () => context.go('/ordenes/${orden.id}'),
      title: Row(
        children: [
          Expanded(
            child: Text(
              '#${orden.id.substring(0, orden.id.length >= 8 ? 8 : orden.id.length)}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 4),
          XpStatusChip(
            label: orden.estado.name,
            color: _getStatusColor(orden.estado),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            orden.fallaReportada,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.black45),
              const SizedBox(width: 4),
              Text(
                'Creada: ${orden.fechaCreacion.day}/${orden.fechaCreacion.month}/${orden.fechaCreacion.year}',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              if (orden.saldoPendiente > 0) ...[
                const Spacer(),
                Text(
                  'Saldo: \$${orden.saldoPendiente.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
