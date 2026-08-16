import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../inventario/presentation/providers/inventario_providers.dart';
import '../../../taller/domain/entities/orden_trabajo.dart';
import '../../../taller/presentation/providers/orden_trabajo_providers.dart';
import '../providers/finanzas_providers.dart';

class ReportesEjecutivosScreen extends ConsumerWidget {
  const ReportesEjecutivosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordenesAsync = ref.watch(ordenesTrabajoStreamProvider);
    final ingresosAsync = ref.watch(ingresosMensualesProvider);
    final gastosAsync = ref.watch(gastosOperativosMesProvider);
    final valorInventarioAsync = ref.watch(valorInventarioProvider);
    final refaccionesAsync = ref.watch(refaccionesDisponiblesProvider);

    return AppScaffold(
      title: 'Reportes ejecutivos',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  title: 'Ingresos',
                  value: ingresosAsync.when(
                    data: (v) => '\$${v.toStringAsFixed(2)}',
                    loading: () => '...',
                    error: (_, __) => 'Error',
                  ),
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricTile(
                  title: 'Gastos',
                  value: gastosAsync.when(
                    data: (v) => '\$${v.toStringAsFixed(2)}',
                    loading: () => '...',
                    error: (_, __) => 'Error',
                  ),
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  title: 'Inventario',
                  value: valorInventarioAsync.when(
                    data: (v) => '\$${v.toStringAsFixed(2)}',
                    loading: () => '...',
                    error: (_, __) => 'Error',
                  ),
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricTile(
                  title: 'OT abiertas',
                  value: ordenesAsync.when(
                    data: (ordenes) => ordenes.length.toString(),
                    loading: () => '...',
                    error: (_, __) => 'Error',
                  ),
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionHeader('Riesgos operativos'),
          ordenesAsync.when(
            data: (ordenes) => _RiesgosCard(ordenes: ordenes),
            loading: () => const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Cargando riesgos...'),
              ),
            ),
            error: (e, _) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error: $e'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _SectionHeader('Top mecánicos'),
          ordenesAsync.when(
            data: (ordenes) => _TopMecanicosCard(ordenes: ordenes),
            loading: () => const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Cargando carga laboral...'),
              ),
            ),
            error: (e, _) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error: $e'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _SectionHeader('Inventario crítico'),
          refaccionesAsync.when(
            data: (refacciones) =>
                _InventarioCriticoCard(refacciones: refacciones),
            loading: () => const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Revisando niveles de stock...'),
              ),
            ),
            error: (e, _) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error inventario: $e'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
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
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _RiesgosCard extends StatelessWidget {
  const _RiesgosCard({required this.ordenes});

  final List<OrdenTrabajo> ordenes;

  @override
  Widget build(BuildContext context) {
    final pendientesPago = ordenes.where((o) => o.requierePago).length;
    final sinMecanico = ordenes
        .where((o) => o.idMecanico == null || o.idMecanico!.isEmpty)
        .length;
    final bloqueadas = ordenes
        .where((o) => o.bloqueosOperacion.isNotEmpty)
        .length;
    final criticas = ordenes.where((o) => o.slaExcedido).length;

    final items = [
      'Pagos pendientes: $pendientesPago',
      'Sin mecánico: $sinMecanico',
      'Bloqueadas: $bloqueadas',
      'SLA excedido: $criticas',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('• $item'),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _TopMecanicosCard extends StatelessWidget {
  const _TopMecanicosCard({required this.ordenes});

  final List<OrdenTrabajo> ordenes;

  @override
  Widget build(BuildContext context) {
    final mapa = <String, int>{};
    for (final orden in ordenes) {
      final idMecanico = orden.idMecanico;
      if (idMecanico == null || idMecanico.isEmpty) continue;
      mapa[idMecanico] = (mapa[idMecanico] ?? 0) + 1;
    }

    final top = mapa.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: top.isEmpty
              ? const [Text('Sin mecánicos con carga asignada.')]
              : top.take(3).map((entry) {
                  return ListTile(
                    dense: true,
                    title: Text(entry.key),
                    trailing: Text('${entry.value} OT'),
                  );
                }).toList(),
        ),
      ),
    );
  }
}

class _InventarioCriticoCard extends StatelessWidget {
  const _InventarioCriticoCard({required this.refacciones});

  final List<dynamic> refacciones;

  @override
  Widget build(BuildContext context) {
    final criticas = refacciones
        .where(
          (item) =>
              (item['stock_actual'] as int? ?? 0) <=
              (item['stock_minimo'] as int? ?? 0),
        )
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: criticas.isEmpty
            ? const Text('No hay refacciones en nivel crítico.')
            : Column(
                children: criticas.take(5).map((item) {
                  final nombre = item['nombre'] as String? ?? 'Refacción';
                  final actual = item['stock_actual'] as int? ?? 0;
                  final minimo = item['stock_minimo'] as int? ?? 0;
                  return ListTile(
                    dense: true,
                    title: Text(nombre),
                    subtitle: Text('Stock actual: $actual / mínimo: $minimo'),
                  );
                }).toList(),
              ),
      ),
    );
  }
}
