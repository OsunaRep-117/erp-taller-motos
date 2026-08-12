import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/xp_window.dart';
import '../providers/crm_providers.dart';

class MotocicletasListScreen extends ConsumerWidget {
  const MotocicletasListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final motosAsync = ref.watch(motocicletasCrmProvider);

    return AppScaffold(
      title: 'Motocicletas',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/motocicletas/crear'),
        icon: const Icon(Icons.add),
        label: const Text('Nueva moto'),
      ),
      body: motosAsync.when(
        data: (motos) {
          if (motos.isEmpty) {
            return const XpEmptyState('No hay motocicletas registradas.');
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: motos.length,
            itemBuilder: (context, index) {
              final m = motos[index];
              return XpEntityCard(
                leading: const Icon(Icons.two_wheeler),
                title: Text('${m.placa} · ${m.marca} ${m.modelo}'),
                subtitle: Text('VIN: ${m.vin} · Año: ${m.anio}'),
                onTap: () => context.go('/motocicletas/${m.vin}'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
