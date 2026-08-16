import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/auth/app_permissions.dart';
import '../../../../core/data/mock/mock_data_store.dart';
import '../../../../core/data/mock_backend.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/inventario_providers.dart';

class RefaccionDetailScreen extends ConsumerWidget {
  final String sku;
  const RefaccionDetailScreen({super.key, required this.sku});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refaccionAsync = ref.watch(refaccionPorSkuProvider(sku));
    final user = ref.watch(authStateProvider).valueOrNull;
    final puedeVerCostos =
        user != null && AppPermissions.puedeVerCostos(user.rol);

    return AppScaffold(
      title: 'Refacción $sku',
      body: refaccionAsync.when(
        data: (ref) {
          final historial = _obtenerHistorial(sku);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ref.nombre,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text('SKU: ${ref.sku}'),
                      if (puedeVerCostos)
                        Text('Costo: \$${ref.precioCosto.toStringAsFixed(2)}'),
                      Text(
                        'Precio venta: \$${ref.precioVenta.toStringAsFixed(2)}',
                      ),
                      Text('Stock actual: ${ref.stockActual}'),
                      Text('Reservado: ${ref.stockReservado}'),
                      Text('Disponible: ${ref.stockDisponible}'),
                      Text('Mínimo: ${ref.stockMinimo}'),
                      if (ref.requiereReorden)
                        const Chip(
                          label: Text('Requiere reorden'),
                          backgroundColor: Color(0xFFFAC775),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Entradas de compra',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (historial.entradas.isEmpty)
                const Text('Sin entradas registradas.')
              else
                ...historial.entradas.map(
                  (e) => ListTile(
                    leading: const Icon(Icons.move_to_inbox),
                    title: Text('+${e.cantidad} unidades'),
                    subtitle: Text(
                      'Costo unit: \$${e.costoUnitario} · ${e.fecha}',
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                'Ajustes manuales',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (historial.ajustes.isEmpty)
                const Text('Sin ajustes registrados.')
              else
                ...historial.ajustes.map(
                  (a) => ListTile(
                    leading: Icon(a.cantidad >= 0 ? Icons.add : Icons.remove),
                    title: Text('${a.cantidad >= 0 ? '+' : ''}${a.cantidad}'),
                    subtitle: Text('${a.justificacion}\n${a.fecha}'),
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }

  _HistorialSku _obtenerHistorial(String sku) {
    if (!AppConfig.useMockBackend) {
      return const _HistorialSku(entradas: [], ajustes: []);
    }
    final store = MockBackend.store..ensureSeeded();
    return _HistorialSku(
      entradas: store.entradasInventario.where((e) => e.sku == sku).toList(),
      ajustes: store.ajustesInventario.where((a) => a.sku == sku).toList(),
    );
  }
}

class _HistorialSku {
  final List<EntradaInventario> entradas;
  final List<AjusteInventario> ajustes;
  const _HistorialSku({required this.entradas, required this.ajustes});
}
