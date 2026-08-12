import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/app_permissions.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/xp_window.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/inventario_providers.dart';

class InventarioListScreen extends ConsumerWidget {
  const InventarioListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refaccionesAsync = ref.watch(refaccionesDisponiblesProvider);
    final user = ref.watch(authStateProvider).valueOrNull;
    final puedeAjustar = user != null && AppPermissions.puedeAjustarInventario(user.rol);

    return AppScaffold(
      title: 'Inventario',
      actions: [
        if (puedeAjustar)
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Ajuste manual',
            onPressed: () => context.go('/inventario/ajustar'),
          ),
        IconButton(
          icon: const Icon(Icons.add_box_outlined),
          tooltip: 'Nuevo Producto',
          onPressed: () => context.go('/inventario/crear'),
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/compras/recibir'),
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Recibir Mercancía'),
      ),
      body: refaccionesAsync.when(
        data: (refacciones) {
          if (refacciones.isEmpty) {
            return const XpEmptyState('No hay refacciones registradas.');
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: refacciones.length,
            itemBuilder: (context, index) {
              final r = refacciones[index];
              final alerta = r.requiereReorden;
              return XpEntityCard(
                leading: const Icon(Icons.inventory_2_outlined),
                title: Text(r.nombre),
                subtitle: Text('SKU: ${r.sku} · Disponible: ${r.stockDisponible}'),
                trailing: alerta
                    ? const XpStatusChip(label: 'Reordenar', color: Color(0xFFE6A817))
                    : Text('\$${r.precioVenta.toStringAsFixed(2)}'),
                onTap: () => context.go('/inventario/${r.sku}'),
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
