import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../finanzas/domain/entities/pago.dart';
import '../../../finanzas/presentation/providers/finanzas_providers.dart';
import '../../../inventario/presentation/providers/inventario_providers.dart';
import '../../domain/entities/orden_trabajo.dart';
import '../providers/crear_orden_providers.dart';
import '../providers/orden_trabajo_providers.dart';

class OrdenDetailScreen extends ConsumerStatefulWidget {
  final String idOrden;
  const OrdenDetailScreen({super.key, required this.idOrden});

  @override
  ConsumerState<OrdenDetailScreen> createState() => _OrdenDetailScreenState();
}

class _OrdenDetailScreenState extends ConsumerState<OrdenDetailScreen> {
  String? _mecanicoSeleccionado;
  String? _skuSeleccionado;
  final _cantidadController = TextEditingController(text: '1');
  final _horasController = TextEditingController(text: '0');
  final _montoPagoController = TextEditingController();
  final _rfcController = TextEditingController();
  MetodoPago _metodoPago = MetodoPago.efectivo;
  bool _procesando = false;

  void _refrescarTodo() {
    ref.invalidate(ordenPorIdProvider(widget.idOrden));
    ref.invalidate(historialOrdenProvider(widget.idOrden));
    ref.invalidate(refaccionesDisponiblesProvider);
    ref.invalidate(pagosPorOrdenProvider(widget.idOrden));
    ref.invalidate(evidenciasPorOrdenProvider(widget.idOrden));
  }

