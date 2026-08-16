import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../providers/compras_providers.dart';

class ComprasHomeScreen extends ConsumerWidget {
  const ComprasHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proveedoresAsync = ref.watch(proveedoresDisponiblesProvider);
    final entradasAsync = ref.watch(entradasInventarioProvider);

    return AppScaffold(
      title: 'Compras',
      actions: [
        IconButton(
          icon: const Icon(Icons.add_business),
          tooltip: 'Nuevo proveedor',
          onPressed: () => context.go('/compras/proveedores/crear'),
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/compras/recibir'),
        icon: const Icon(Icons.inventory),
        label: const Text('Recibir mercancía'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: const Text('Órdenes de compra'),
            subtitle: const Text('Flujo borrador → aprobada → recibida'),
            onTap: () => context.go('/compras/ordenes'),
          ),
          const Divider(),
          Text('Proveedores', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          AsyncValueView(
            value: proveedoresAsync,
            builder: (proveedores) => Column(
              children: proveedores
                  .map(
                    (p) => ListTile(
                      leading: const Icon(Icons.local_shipping_outlined),
                      title: Text(p.nombre),
                      subtitle: Text(p.contacto),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Historial de entradas',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          AsyncValueView(
            value: entradasAsync,
            empty: const Text('Sin entradas registradas.'),
            isEmpty: (e) => e.isEmpty,
            builder: (entradas) => Column(
              children: entradas
                  .map(
                    (e) => ListTile(
                      leading: const Icon(Icons.move_to_inbox),
                      title: Text('${e['sku']} x${e['cantidad']}'),
                      subtitle: Text('Costo: \$${e['costo_unitario']}'),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
