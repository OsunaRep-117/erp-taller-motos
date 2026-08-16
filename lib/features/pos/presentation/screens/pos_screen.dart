import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/xp_window.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../finanzas/domain/entities/pago.dart';
import '../../../finanzas/presentation/providers/finanzas_providers.dart';
import '../../../../core/config/app_config.dart';
import '../../../taller/domain/entities/orden_trabajo.dart';
import '../../../taller/presentation/providers/orden_trabajo_providers.dart';
import '../../domain/entities/item_carrito.dart';
import '../providers/pos_providers.dart';

class PosScreen extends ConsumerStatefulWidget {
  const PosScreen({super.key});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final List<ItemCarrito> _carrito = [];
  String? _skuSeleccionado;
  final _cantidadController = TextEditingController(text: '1');
  final _efectivoContadoController = TextEditingController();
  final _pinDevolucionController = TextEditingController();
  final _montoPagoOtController = TextEditingController();
  String? _ventaDevolucionId;
  String? _ordenPagoSeleccionada;
  MetodoPago _metodoPago = MetodoPago.efectivo;
  bool _procesando = false;
  String? _mensaje;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
  }

  void _agregarAlCarrito(Map<String, dynamic> refaccion) {
    final cantidad = int.tryParse(_cantidadController.text) ?? 1;
    final precioVenta = (refaccion['precio_venta'] as num).toDouble();
    setState(() {
      final indexExistente = _carrito.indexWhere(
        (i) => i.sku == refaccion['sku'],
      );
      if (indexExistente >= 0) {
        final actual = _carrito[indexExistente];
        _carrito[indexExistente] = actual.copyWith(
          cantidad: actual.cantidad + cantidad,
        );
      } else {
        _carrito.add(
          ItemCarrito(
            sku: refaccion['sku'] as String,
            nombre: refaccion['nombre'] as String,
            cantidad: cantidad,
            precioUnitario: precioVenta,
          ),
        );
      }
      _skuSeleccionado = null;
      _cantidadController.text = '1';
    });
  }

  void _quitarDelCarrito(String sku) =>
      setState(() => _carrito.removeWhere((i) => i.sku == sku));

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

  Future<void> _registrarPagoOrdenTrabajo() async {
    final idOrden = _ordenPagoSeleccionada;
    if (idOrden == null) {
      setState(() => _mensaje = 'Selecciona una orden de trabajo.');
      return;
    }

    final monto = double.tryParse(_montoPagoOtController.text) ?? 0;
    if (monto <= 0) {
      setState(() => _mensaje = 'El monto del pago debe ser mayor a 0.');
      return;
    }

    setState(() {
      _procesando = true;
      _mensaje = null;
    });

    final resultado = await ref.read(registrarPagoUseCaseProvider)(
      idOrden: idOrden,
      monto: monto,
      metodoPago: _metodoPago,
    );

    if (!mounted) return;
    setState(() => _procesando = false);

    resultado.fold((failure) => setState(() => _mensaje = failure.mensaje), (
      _,
    ) {
      setState(() {
        _mensaje = 'Pago de la OT $idOrden registrado.';
        _ordenPagoSeleccionada = null;
        _montoPagoOtController.clear();
      });
      ref.invalidate(ordenPorIdProvider(idOrden));
      ref.invalidate(pagosPorOrdenProvider(idOrden));
    });
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
    _efectivoContadoController.dispose();
    _pinDevolucionController.dispose();
    _montoPagoOtController.dispose();
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
          Tab(icon: Icon(Icons.lock_outline), text: 'Cierre caja'),
          Tab(icon: Icon(Icons.undo), text: 'Devoluciones'),
        ],
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _buildVentaTab(),
          _buildHistorialTab(),
          _buildCierreCajaTab(),
          _buildDevolucionesTab(),
        ],
      ),
    );
  }

  Widget _buildVentaTab() {
    final refaccionesAsync = ref.watch(refaccionesPosProvider);
    final ordenesAsync = ref.watch(ordenesTrabajoStreamProvider);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          XpPanel(
            title: 'Agregar al carrito',
            child: refaccionesAsync.when(
              data: (refacciones) {
                if (refacciones.isEmpty)
                  return const Text('No hay refacciones disponibles.');
                return Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<String>(
                        value: _skuSeleccionado,
                        decoration: const InputDecoration(
                          labelText: 'Producto',
                        ),
                        items: refacciones.map((r) {
                          return DropdownMenuItem(
                            value: r['sku'] as String,
                            child: Text(
                              '${r['nombre']} (disp: ${_stockDisponible(r)})',
                            ),
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
                              final refaccion = refacciones.firstWhere(
                                (r) => r['sku'] == _skuSeleccionado,
                              );
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
                  decoration: const InputDecoration(
                    labelText: 'Método de pago',
                  ),
                  items: MetodoPago.values
                      .map(
                        (m) => DropdownMenuItem(value: m, child: Text(m.name)),
                      )
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _metodoPago = v ?? MetodoPago.efectivo),
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
                              subtitle: Text(
                                '${item.cantidad} × \$${item.precioUnitario.toStringAsFixed(2)}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('\$${item.subtotal.toStringAsFixed(2)}'),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 20,
                                    ),
                                    onPressed: () =>
                                        _quitarDelCarrito(item.sku),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                Text(
                  'Total: \$${_total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (_mensaje != null) ...[
                  const SizedBox(height: 8),
                  Text(_mensaje!),
                ],
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: _procesando || _carrito.isEmpty ? null : _cobrar,
                  child: _procesando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Cobrar'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          XpPanel(
            title: 'Pago por orden de trabajo',
            child: ordenesAsync.when(
              data: (ordenes) {
                final ordenesPendientes = ordenes
                    .where(
                      (o) =>
                          o.saldoPendiente > 0 &&
                          (o.estado == EstadoOrdenTrabajo.terminado ||
                              o.estado == EstadoOrdenTrabajo.pagado),
                    )
                    .toList();

                if (ordenesPendientes.isEmpty) {
                  return const Text(
                    'No hay órdenes con saldo pendiente por cobrar.',
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _ordenPagoSeleccionada,
                      decoration: const InputDecoration(labelText: 'Orden'),
                      items: ordenesPendientes
                          .map(
                            (o) => DropdownMenuItem<String>(
                              value: o.id,
                              child: Text(
                                '${o.id.substring(0, 8)} · saldo: \$${o.saldoPendiente.toStringAsFixed(2)}',
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (id) {
                        setState(() {
                          _ordenPagoSeleccionada = id;
                          final orden = ordenesPendientes.firstWhere(
                            (o) => o.id == id,
                          );
                          _montoPagoOtController.text = orden.saldoPendiente
                              .toStringAsFixed(2);
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _montoPagoOtController,
                      decoration: const InputDecoration(
                        labelText: 'Monto a cobrar',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    FilledButton.icon(
                      onPressed: _procesando
                          ? null
                          : _registrarPagoOrdenTrabajo,
                      icon: const Icon(Icons.payments_outlined),
                      label: const Text('Cobrar trabajo'),
                    ),
                  ],
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
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
        if (ventas.isEmpty)
          return const XpEmptyState('Sin ventas registradas.');
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: ventas.length,
          itemBuilder: (context, index) {
            final v = ventas[index];
            final total = (v['total'] as num?)?.toDouble() ?? 0;
            return XpEntityCard(
              leading: const Icon(Icons.receipt),
              title: Text('\$${total.toStringAsFixed(2)}'),
              subtitle: Text(
                '${v['fecha']} · ${v['metodo_pago'] ?? 'efectivo'}',
              ),
              trailing: (v['devuelta'] as bool? ?? false)
                  ? const Chip(
                      label: Text('Devuelta', style: TextStyle(fontSize: 11)),
                    )
                  : Text('#${(v['id'] as String).substring(0, 8)}'),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
    );
  }

  Widget _buildCierreCajaTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Cierre de caja ciego (§5.3): ingresa el efectivo contado antes de ver el monto esperado.',
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _efectivoContadoController,
            decoration: const InputDecoration(
              labelText: 'Efectivo contado en caja',
              prefixText: '\$ ',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _procesando ? null : _cerrarCaja,
            child: _procesando
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Registrar cierre'),
          ),
        ],
      ),
    );
  }

  Future<void> _cerrarCaja() async {
    final contado = double.tryParse(_efectivoContadoController.text) ?? -1;
    setState(() => _procesando = true);
    final result = await ref.read(cierreCajaCiegoUseCaseProvider)(
      efectivoContado: contado,
    );
    if (!mounted) return;
    setState(() => _procesando = false);
    result.fold((f) => setState(() => _mensaje = f.mensaje), (cierre) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Resultado del cierre'),
          content: Text(
            'Contado: \$${cierre.efectivoContado.toStringAsFixed(2)}\n'
            'Esperado: \$${cierre.efectivoEsperado.toStringAsFixed(2)}\n'
            'Diferencia: \$${cierre.diferencia.toStringAsFixed(2)}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      _efectivoContadoController.clear();
    });
  }

  Widget _buildDevolucionesTab() {
    final ventasAsync = ref.watch(ventasPosHistorialProvider);
    final user = ref.watch(authStateProvider).value;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Devolución con ticket original + PIN supervisor (§5.3). PIN demo: ${AppConfig.posAutorizacionPin}',
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 12),
          ventasAsync.when(
            data: (ventas) {
              final activas = ventas
                  .where((v) => !(v['devuelta'] as bool? ?? false))
                  .toList();
              return DropdownButtonFormField<String>(
                value: _ventaDevolucionId,
                decoration: const InputDecoration(labelText: 'Ticket / venta'),
                items: activas
                    .map(
                      (v) => DropdownMenuItem(
                        value: v['id'] as String,
                        child: Text(
                          '#${(v['id'] as String).substring(0, 8)} · \$${(v['total'] as num).toStringAsFixed(2)}',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _ventaDevolucionId = v),
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('$e'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _pinDevolucionController,
            decoration: const InputDecoration(labelText: 'PIN supervisor'),
            obscureText: true,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _procesando || _ventaDevolucionId == null
                ? null
                : _procesarDevolucion,
            child: const Text('Procesar devolución'),
          ),
        ],
      ),
    );
  }

  Future<void> _procesarDevolucion() async {
    final user = ref.read(authStateProvider).value;
    setState(() => _procesando = true);
    final result = await ref.read(devolverVentaPosUseCaseProvider)(
      idVenta: _ventaDevolucionId!,
      pinAutorizacion: _pinDevolucionController.text,
      usuarioActual: user,
    );
    if (!mounted) return;
    setState(() => _procesando = false);
    result.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        _pinDevolucionController.clear();
        _ventaDevolucionId = null;
        ref.invalidate(refaccionesPosProvider);
        ref.invalidate(ventasPosHistorialProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Devolución registrada. Inventario reingresado.'),
          ),
        );
      },
    );
  }
}
