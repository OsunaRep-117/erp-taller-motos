import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/xp_window.dart';
import '../../domain/entities/orden_compra.dart';
import '../providers/compras_providers.dart';

class OrdenesCompraListScreen extends ConsumerWidget {
  const OrdenesCompraListScreen({super.key});

  Color _colorEstado(EstadoOrdenCompra estado) {
    switch (estado) {
      case EstadoOrdenCompra.aprobada:
        return Colors.green.shade700;
      case EstadoOrdenCompra.recibida:
        return Colors.teal.shade700;
      case EstadoOrdenCompra.cancelada:
        return Colors.red.shade700;
      default:
        return XpColors.selection;
    }
  }

  Future<void> _aprobar(WidgetRef ref, BuildContext context, String id) async {
    final r = await ref.read(aprobarOrdenCompraUseCaseProvider)(id);
    if (!context.mounted) return;
    r.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ref.invalidate(ordenesCompraListProvider);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('OC aprobada.')));
      },
    );
  }

  Future<void> _recibir(WidgetRef ref, BuildContext context, String id) async {
    final r = await ref.read(recibirOrdenCompraUseCaseProvider)(id);
    if (!context.mounted) return;
    r.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ref.invalidate(ordenesCompraListProvider);
        ref.invalidate(entradasInventarioProvider);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Mercancía recibida.')));
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordenesAsync = ref.watch(ordenesCompraListProvider);
    final proveedoresAsync = ref.watch(proveedoresDisponiblesProvider);

    return AppScaffold(
      title: 'Órdenes de Compra',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/compras/ordenes/crear'),
        icon: const Icon(Icons.add),
        label: const Text('Nueva OC'),
      ),
      body: ordenesAsync.when(
        data: (ordenes) {
          if (ordenes.isEmpty) {
            return const XpEmptyState('No hay órdenes de compra.');
          }
          final proveedores = proveedoresAsync.value ?? [];
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: ordenes.length,
            itemBuilder: (context, index) {
              final oc = ordenes[index];
              final prov = proveedores.where((p) => p.id == oc.idProveedor);
              final nombreProv = prov.isEmpty
                  ? oc.idProveedor
                  : prov.first.nombre;

              return XpEntityCard(
                title: Row(
                  children: [
                    Expanded(child: Text(nombreProv)),
                    XpStatusChip(
                      label: oc.estado.name,
                      color: _colorEstado(oc.estado),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total: \$${oc.total.toStringAsFixed(2)}'),
                    Text(
                      'Creada: ${oc.fechaCreacion.day}/${oc.fechaCreacion.month}/${oc.fechaCreacion.year}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    if (oc.estado == EstadoOrdenCompra.borrador) ...[
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: () => _aprobar(ref, context, oc.id),
                        child: const Text('Aprobar OC'),
                      ),
                    ],
                    if (oc.estado == EstadoOrdenCompra.aprobada) ...[
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: () => _recibir(ref, context, oc.id),
                        child: const Text('Recibir mercancía'),
                      ),
                    ],
                  ],
                ),
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
