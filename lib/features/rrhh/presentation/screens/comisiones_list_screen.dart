import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/xp_window.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/rrhh_providers.dart';

class ComisionesListScreen extends ConsumerWidget {
  const ComisionesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comisionesAsync = ref.watch(comisionesVisiblesProvider);
    final usuarioAsync = ref.watch(authStateProvider);
    final esAdmin = usuarioAsync.valueOrNull?.esAdmin ?? false;

    return AppScaffold(
      title: esAdmin ? 'Comisiones (todos)' : 'Mis comisiones',
      body: comisionesAsync.when(
        data: (comisiones) {
          if (comisiones.isEmpty) {
            return const XpEmptyState(
              'Aún no hay comisiones generadas.\nSe calculan automáticamente al pagar una orden.',
            );
          }
          final total = comisiones.fold<double>(0, (sum, c) => sum + c.monto);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: XpKpiCard(
                  label: 'Total comisiones',
                  value: '\$${total.toStringAsFixed(2)}',
                  accent: XpColors.selection,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: comisiones.length,
                  itemBuilder: (context, index) {
                    final c = comisiones[index];
                    return XpEntityCard(
                      leading: const Icon(Icons.payments_outlined),
                      title: Text('Orden ${c.idOrden}'),
                      subtitle: Text('${c.porcentajeAplicado}% · ${c.fechaGenerada}'),
                      trailing: Text('\$${c.monto.toStringAsFixed(2)}'),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
