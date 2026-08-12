import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/xp_window.dart';
import '../../../finanzas/domain/entities/pago.dart';
import '../../domain/entities/item_carrito.dart';
import '../providers/pos_providers.dart';

class PosScreen extends ConsumerStatefulWidget {
  const PosScreen({super.key});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final List<ItemCarrito> _carrito = [];
  String? _skuSeleccionado;
  final _cantidadController = TextEditingController(text: '1');
  MetodoPago _metodoPago = MetodoPago.efectivo;
  bool _procesando = false;
  String? _mensaje;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  void _agregarAlCarrito(Map<String, dynamic> refaccion) {
    final cantidad = int.tryParse(_cantidadController.text) ?? 1;
    final precioVenta = (refaccion['precio_venta'] as num).toDouble();
    setState(() {
      final indexExistente = _carrito.indexWhere((i) => i.sku == refaccion['sku']);
      if (indexExistente >= 0) {
        final actual = _carrito[indexExistente];
        _carrito[indexExistente] = actual.copyWith(cantidad: actual.cantidad + cantidad);
      } else {
        _carrito.add(ItemCarrito(
          sku: refaccion['sku'] as String,
          nombre: refaccion['nombre'] as String,
          cantidad: cantidad,
          precioUnitario: precioVenta,
        ));
      }
      _skuSeleccionado = null;
      _cantidadController.text = '1';
    });
  }

  void _quitarDelCarrito(String sku) => setState(() => _carrito.removeWhere((i) => i.sku == sku));

  double get _total => _carrito.fold(0, (sum, i) => sum + i.subtotal);

  Future<void> _cobrar() async {
    setState(() {
      _procesando = true;
      _mensaje = null;
    });
    final resultado = await ref.read(registrarVentaUseCaseProvider)(
      _carrito,
      metodoPago: _metodoPago.name,
    );
    if (!mounted) return;
    resultado.fold(
      (failure) => setState(() {
        _mensaje = failure.mensaje;
        _procesando = false;
      }),
      (idVenta) {
        setState(() {
          _mensaje = 'Venta $idVenta registrada (${_metodoPago.name})';
          _carrito.clear();
          _procesando = false;
        });
        ref.invalidate(refaccionesPosProvider);
        ref.invalidate(ventasPosHistorialProvider);
      },
    );
  }

  int _stockDisponible(Map<String, dynamic> r) {
    if (r.containsKey('stock_disponible')) return r['stock_disponible'] as int;
    final actual = r['stock_actual'] as int? ?? 0;
    final reservado = r['stock_reservado'] as int? ?? 0;
    return actual - reservado;
  }

  @override
  void dispose() {
    _tabs.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Punto de Venta',
      bottom: TabBar(
        controller: _tabs,
        tabs: const [
          Tab(icon: Icon(Icons.point_of_sale), text: 'Vender'),
          Tab(icon: Icon(Icons.history), text: 'Historial'),
        ],
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _buildVentaTab(),
          _buildHistorialTab(),
        ],
      ),
    );
  }

  Widget _buildVentaTab() {
    final refaccionesAsync = ref.watch(refaccionesPosProvider);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          XpPanel(
            title: 'Agregar al carrito',
            child: refaccionesAsync.when(
            data: (refacciones) {
              if (refacciones.isEmpty) return const Text('No hay refacciones disponibles.');
              return Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      value: _skuSeleccionado,
                      decoration: const InputDecoration(labelText: 'Producto'),
                      items: refacciones.map((r) {
                        return DropdownMenuItem(
                          value: r['sku'] as String,
                          child: Text('${r['nombre']} (disp: ${_stockDisponible(r)})'),
                        );
                      }).toList(),
                      onChanged: (v) => setState(() => _skuSeleccionado = v),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _cantidadController,
                      decoration: const InputDecoration(labelText: 'Cant.'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _skuSeleccionado == null
                        ? null
                        : () {
                            final refaccion = refacciones.firstWhere((r) => r['sku'] == _skuSeleccionado);
                            _agregarAlCarrito(refaccion);
                          },
                    icon: const Icon(Icons.add_shopping_cart),
                  ),
                ],
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Error: $e'),
            ),
          ),
          const SizedBox(height: 8),
          XpPanel(
            title: 'Carrito',
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<MetodoPago>(
                  value: _metodoPago,
                  decoration: const InputDecoration(labelText: 'Método de pago'),
                  items: MetodoPago.values.map((m) => DropdownMenuItem(value: m, child: Text(m.name))).toList(),
                  onChanged: (v) => setState(() => _metodoPago = v ?? MetodoPago.efectivo),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 180,
                  child: _carrito.isEmpty
                      ? const Center(child: Text('Carrito vacío'))
                      : ListView.builder(
                          itemCount: _carrito.length,
                          itemBuilder: (context, index) {
                            final item = _carrito[index];
                            return XpEntityCard(
                              title: Text(item.nombre),
                              subtitle: Text('${item.cantidad} × \$${item.precioUnitario.toStringAsFixed(2)}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('\$${item.subtotal.toStringAsFixed(2)}'),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 20),
                                    onPressed: () => _quitarDelCarrito(item.sku),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                Text('Total: \$${_total.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium),
                if (_mensaje != null) ...[
                  const SizedBox(height: 8),
                  Text(_mensaje!),
                ],
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: _procesando || _carrito.isEmpty ? null : _cobrar,
                  child: _procesando
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Cobrar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorialTab() {
    final ventasAsync = ref.watch(ventasPosHistorialProvider);
    return ventasAsync.when(
      data: (ventas) {
        if (ventas.isEmpty) return const XpEmptyState('Sin ventas registradas.');
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: ventas.length,
          itemBuilder: (context, index) {
            final v = ventas[index];
            final total = (v['total'] as num?)?.toDouble() ?? 0;
            return XpEntityCard(
              leading: const Icon(Icons.receipt),
              title: Text('\$${total.toStringAsFixed(2)}'),
              subtitle: Text('${v['fecha']} · ${v['metodo_pago'] ?? 'efectivo'}'),
              trailing: Text('#${(v['id'] as String).substring(0, 8)}'),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
    );
  }
}
