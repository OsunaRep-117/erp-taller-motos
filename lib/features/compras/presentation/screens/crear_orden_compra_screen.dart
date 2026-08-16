import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../inventario/presentation/providers/inventario_providers.dart';
import '../../domain/entities/orden_compra.dart';
import '../providers/compras_providers.dart';

class _LineaOc {
  final String sku;
  final int cantidad;
  final double precio;
  const _LineaOc(this.sku, this.cantidad, this.precio);
}

class CrearOrdenCompraScreen extends ConsumerStatefulWidget {
  const CrearOrdenCompraScreen({super.key});

  @override
  ConsumerState<CrearOrdenCompraScreen> createState() =>
      _CrearOrdenCompraScreenState();
}

class _CrearOrdenCompraScreenState
    extends ConsumerState<CrearOrdenCompraScreen> {
  String? _proveedorId;
  String? _sku;
  final _cantidadController = TextEditingController(text: '1');
  final _precioController = TextEditingController();
  final List<_LineaOc> _lineas = [];
  bool _guardando = false;

  void _agregarLinea() {
    final cantidad = int.tryParse(_cantidadController.text) ?? 0;
    final precio = double.tryParse(_precioController.text) ?? 0;
    if (_sku == null || cantidad <= 0 || precio <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa SKU, cantidad y precio de compra.'),
        ),
      );
      return;
    }
    setState(() {
      _lineas.add(_LineaOc(_sku!, cantidad, precio));
      _sku = null;
      _cantidadController.text = '1';
      _precioController.clear();
    });
  }

  Future<void> _guardar() async {
    if (_proveedorId == null || _lineas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona proveedor y agrega ítems.')),
      );
      return;
    }
    setState(() => _guardando = true);
    final result = await ref.read(crearOrdenCompraUseCaseProvider)(
      idProveedor: _proveedorId!,
      items: _lineas
          .map(
            (l) => CompraDetalle(
              idCompra: '',
              skuRefaccion: l.sku,
              cantidad: l.cantidad,
              precioCompra: l.precio,
            ),
          )
          .toList(),
    );
    if (!mounted) return;
    setState(() => _guardando = false);
    result.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ref.invalidate(ordenesCompraListProvider);
        context.go('/compras/ordenes');
      },
    );
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final proveedoresAsync = ref.watch(proveedoresDisponiblesProvider);
    final refaccionesAsync = ref.watch(refaccionesDisponiblesProvider);

    return AppScaffold(
      title: 'Nueva orden de compra',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              proveedoresAsync.when(
                data: (ps) => DropdownButtonFormField<String>(
                  value: _proveedorId,
                  decoration: const InputDecoration(labelText: 'Proveedor'),
                  items: ps
                      .map(
                        (p) => DropdownMenuItem(
                          value: p.id,
                          child: Text(p.nombre),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _proveedorId = v),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
              ),
              const SizedBox(height: 16),
              refaccionesAsync.when(
                data: (refs) => DropdownButtonFormField<String>(
                  value: _sku,
                  decoration: const InputDecoration(labelText: 'Refacción'),
                  items: refs
                      .map(
                        (r) => DropdownMenuItem(
                          value: r.sku,
                          child: Text('${r.sku} · ${r.nombre}'),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _sku = v),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _cantidadController,
                      decoration: const InputDecoration(labelText: 'Cantidad'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _precioController,
                      decoration: const InputDecoration(
                        labelText: 'Precio compra',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _agregarLinea,
                icon: const Icon(Icons.add),
                label: const Text('Agregar línea'),
              ),
              const SizedBox(height: 16),
              if (_lineas.isNotEmpty)
                ..._lineas.map(
                  (l) => ListTile(
                    dense: true,
                    title: Text('${l.sku} × ${l.cantidad}'),
                    subtitle: Text('\$${l.precio.toStringAsFixed(2)} c/u'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => setState(() => _lineas.remove(l)),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _guardando ? null : _guardar,
                child: _guardando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Crear OC (borrador)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