  Future<void> _asignarMecanico() async {
    if (_mecanicoSeleccionado == null) return;
    setState(() => _procesando = true);
    final resultado = await ref.read(asignarMecanicoUseCaseProvider)(
      idOrden: widget.idOrden,
      idMecanico: _mecanicoSeleccionado!,
    );
    if (!mounted) return;
    setState(() => _procesando = false);
    resultado.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mecánico asignado.')));
        _refrescarTodo();
      },
    );
  }

  Future<void> _solicitarRefaccion() async {
    if (_skuSeleccionado == null) return;
    final cantidad = int.tryParse(_cantidadController.text) ?? 0;
    setState(() => _procesando = true);
    final resultado = await ref.read(solicitarRefaccionUseCaseProvider)(
      idOrden: widget.idOrden,
      sku: _skuSeleccionado!,
      cantidad: cantidad,
    );
    if (!mounted) return;
    setState(() => _procesando = false);
    resultado.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Refacción reservada.')));
        _refrescarTodo();
      },
    );
  }

  Future<void> _actualizarHoras(OrdenTrabajo orden) async {
    final horas = double.tryParse(_horasController.text) ?? 0;
    setState(() => _procesando = true);
    final resultado = await ref.read(actualizarHorasUseCaseProvider)(orden: orden, horas: horas);
    if (!mounted) return;
    setState(() => _procesando = false);
    resultado.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Horas actualizadas.')));
        _refrescarTodo();
      },
    );
  }

  Future<void> _cambiarEstado(EstadoOrdenTrabajo nuevoEstado) async {
    setState(() => _procesando = true);
    final resultado = await ref.read(cambiarEstadoOrdenUseCaseProvider)(
      idOrden: widget.idOrden,
      nuevoEstado: nuevoEstado,
    );
    if (!mounted) return;
    setState(() => _procesando = false);
    resultado.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Estado: ${nuevoEstado.name}')));
        _refrescarTodo();
      },
    );
  }

  Future<void> _cancelarOrden() async {
    final motivoController = TextEditingController();
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar orden'),
        content: TextField(
          controller: motivoController,
          decoration: const InputDecoration(labelText: 'Motivo de cancelación'),
          maxLines: 2,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Volver')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cancelar OT'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;

    setState(() => _procesando = true);
    final resultado = await ref.read(cancelarOrdenUseCaseProvider)(
      idOrden: widget.idOrden,
      motivo: motivoController.text,
    );
    if (!mounted) return;
    setState(() => _procesando = false);
    resultado.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Orden cancelada.')));
        _refrescarTodo();
      },
    );
  }

  Future<void> _terminarOrden() async {
    setState(() => _procesando = true);
    final resultado = await ref.read(terminarOrdenUseCaseProvider)(widget.idOrden);
    if (!mounted) return;
    setState(() => _procesando = false);
    resultado.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Orden terminada. Saldo calculado.')));
        _refrescarTodo();
      },
    );
  }

  Future<void> _registrarPago(OrdenTrabajo orden) async {
    final monto = double.tryParse(_montoPagoController.text) ?? 0;
    setState(() => _procesando = true);
    final resultado = await ref.read(registrarPagoUseCaseProvider)(
      idOrden: widget.idOrden,
      monto: monto,
      metodoPago: _metodoPago,
    );
    if (!mounted) return;
    setState(() => _procesando = false);
    resultado.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pago registrado.')));
        _montoPagoController.clear();
        _refrescarTodo();
      },
    );
  }

  Future<void> _emitirFactura(OrdenTrabajo orden) async {
    setState(() => _procesando = true);
    final resultado = await ref.read(emitirFacturaUseCaseProvider)(
      orden: orden,
      rfcReceptor: _rfcController.text,
    );
    if (!mounted) return;
    setState(() => _procesando = false);
    resultado.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (fact) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Factura: ${fact.folioFiscal}')));
        _refrescarTodo();
      },
    );
  }

  Future<void> _entregarVehiculo() async {
    setState(() => _procesando = true);
    final resultado = await ref.read(entregarOrdenUseCaseProvider)(widget.idOrden);
    if (!mounted) return;
    setState(() => _procesando = false);
    resultado.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vehículo entregado.')));
        _refrescarTodo();
      },
    );
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _horasController.dispose();
    _montoPagoController.dispose();
    _rfcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordenAsync = ref.watch(ordenPorIdProvider(widget.idOrden));
    return AppScaffold(
      title: 'Orden ${widget.idOrden}',
      actions: [
        ordenAsync.maybeWhen(
          data: (orden) => orden.estado != EstadoOrdenTrabajo.cancelada &&
                  orden.estado != EstadoOrdenTrabajo.entregado
              ? IconButton(
                  icon: const Icon(Icons.cancel_outlined),
                  tooltip: 'Cancelar orden',
                  onPressed: _procesando ? null : _cancelarOrden,
                )
              : null,
          orElse: () => null,
        ) ?? const SizedBox.shrink(),
      ],
      body: ordenAsync.when(
        data: (orden) => _buildContenido(orden),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildEvidencias() {
    final evidenciasAsync = ref.watch(evidenciasPorOrdenProvider(widget.idOrden));
    return evidenciasAsync.when(
      data: (evidencias) {
        if (evidencias.isEmpty) {
          return const Text('Sin evidencias fotográficas.', style: TextStyle(color: Colors.grey));
        }
        return SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: evidencias.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final ev = evidencias[index];
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      ev.bytes,
                      width: 100,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 100,
                        height: 80,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                  Text(ev.etapa, style: const TextStyle(fontSize: 11)),
                ],
              );
            },
          ),
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text('Error evidencias: $e'),
    );
  }

  Widget _buildContenido(OrdenTrabajo orden) {
    final refaccionesAsync = ref.watch(refaccionesDisponiblesProvider);
    final pagosAsync = ref.watch(pagosPorOrdenProvider(widget.idOrden));
    final mecanicosAsync = ref.watch(mecanicosDisponiblesProvider);
    final historialAsync = ref.watch(historialOrdenProvider(widget.idOrden));

    final puedeEditar = !orden.esInmutable && orden.estado != EstadoOrdenTrabajo.cancelada;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Estado: ${_labelEstado(orden.estado)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('Falla: ${orden.fallaReportada}'),
                    Text('Saldo pendiente: \$${orden.saldoPendiente.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Evidencias', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            _buildEvidencias(),
            const SizedBox(height: 20),

            if (orden.idMecanico == null && puedeEditar) ...[
              const Text('Asignar mecánico', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              mecanicosAsync.when(
                data: (mecanicos) => DropdownButtonFormField<String>(
                  value: _mecanicoSeleccionado,
                  decoration: const InputDecoration(labelText: 'Mecánico'),
                  items: mecanicos
                      .map((m) => DropdownMenuItem(value: m['id'] as String, child: Text(m['nombre'] as String)))
                      .toList(),
                  onChanged: (v) => setState(() => _mecanicoSeleccionado = v),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: _procesando || _mecanicoSeleccionado == null ? null : _asignarMecanico,
                child: const Text('Asignar mecánico'),
              ),
              const SizedBox(height: 20),
            ] else if (orden.idMecanico != null) ...[
              Text('Mecánico: ${orden.idMecanico}', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
            ],

            if (puedeEditar && orden.estado == EstadoOrdenTrabajo.enProceso) ...[
              const Text('Estados intermedios', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton(
                    onPressed: _procesando ? null : () => _cambiarEstado(EstadoOrdenTrabajo.esperandoAprobacion),
                    child: const Text('Esperando aprobación'),
                  ),
                  OutlinedButton(
                    onPressed: _procesando ? null : () => _cambiarEstado(EstadoOrdenTrabajo.esperandoPiezas),
                    child: const Text('Esperando piezas'),
                  ),
                  OutlinedButton(
                    onPressed: _procesando ? null : () => _cambiarEstado(EstadoOrdenTrabajo.enProceso),
                    child: const Text('Retomar reparación'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            if (puedeEditar &&
                (orden.estado == EstadoOrdenTrabajo.enProceso ||
                    orden.estado == EstadoOrdenTrabajo.esperandoAprobacion ||
                    orden.estado == EstadoOrdenTrabajo.esperandoPiezas)) ...[
              const Text('Solicitar refacción', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              refaccionesAsync.when(
                data: (refacciones) => DropdownButtonFormField<String>(
                  value: _skuSeleccionado,
                  decoration: const InputDecoration(labelText: 'Refacción'),
                  items: refacciones
                      .map((r) => DropdownMenuItem(
                            value: r.sku,
                            child: Text('${r.nombre} (disp: ${r.stockDisponible})'),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _skuSeleccionado = v),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _cantidadController,
                decoration: const InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _procesando ? null : _solicitarRefaccion,
                child: const Text('Reservar refacción'),
              ),
              const SizedBox(height: 20),
              const Text('Mano de obra', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              TextField(
                controller: _horasController,
                decoration: const InputDecoration(labelText: 'Horas facturables'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _procesando ? null : () => _actualizarHoras(orden),
                child: const Text('Actualizar horas'),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _procesando || orden.idMecanico == null ? null : _terminarOrden,
                child: const Text('Terminar orden y calcular saldo'),
              ),
            ],

            if (orden.esInmutable && orden.saldoPendiente > 0) ...[
              const SizedBox(height: 20),
              const Text('Registrar pago', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              TextField(
                controller: _montoPagoController,
                decoration: const InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<MetodoPago>(
                value: _metodoPago,
                decoration: const InputDecoration(labelText: 'Método de pago'),
                items: MetodoPago.values.map((m) => DropdownMenuItem(value: m, child: Text(m.name))).toList(),
                onChanged: (v) => setState(() => _metodoPago = v ?? MetodoPago.efectivo),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: _procesando ? null : () => _registrarPago(orden),
                child: const Text('Registrar pago'),
              ),
            ],

            if ((orden.estado == EstadoOrdenTrabajo.terminado || orden.estado == EstadoOrdenTrabajo.pagado) &&
                orden.estado != EstadoOrdenTrabajo.entregado) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _procesando ? null : _entregarVehiculo,
                icon: const Icon(Icons.two_wheeler),
                label: const Text('Entregar vehículo'),
                style: FilledButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],

            if (orden.saldoPendiente <= 0 && orden.esInmutable && orden.estado != EstadoOrdenTrabajo.entregado) ...[
              const SizedBox(height: 20),
              TextField(
                controller: _rfcController,
                decoration: const InputDecoration(labelText: 'RFC del receptor'),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: _procesando ? null : () => _emitirFactura(orden),
                child: const Text('Emitir factura'),
              ),
            ],

            const SizedBox(height: 24),
            const Text('Pagos registrados', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            pagosAsync.when(
              data: (pagos) {
                if (pagos.isEmpty) return const Text('Sin pagos todavía.');
                return Column(
                  children: pagos.map((p) => ListTile(
                        dense: true,
                        title: Text('\$${p.monto.toStringAsFixed(2)} · ${p.metodoPago.name}'),
                        subtitle: Text(p.esReversion ? 'Reversión' : p.fechaPago.toString()),
                      )).toList(),
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
            ),

            const SizedBox(height: 24),
            const Text('Historial de estados', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            historialAsync.when(
              data: (historial) {
                if (historial.isEmpty) return const Text('Sin cambios registrados.', style: TextStyle(color: Colors.grey));
                return Column(
                  children: historial.map((h) => ListTile(
                        dense: true,
                        leading: const Icon(Icons.history, size: 18),
                        title: Text('${_labelEstado(h.estadoAnterior)} → ${_labelEstado(h.estadoNuevo)}'),
                        subtitle: Text(h.fechaCambio.toString()),
                      )).toList(),
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }

  String _labelEstado(EstadoOrdenTrabajo estado) {
    switch (estado) {
      case EstadoOrdenTrabajo.pendiente:
        return 'Pendiente';
      case EstadoOrdenTrabajo.enProceso:
        return 'En proceso';
      case EstadoOrdenTrabajo.esperandoAprobacion:
        return 'Esperando aprobación';
      case EstadoOrdenTrabajo.esperandoPiezas:
        return 'Esperando piezas';
      case EstadoOrdenTrabajo.terminado:
        return 'Terminado';
      case EstadoOrdenTrabajo.pagado:
        return 'Pagado';
      case EstadoOrdenTrabajo.entregado:
        return 'Entregado';
      case EstadoOrdenTrabajo.cancelada:
        return 'Cancelada';
    }
  }
}
