import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/xp_window.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../finanzas/presentation/providers/finanzas_providers.dart';
import '../../domain/entities/orden_trabajo.dart';
import '../providers/orden_trabajo_providers.dart';
import '../widgets/orden_card.dart';

class OrdenesListScreen extends ConsumerWidget {
  const OrdenesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordenesAsync = ref.watch(ordenesTrabajoStreamProvider);
    final userAsync = ref.watch(authStateProvider);
    final esAdmin = userAsync.valueOrNull?.rol == RolEmpleado.admin;

    return AppScaffold(
      title: 'Órdenes de Trabajo',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/ordenes/crear'),
        icon: const Icon(Icons.add),
        label: const Text('Nueva orden'),
      ),
      body: Column(
        children: [
          if (esAdmin) _buildAdminKPIs(ref),
          Expanded(
            child: ordenesAsync.when(
              data: (ordenes) {
                if (ordenes.isEmpty) {
                  return const XpEmptyState('No hay órdenes registradas.');
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: ordenes.length,
                  itemBuilder: (context, index) => OrdenCard(orden: ordenes[index]),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminKPIs(WidgetRef ref) {
    final ingresosAsync = ref.watch(ingresosMensualesProvider);
    final valorInvAsync = ref.watch(valorInventarioProvider);
    final ordenesAsync = ref.watch(ordenesTrabajoStreamProvider);

    final otActivas = ordenesAsync.maybeWhen(
      data: (ordenes) => ordenes
          .where((o) =>
              o.estado != EstadoOrdenTrabajo.entregado &&
              o.estado != EstadoOrdenTrabajo.cancelada)
          .length
          .toString(),
      orElse: () => '...',
    );

    return Padding(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            XpKpiCard(
              label: 'Ingresos Mes',
              value: ingresosAsync.when(
                data: (t) => '\$${t.toStringAsFixed(2)}',
                loading: () => '...',
                error: (_, __) => 'Err',
              ),
              accent: Colors.green.shade700,
            ),
            const SizedBox(width: 8),
            XpKpiCard(
              label: 'Valor Almacén',
              value: valorInvAsync.when(
                data: (t) => '\$${t.toStringAsFixed(2)}',
                loading: () => '...',
                error: (_, __) => 'Err',
              ),
              accent: Colors.orange.shade800,
            ),
            const SizedBox(width: 8),
            XpKpiCard(label: 'OT activas', value: otActivas, accent: XpColors.selection),
          ],
        ),
      ),
    );
  }
}
