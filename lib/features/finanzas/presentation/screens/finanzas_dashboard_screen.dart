import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/xp_window.dart';
import '../providers/finanzas_providers.dart';

class FinanzasDashboardScreen extends ConsumerWidget {
  const FinanzasDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingresosAsync = ref.watch(ingresosMensualesProvider);
    final valorInvAsync = ref.watch(valorInventarioProvider);
    final pagosAsync = ref.watch(todosLosPagosProvider);
    final facturasAsync = ref.watch(todasLasFacturasProvider);

    return AppScaffold(
      title: 'Finanzas',
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Row(
            children: [
              Expanded(
                child: XpKpiCard(
                  label: 'Ingresos del mes',
                  value: ingresosAsync.when(
                    data: (v) => '\$${v.toStringAsFixed(2)}',
                    loading: () => '...',
                    error: (_, __) => 'Error',
                  ),
                  accent: Colors.green.shade700,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: XpKpiCard(
                  label: 'Valor inventario',
                  value: valorInvAsync.when(
                    data: (v) => '\$${v.toStringAsFixed(2)}',
                    loading: () => '...',
                    error: (_, __) => 'Error',
                  ),
                  accent: Colors.orange.shade800,
                ),
              ),
            ],
          ),
          const XpSectionTitle('Pagos recientes'),
          XpPanel(
            child: AsyncValueView(
              value: pagosAsync,
              empty: const Text('Sin pagos registrados.'),
              isEmpty: (pagos) => pagos.isEmpty,
              builder: (pagos) => Column(
                children: pagos.take(10).map((p) {
                  return XpEntityCard(
                    leading: const Icon(Icons.payments),
                    title: Text('\$${p.monto.toStringAsFixed(2)}'),
                    subtitle: Text('OT: ${p.idOrden} · ${p.metodoPago.name}'),
                  );
                }).toList(),
              ),
            ),
          ),
          const XpSectionTitle('Facturas'),
          XpPanel(
            child: AsyncValueView(
              value: facturasAsync,
              empty: const Text('Sin facturas emitidas.'),
              isEmpty: (f) => f.isEmpty,
              builder: (facturas) => Column(
                children: facturas.map((f) {
                  return XpEntityCard(
                    leading: Icon(
                      f.estado.name == 'vigente' ? Icons.receipt_long : Icons.receipt_long_outlined,
                    ),
                    title: Text(f.folioFiscal),
                    subtitle: Text('OT: ${f.idOrden} · ${f.estado.name}'),
                    trailing: f.estado.name == 'vigente'
                        ? IconButton(
                            icon: const Icon(Icons.note_alt_outlined),
                            onPressed: () => _mostrarNotaCredito(context, ref, f.id),
                          )
                        : null,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _mostrarNotaCredito(BuildContext context, WidgetRef ref, String idFactura) async {
    final motivoController = TextEditingController();
    final montoController = TextEditingController();

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Generar nota de crédito'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: motivoController,
              decoration: const InputDecoration(labelText: 'Motivo'),
            ),
            TextField(
              controller: montoController,
              decoration: const InputDecoration(labelText: 'Monto'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Generar')),
        ],
      ),
    );

    if (confirmar != true || !context.mounted) return;

    final monto = double.tryParse(montoController.text) ?? 0;
    final resultado = await ref.read(generarNotaCreditoUseCaseProvider)(
      idFactura: idFactura,
      motivo: motivoController.text,
      monto: monto,
    );

    if (!context.mounted) return;
    resultado.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ref.invalidate(todasLasFacturasProvider);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nota de crédito generada.')));
      },
    );
  }
}
