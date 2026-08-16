import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/xp_window.dart';
import '../../domain/entities/orden_trabajo.dart';
import '../providers/orden_trabajo_providers.dart';
import '../widgets/orden_card.dart';

class OrdenesKanbanScreen extends ConsumerWidget {
  const OrdenesKanbanScreen({super.key});

  static const _columnas = [
    EstadoOrdenTrabajo.pendiente,
    EstadoOrdenTrabajo.enProceso,
    EstadoOrdenTrabajo.esperandoAprobacion,
    EstadoOrdenTrabajo.esperandoPiezas,
    EstadoOrdenTrabajo.terminado,
    EstadoOrdenTrabajo.pagado,
  ];

  String _tituloColumna(EstadoOrdenTrabajo estado) {
    switch (estado) {
      case EstadoOrdenTrabajo.enProceso:
        return 'En proceso';
      case EstadoOrdenTrabajo.esperandoAprobacion:
        return 'Esperando aprob.';
      case EstadoOrdenTrabajo.esperandoPiezas:
        return 'Esperando piezas';
      default:
        return estado.name[0].toUpperCase() + estado.name.substring(1);
    }
  }

  Color _colorColumna(EstadoOrdenTrabajo estado) {
    switch (estado) {
      case EstadoOrdenTrabajo.pendiente:
        return Colors.orange.shade700;
      case EstadoOrdenTrabajo.enProceso:
        return XpColors.selection;
      case EstadoOrdenTrabajo.terminado:
        return Colors.green.shade700;
      case EstadoOrdenTrabajo.pagado:
        return Colors.teal.shade700;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordenesAsync = ref.watch(ordenesTrabajoStreamProvider);

    return AppScaffold(
      title: 'Kanban — Órdenes',
      actions: [
        IconButton(
          icon: const Icon(Icons.view_list),
          tooltip: 'Vista lista',
          onPressed: () => context.go('/ordenes'),
        ),
      ],
      body: ordenesAsync.when(
        data: (ordenes) {
          if (ordenes.isEmpty) {
            return const XpEmptyState('No hay órdenes para mostrar.');
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _columnas.map((estado) {
                final items = ordenes.where((o) => o.estado == estado).toList();
                return Container(
                  width: 310,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: _colorColumna(estado).withValues(alpha: 0.15),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _tituloColumna(estado),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: _colorColumna(estado),
                                ),
                              ),
                            ),
                            CircleAvatar(
                              radius: 11,
                              backgroundColor: _colorColumna(estado),
                              child: Text(
                                '${items.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (items.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(18),
                          child: Text(
                            '—',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          child: Column(
                            children: items
                                .map(
                                  (orden) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: OrdenCard(orden: orden),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      const SizedBox(height: 6),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
