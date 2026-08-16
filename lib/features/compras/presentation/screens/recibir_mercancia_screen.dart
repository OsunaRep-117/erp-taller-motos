import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/xp_window.dart';
import '../../../inventario/presentation/providers/inventario_providers.dart';
import '../providers/compras_providers.dart';

class RecibirMercanciaScreen extends ConsumerStatefulWidget {
  const RecibirMercanciaScreen({super.key});

  @override
  ConsumerState<RecibirMercanciaScreen> createState() =>
      _RecibirMercanciaScreenState();
}

class _RecibirMercanciaScreenState
    extends ConsumerState<RecibirMercanciaScreen> {
  String? _skuSeleccionado;
  String? _proveedorSeleccionado;
  final _cantidadController = TextEditingController(text: '1');
  final _costoController = TextEditingController();
  bool _procesando = false;

  Future<void> _guardar() async {
    if (_skuSeleccionado == null || _proveedorSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona producto y proveedor.')),
      );
      return;
    }

    final cantidad = int.tryParse(_cantidadController.text) ?? 0;
    final costo = double.tryParse(_costoController.text) ?? 0;

    if (cantidad <= 0 || costo <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cantidad y costo deben ser mayores a cero.'),
        ),
      );
      return;
    }

    setState(() => _procesando = true);

    final resultado = await ref
        .read(comprasRepositoryProvider)
        .recibirMercancia(
          sku: _skuSeleccionado!,
          cantidad: cantidad,
          costoUnitario: costo,
          idProveedor: _proveedorSeleccionado!,
        );

    if (!mounted) return;
    setState(() => _procesando = false);

    resultado.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mercancía recibida e inventario actualizado.'),
          ),
        );
        ref.invalidate(refaccionesDisponiblesProvider);
        context.pop();
      },
    );
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _costoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final refaccionesAsync = ref.watch(refaccionesDisponiblesProvider);
    final proveedoresAsync = ref.watch(proveedoresDisponiblesProvider);

    return AppScaffold(
      title: 'Recibir Mercancía',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: XpWindow(
            title: 'Entrada de inventario',
            maxWidth: 520,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                refaccionesAsync.when(
                  data: (items) => DropdownButtonFormField<String>(
                    value: _skuSeleccionado,
                    decoration: const InputDecoration(
                      labelText: 'Producto / Refacción',
                    ),
                    items: items
                        .map(
                          (r) => DropdownMenuItem(
                            value: r.sku,
                            child: Text(r.nombre),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _skuSeleccionado = v),
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('Error: $e'),
                ),
                const SizedBox(height: 16),
                proveedoresAsync.when(
                  data: (items) => DropdownButtonFormField<String>(
                    value: _proveedorSeleccionado,
                    decoration: const InputDecoration(labelText: 'Proveedor'),
                    items: items
                        .map(
                          (p) => DropdownMenuItem(
                            value: p.id,
                            child: Text(p.nombre),
                          ),
                        )
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _proveedorSeleccionado = v),
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('Error: $e'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _cantidadController,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad recibida',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _costoController,
                  decoration: const InputDecoration(
                    labelText: 'Costo unitario de compra',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _procesando ? null : _guardar,
                  child: _procesando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Registrar Entrada'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
