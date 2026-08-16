import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/xp_window.dart';
import '../providers/crm_providers.dart';

class ClientesListScreen extends ConsumerWidget {
  const ClientesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientesAsync = ref.watch(clientesDisponiblesProvider);

    return AppScaffold(
      title: 'Clientes',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/clientes/crear'),
        icon: const Icon(Icons.person_add_alt),
        label: const Text('Nuevo cliente'),
      ),
      body: clientesAsync.when(
        data: (clientes) {
          if (clientes.isEmpty) {
            return const XpEmptyState('No hay clientes registrados.');
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: clientes.length,
            itemBuilder: (context, index) {
              final c = clientes[index];
              return XpEntityCard(
                leading: const Icon(Icons.person_outline),
                title: Text(c.nombreCompleto),
                subtitle: Text(c.telefono),
                trailing: c.esFlotilla
                    ? const XpStatusChip(
                        label: 'Flotilla',
                        color: Colors.indigo,
                      )
                    : null,
                onTap: () => context.go('/clientes/${c.id}'),
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
