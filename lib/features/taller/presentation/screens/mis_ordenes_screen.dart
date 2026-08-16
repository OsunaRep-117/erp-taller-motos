import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/xp_window.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/orden_trabajo.dart';
import '../providers/orden_trabajo_providers.dart';

class MisOrdenesScreen extends ConsumerWidget {
  const MisOrdenesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;

    if (user == null) {
      return const AppScaffold(
        title: 'Mis órdenes',
        body: Center(
          child: Text('Inicia sesión para ver tus trabajos asignados.'),
        ),
      );
    }

    final ordenesAsync = ref.watch(ordenesDelMecanicoProvider(user.id));

    return AppScaffold(
      title: 'Mis órdenes',
      actions: [
        IconButton(
          onPressed: () => context.go('/ordenes'),
          icon: const Icon(Icons.list_alt_outlined),
          tooltip: 'Ver todas las órdenes',
        ),
      ],
      body: ordenesAsync.when(
        data: (ordenes) {
          if (ordenes.isEmpty) {
            return const XpEmptyState('Todavía no tienes órdenes asignadas.');
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: ordenes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final orden = ordenes[index];
              return _OrdenAsignadaCard(orden: orden);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _OrdenAsignadaCard extends StatelessWidget {
  final OrdenTrabajo orden;

  const _OrdenAsignadaCard({required this.orden});

  Color _colorEstado(EstadoOrdenTrabajo estado) {
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
        return Colors.grey.shade700;
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
          Expanded(child: Text('#${orden.id.substring(0, 8)}')),
          XpStatusChip(
            label: orden.estado.name,
            color: _colorEstado(orden.estado),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          Text(
            orden.fallaReportada,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.motorcycle_outlined, size: 14),
              const SizedBox(width: 4),
              Text('Moto: ${orden.idMoto}'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.schedule_outlined, size: 14),
              const SizedBox(width: 4),
              Text('Horas: ${orden.horasFacturables.toStringAsFixed(1)}'),
              const SizedBox(width: 12),
              const Icon(Icons.attach_money_outlined, size: 14),
              const SizedBox(width: 4),
              Text('Saldo: \$${orden.saldoPendiente.toStringAsFixed(2)}'),
            ],
          ),
        ],
      ),
    );
  }
}
