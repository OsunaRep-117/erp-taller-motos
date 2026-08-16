import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../finanzas/presentation/providers/finanzas_providers.dart';
import '../../../inventario/presentation/providers/inventario_providers.dart';
import '../../domain/entities/orden_trabajo.dart';
import '../providers/orden_trabajo_providers.dart';

class DashboardOperativoScreen extends ConsumerWidget {
  const DashboardOperativoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordenesAsync = ref.watch(ordenesTrabajoStreamProvider);
    final refaccionesAsync = ref.watch(refaccionesDisponiblesProvider);
    final ingresosAsync = ref.watch(ingresosMensualesProvider);

    return AppScaffold(
      title: 'Dashboard operativo',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  label: 'OT abiertas',
                  value: ordenesAsync.when(
                    data: (ordenes) => ordenes.length.toString(),
                    loading: () => '...',
                    error: (_, __) => 'Error',
                  ),
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  label: 'En proceso',
                  value: ordenesAsync.when(
                    data: (ordenes) => ordenes
                        .where((o) => o.estado == EstadoOrdenTrabajo.enProceso)
                        .length
                        .toString(),
                    loading: () => '...',
                    error: (_, __) => 'Error',
                  ),
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  label: 'Saldo pendiente',
                  value: ordenesAsync.when(
                    data: (ordenes) =>
                        '\$${ordenes.fold<double>(0, (sum, o) => sum + o.saldoPendiente).toStringAsFixed(2)}',
                    loading: () => '...',
                    error: (_, __) => 'Error',
                  ),
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  label: 'Ingresos mes',
                  value: ingresosAsync.when(
                    data: (v) => '\$${v.toStringAsFixed(2)}',
                    loading: () => '...',
                    error: (_, __) => 'Error',
                  ),
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionTitle('Alertas operativas'),
          _AlertsPanel(
            ordenesAsync: ordenesAsync,
            refaccionesAsync: refaccionesAsync,
          ),
          const SizedBox(height: 20),
          _SectionTitle('Órdenes recientes'),
          _RecentOrdersPanel(ordenesAsync: ordenesAsync),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _AlertsPanel extends StatelessWidget {
  const _AlertsPanel({
    required this.ordenesAsync,
    required this.refaccionesAsync,
  });

  final AsyncValue<List<OrdenTrabajo>> ordenesAsync;
  final AsyncValue<List<dynamic>> refaccionesAsync;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ordenesAsync.when(
              data: (ordenes) {
                final pendientesDePago = ordenes
                    .where((o) => o.requierePago)
                    .length;
                final sinMecanico = ordenes
                    .where((o) => o.idMecanico == null)
                    .length;
                final bloqueadas = ordenes
                    .where((o) => o.bloqueosOperacion.isNotEmpty)
                    .length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AlertRow(
                      label: 'OT pendientes de pago',
                      value: pendientesDePago.toString(),
                    ),
                    _AlertRow(
                      label: 'Sin mecánico asignado',
                      value: sinMecanico.toString(),
                    ),
                    _AlertRow(
                      label: 'Con bloqueos operativos',
                      value: bloqueadas.toString(),
                    ),
                  ],
                );
              },
              loading: () => const Text('Cargando alertas...'),
              error: (e, _) => Text('Error: $e'),
            ),
            const Divider(),
            refaccionesAsync.when(
              data: (refacciones) {
                final criticas = refacciones
                    .where(
                      (r) =>
                          (r['stock_actual'] as int? ?? 0) <=
                          (r['stock_minimo'] as int? ?? 0),
                    )
                    .length;
                final text = criticas == 0
                    ? 'Sin refacciones críticas'
                    : '$criticas refacciones en nivel crítico';
                return Text(
                  text,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                );
              },
              loading: () => const Text('Revisando inventario...'),
              error: (e, _) => Text('Error inventario: $e'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  const _AlertRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _RecentOrdersPanel extends StatelessWidget {
  const _RecentOrdersPanel({required this.ordenesAsync});

  final AsyncValue<List<OrdenTrabajo>> ordenesAsync;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ordenesAsync.when(
          data: (ordenes) {
            final recientes = ordenes.take(5).toList();
            if (recientes.isEmpty) {
              return const Text('Sin órdenes registradas.');
            }

            return Column(
              children: recientes.map((orden) {
                return ListTile(
                  dense: true,
                  title: Text(orden.id),
                  subtitle: Text(
                    '${orden.fallaReportada} · ${orden.estado.name}',
                  ),
                  trailing: Text(
                    '\$${orden.saldoPendiente.toStringAsFixed(2)}',
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
        ),
      ),
    );
  }
}
