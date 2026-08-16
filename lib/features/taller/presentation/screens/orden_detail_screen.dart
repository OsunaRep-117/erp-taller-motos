import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../finanzas/domain/entities/pago.dart';
import '../../../finanzas/presentation/providers/finanzas_providers.dart';
import '../../../inventario/presentation/providers/inventario_providers.dart';
import '../../domain/entities/extension_cotizacion.dart';
import '../../domain/entities/orden_trabajo.dart';
import '../widgets/sla_progress_card.dart';
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
  final _extDescripcionController = TextEditingController();
  final _extMontoController = TextEditingController();
  final _refaccionAdicionalNombreController = TextEditingController();
  final _refaccionAdicionalCantidadController = TextEditingController(
    text: '1',
  );
  final _refaccionAdicionalPrecioController = TextEditingController(text: '0');
  final List<Map<String, dynamic>> _refaccionesAdicionales = [];
  MetodoPago _metodoPago = MetodoPago.efectivo;
  bool _procesando = false;

  void _refrescarTodo() {
    ref.invalidate(ordenPorIdProvider(widget.idOrden));
    ref.invalidate(historialOrdenProvider(widget.idOrden));
    ref.invalidate(refaccionesDisponiblesProvider);
    ref.invalidate(pagosPorOrdenProvider(widget.idOrden));
    ref.invalidate(evidenciasPorOrdenProvider(widget.idOrden));
    ref.invalidate(extensionesPorOrdenProvider(widget.idOrden));
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
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Mecánico asignado.')));
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
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Refacción reservada.')));
        _refrescarTodo();
      },
    );
  }

  void _agregarRefaccionAdicional() {
    final nombre = _refaccionAdicionalNombreController.text.trim();
    final cantidad =
        int.tryParse(_refaccionAdicionalCantidadController.text) ?? 0;
    final precio =
        double.tryParse(_refaccionAdicionalPrecioController.text) ?? 0;

    if (nombre.isEmpty || cantidad <= 0 || precio <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Completa nombre, cantidad y precio de la refacción adicional.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _refaccionesAdicionales.add({
        'nombre': nombre,
        'cantidad': cantidad,
        'precio_unitario': precio,
        'subtotal': cantidad * precio,
      });
      _refaccionAdicionalNombreController.clear();
      _refaccionAdicionalCantidadController.text = '1';
      _refaccionAdicionalPrecioController.text = '0';
    });
  }

  double get _subtotalRefaccionesAdicionales =>
      _refaccionesAdicionales.fold<double>(
        0,
        (sum, item) => sum + ((item['subtotal'] as num?)?.toDouble() ?? 0),
      );

  Future<void> _actualizarHoras(OrdenTrabajo orden) async {
    final horas = double.tryParse(_horasController.text) ?? 0;
    setState(() => _procesando = true);
    final resultado = await ref.read(actualizarHorasUseCaseProvider)(
      orden: orden,
      horas: horas,
    );
    if (!mounted) return;
    setState(() => _procesando = false);
    resultado.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Horas actualizadas.')));
        _refrescarTodo();
      },
    );
  }

  Future<void> _iniciarTrabajo() async {
    setState(() => _procesando = true);
    final resultado = await ref.read(cambiarEstadoOrdenUseCaseProvider)(
      idOrden: widget.idOrden,
      nuevoEstado: EstadoOrdenTrabajo.enProceso,
    );
    if (!mounted) return;
    setState(() => _procesando = false);
    resultado.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Trabajo iniciado.')));
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
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Estado: ${nuevoEstado.name}')));
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
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Volver'),
          ),
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
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Orden cancelada.')));
        _refrescarTodo();
      },
    );
  }

  Future<void> _aprobarPresupuesto() async {
    setState(() => _procesando = true);
    final resultado = await ref.read(aprobarPresupuestoUseCaseProvider)(
      widget.idOrden,
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
            content: Text(
              'Presupuesto aprobado. Ya puedes reservar refacciones.',
            ),
          ),
        );
        _refrescarTodo();
      },
    );
  }

  Future<void> _solicitarExtension() async {
    final monto = double.tryParse(_extMontoController.text) ?? 0;
    setState(() => _procesando = true);
    final result = await ref.read(solicitarExtensionCotizacionUseCaseProvider)(
      idOrden: widget.idOrden,
      descripcion: _extDescripcionController.text.trim(),
      montoAdicional: monto,
    );
    if (!mounted) return;
    setState(() => _procesando = false);
    result.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        _extDescripcionController.clear();
        _extMontoController.clear();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Extensión solicitada.')));
        _refrescarTodo();
      },
    );
  }

  Future<void> _aprobarExtension(String idExtension) async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;
    setState(() => _procesando = true);
    final result = await ref.read(aprobarExtensionCotizacionUseCaseProvider)(
      idExtension: idExtension,
      usuarioActual: user,
    );
    if (!mounted) return;
    setState(() => _procesando = false);
    result.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Extensión aprobada.')));
        _refrescarTodo();
      },
    );
  }

  Future<void> _reabrirOrden() async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;
    setState(() => _procesando = true);
    final resultado = await ref.read(reabrirOrdenUseCaseProvider)(
      idOrden: widget.idOrden,
      usuarioActual: user,
    );
    if (!mounted) return;
    setState(() => _procesando = false);
    resultado.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Orden reabierta.')));
        _refrescarTodo();
      },
    );
  }

  Future<void> _terminarOrden() async {
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes iniciar sesión para terminar la orden.'),
        ),
      );
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Finalizar trabajo'),
        content: Text(
          'Se cerrará la orden con un saldo estimado de \$${(ref.read(ordenPorIdProvider(widget.idOrden)).valueOrNull?.totalTrabajo ?? 0).toStringAsFixed(2)}. '
          '¿Deseas continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirmar cierre'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    setState(() => _procesando = true);
    final resultado = await ref.read(terminarOrdenUseCaseProvider)(
      idOrden: widget.idOrden,
      idEmpleadoActual: user.id,
    );
    if (!mounted) return;
    setState(() => _procesando = false);
    resultado.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (ordenTerminada) {
        final mensaje = ordenTerminada.slaExcedido
            ? 'Orden terminada. Alerta SLA: duración superó el 150% estimado.'
            : 'Orden terminada. Saldo calculado.';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(mensaje)));
        _montoPagoController.text = ordenTerminada.saldoPendiente
            .toStringAsFixed(2);
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
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Pago registrado.')));
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
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (fact) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Factura: ${fact.folioFiscal}')));
        _refrescarTodo();
      },
    );
  }

  Future<void> _entregarVehiculo() async {
    setState(() => _procesando = true);
    final resultado = await ref.read(entregarOrdenUseCaseProvider)(
      widget.idOrden,
    );
    if (!mounted) return;
    setState(() => _procesando = false);
    resultado.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Vehículo entregado.')));
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
    _extDescripcionController.dispose();
    _extMontoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordenAsync = ref.watch(ordenPorIdProvider(widget.idOrden));
    return AppScaffold(
      title: 'Orden ${widget.idOrden}',
      actions: [
        ordenAsync.maybeWhen(
              data: (orden) =>
                  orden.estado != EstadoOrdenTrabajo.cancelada &&
                      orden.estado != EstadoOrdenTrabajo.entregado
                  ? IconButton(
                      icon: const Icon(Icons.cancel_outlined),
                      tooltip: 'Cancelar orden',
                      onPressed: _procesando ? null : _cancelarOrden,
                    )
                  : null,
              orElse: () => null,
            ) ??
            const SizedBox.shrink(),
      ],
      body: ordenAsync.when(
        data: (orden) => _buildContenido(orden),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildEvidencias() {
    final evidenciasAsync = ref.watch(
      evidenciasPorOrdenProvider(widget.idOrden),
    );
    return evidenciasAsync.when(
      data: (evidencias) {
        if (evidencias.isEmpty) {
          return const Text(
            'Sin evidencias fotográficas.',
            style: TextStyle(color: Colors.grey),
          );
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
                    child: Image.network(
                      ev.urlFirmada,
                      width: 100,
                      height: 80,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          width: 100,
                          height: 80,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      },
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

  Widget _buildRefaccionesReservadas() {
    final reservasAsync = ref.watch(
      refaccionesReservadasPorOrdenProvider(widget.idOrden),
    );
    return reservasAsync.when(
      data: (reservas) {
        if (reservas.isEmpty) {
          return const Text(
            'Sin refacciones reservadas todavía.',
            style: TextStyle(color: Colors.grey),
          );
        }
        return Column(
          children: reservas
              .map(
                (r) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('${r.nombreRefaccion} × ${r.cantidad}'),
                      ),
                      Text('\$${r.subtotal.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              )
              .toList(),
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text('Error refacciones: $e'),
    );
  }

  Widget _buildTotalEstimado(OrdenTrabajo orden) {
    final reservasAsync = ref.watch(
      refaccionesReservadasPorOrdenProvider(widget.idOrden),
    );
    final horas =
        double.tryParse(_horasController.text) ?? orden.horasFacturables;

    return reservasAsync.when(
      data: (reservas) {
        final totalRefacciones = reservas.fold<double>(
          0,
          (acc, r) => acc + r.subtotal,
        );
        final totalManoObra = horas * AppConfig.tarifaManoObraPorHora;
        final totalEstimado = totalRefacciones + totalManoObra;
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Refacciones: \$${totalRefacciones.toStringAsFixed(2)}'),
              Text(
                'Mano de obra ($horas h × \$${AppConfig.tarifaManoObraPorHora.toStringAsFixed(0)}): '
                '\$${totalManoObra.toStringAsFixed(2)}',
              ),
              const Divider(),
              Text(
                'Total estimado: \$${totalEstimado.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                'El saldo final se fija al terminar la orden.',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildContenido(OrdenTrabajo orden) {
    final refaccionesAsync = ref.watch(refaccionesDisponiblesProvider);
    final reservasAsync = ref.watch(reservasPorOrdenProvider(widget.idOrden));
    final consumosAsync = ref.watch(consumosPorOrdenProvider(widget.idOrden));
    final pagosAsync = ref.watch(pagosPorOrdenProvider(widget.idOrden));
    final mecanicosAsync = ref.watch(mecanicosDisponiblesProvider);
    final historialAsync = ref.watch(historialOrdenProvider(widget.idOrden));
    final userAsync = ref.watch(authStateProvider);

    final puedeEditar =
        !orden.esInmutable && orden.estado != EstadoOrdenTrabajo.cancelada;
    final esMecanicoAsignado = userAsync.valueOrNull?.id == orden.idMecanico;
    final esAdmin = userAsync.valueOrNull?.esAdmin ?? false;
    final esSupervisor = userAsync.valueOrNull?.rol == RolEmpleado.supervisor;
    final puedeAprobarExtension = esAdmin || esSupervisor;

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
                    Text(
                      'Estado: ${_labelEstado(orden.estado)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Falla: ${orden.fallaReportada}'),
                    Text(
                      'Saldo pendiente: \$${orden.saldoPendiente.toStringAsFixed(2)}',
                    ),
                    if (orden.bloqueosOperacion.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Bloqueos operativos',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ...orden.bloqueosOperacion.map(
                        (bloqueo) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.info_outline,
                                size: 16,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  bloqueo,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (orden.fechaInicioReparacion != null) ...[
              const SizedBox(height: 12),
              SlaProgressCard(orden: orden),
            ],
            const SizedBox(height: 16),
            const Text(
              'Evidencias',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildEvidencias(),
            const SizedBox(height: 20),

            if (orden.idMecanico == null && puedeEditar) ...[
              const Text(
                'Asignar mecánico',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              mecanicosAsync.when(
                data: (mecanicos) => DropdownButtonFormField<String>(
                  value: _mecanicoSeleccionado,
                  decoration: const InputDecoration(labelText: 'Mecánico'),
                  items: mecanicos
                      .map(
                        (m) => DropdownMenuItem(
                          value: m['id'] as String,
                          child: Text(m['nombre'] as String),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _mecanicoSeleccionado = v),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: _procesando || _mecanicoSeleccionado == null
                    ? null
                    : _asignarMecanico,
                child: const Text('Asignar mecánico'),
              ),
              const SizedBox(height: 20),
            ] else if (orden.idMecanico != null) ...[
              Text(
                'Mecánico: ${orden.idMecanico}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 12),
            ],

            if (orden.puedeComenzarTrabajo && esMecanicoAsignado) ...[
              Card(
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.play_circle_outline,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'La orden está lista para iniciar reparación.',
                        ),
                      ),
                      FilledButton(
                        onPressed: _procesando ? null : _iniciarTrabajo,
                        child: const Text('Comenzar trabajo'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            if (orden.puedeRegistrarTrabajo && esMecanicoAsignado) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resumen de trabajo',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Horas reportadas'),
                          Text(
                            '${orden.horasFacturables.toStringAsFixed(1)} h',
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Mano de obra'),
                          Text(
                            '\$${orden.manoDeObraCalculada.toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Refacciones estimadas'),
                          Text(
                            '\$${orden.subtotalRefacciones.toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total trabajo'),
                          Text(
                            '\$${orden.totalTrabajo.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Saldo actual'),
                          Text('\$${orden.saldoPendiente.toStringAsFixed(2)}'),
                        ],
                      ),
                      if (orden.requierePago) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Pago requerido antes de entrega del vehículo.',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              reservasAsync.when(
                data: (reservas) {
                  if (reservas.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Sin refacciones reservadas para esta OT.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  final subtotal = reservas.fold<double>(
                    0,
                    (sum, item) =>
                        sum + ((item['subtotal'] as num?)?.toDouble() ?? 0),
                  );
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Refacciones reservadas',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...reservas.map(
                            (item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${item['nombre']} x${item['cantidad']} ',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '\$${((item['subtotal'] as num?)?.toDouble() ?? 0).toStringAsFixed(2)}',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Subtotal refacciones'),
                              Text(
                                '\$${subtotal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error reservas: $e'),
              ),
              const SizedBox(height: 20),
              consumosAsync.when(
                data: (consumos) {
                  if (consumos.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Sin consumo real registrado todavía.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  final subtotal = consumos.fold<double>(
                    0,
                    (sum, item) =>
                        sum + ((item['subtotal'] as num?)?.toDouble() ?? 0),
                  );
                  return Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Consumo real de refacciones',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...consumos.map(
                            (item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${item['nombre']} x${item['cantidad']} ',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '\$${((item['subtotal'] as num?)?.toDouble() ?? 0).toStringAsFixed(2)}',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Subtotal consumido'),
                              Text(
                                '\$${subtotal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error consumos: $e'),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Refacciones adicionales usadas',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _refaccionAdicionalNombreController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de la pieza',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _refaccionAdicionalCantidadController,
                              decoration: const InputDecoration(
                                labelText: 'Cantidad',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _refaccionAdicionalPrecioController,
                              decoration: const InputDecoration(
                                labelText: 'Precio unitario',
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          onPressed: _agregarRefaccionAdicional,
                          icon: const Icon(Icons.add_circle_outline),
                          label: const Text('Agregar pieza adicional'),
                        ),
                      ),
                      if (_refaccionesAdicionales.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        ..._refaccionesAdicionales.map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item['nombre']} x${item['cantidad']}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '\$${((item['subtotal'] as num?)?.toDouble() ?? 0).toStringAsFixed(2)}',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal adicional'),
                            Text(
                              '\$${_subtotalRefaccionesAdicionales.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              reservasAsync.when(
                data: (reservas) {
                  final reservaSubtotal = reservas.fold<double>(
                    0,
                    (sum, item) =>
                        sum + ((item['subtotal'] as num?)?.toDouble() ?? 0),
                  );
                  final cierre = orden.resumenCierre(
                    costoRefaccionesReservadas: reservaSubtotal,
                    costoRefaccionesAdicionales:
                        _subtotalRefaccionesAdicionales,
                    horasRealesTrabajadas: orden.horasFacturables,
                  );

                  return Card(
                    color: Colors.teal.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Resumen de cierre',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Mano de obra'),
                              Text(
                                '\$${cierre['manoDeObra']!.toStringAsFixed(2)}',
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Refacciones reservadas'),
                              Text('\$${reservaSubtotal.toStringAsFixed(2)}'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Refacciones adicionales'),
                              Text(
                                '\$${_subtotalRefaccionesAdicionales.toStringAsFixed(2)}',
                              ),
                            ],
                          ),
                          const Divider(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total final'),
                              Text(
                                '\$${cierre['total']!.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Antes de entregar, confirma pago y cierre del servicio.',
                            style: TextStyle(
                              color: Colors.teal.shade800,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error cierre: $e'),
              ),
              const SizedBox(height: 20),
            ],

            if (puedeEditar &&
                orden.estado == EstadoOrdenTrabajo.enProceso) ...[
              const Text(
                'Estados intermedios',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton(
                    onPressed: _procesando
                        ? null
                        : () => _cambiarEstado(
                            EstadoOrdenTrabajo.esperandoAprobacion,
                          ),
                    child: const Text('Esperando aprobación'),
                  ),
                  OutlinedButton(
                    onPressed: _procesando
                        ? null
                        : () => _cambiarEstado(
                            EstadoOrdenTrabajo.esperandoPiezas,
                          ),
                    child: const Text('Esperando piezas'),
                  ),
                  OutlinedButton(
                    onPressed: _procesando
                        ? null
                        : () => _cambiarEstado(EstadoOrdenTrabajo.enProceso),
                    child: const Text('Retomar reparación'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            if (puedeEditar && !orden.presupuestoAprobado) ...[
              const Text(
                'Presupuesto',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: _procesando ? null : _aprobarPresupuesto,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Aprobar presupuesto'),
              ),
              const SizedBox(height: 20),
            ] else if (orden.presupuestoAprobado) ...[
              Text(
                'Presupuesto aprobado: ${orden.fechaAprobacionPresupuesto?.toLocal().toString().substring(0, 16) ?? ''}',
                style: const TextStyle(color: Colors.green),
              ),
              const SizedBox(height: 12),
              _buildExtensionesSection(puedeAprobarExtension),
            ],

            if (esAdmin && orden.estado == EstadoOrdenTrabajo.terminado) ...[
              OutlinedButton.icon(
                onPressed: _procesando ? null : _reabrirOrden,
                icon: const Icon(Icons.lock_open),
                label: const Text('Reabrir orden (admin)'),
              ),
              const SizedBox(height: 20),
            ],

            if (puedeEditar &&
                (orden.estado == EstadoOrdenTrabajo.enProceso ||
                    orden.estado == EstadoOrdenTrabajo.esperandoAprobacion ||
                    orden.estado == EstadoOrdenTrabajo.esperandoPiezas)) ...[
              const Text(
                'Refacciones reservadas',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              _buildRefaccionesReservadas(),
              const SizedBox(height: 16),
              const Text(
                'Solicitar refacción',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              refaccionesAsync.when(
                data: (refacciones) => DropdownButtonFormField<String>(
                  value: _skuSeleccionado,
                  decoration: const InputDecoration(labelText: 'Refacción'),
                  items: refacciones
                      .map(
                        (r) => DropdownMenuItem(
                          value: r.sku,
                          child: Text(
                            '${r.nombre} (disp: ${r.stockDisponible})',
                          ),
                        ),
                      )
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
              const Text(
                'Mano de obra',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _horasController,
                decoration: const InputDecoration(
                  labelText: 'Horas facturables',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _procesando ? null : () => _actualizarHoras(orden),
                child: const Text('Actualizar horas'),
              ),
              const SizedBox(height: 12),
              _buildTotalEstimado(orden),
              const SizedBox(height: 20),
              FilledButton(
                onPressed:
                    _procesando ||
                        orden.idMecanico == null ||
                        !esMecanicoAsignado
                    ? null
                    : _terminarOrden,
                child: Text(
                  esMecanicoAsignado
                      ? 'Finalizar trabajo y calcular saldo'
                      : 'Solo el mecánico asignado puede terminar',
                ),
              ),
            ],

            if (orden.esInmutable && orden.saldoPendiente > 0) ...[
              const SizedBox(height: 20),
              const Text(
                'Registrar pago',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
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
                items: MetodoPago.values
                    .map((m) => DropdownMenuItem(value: m, child: Text(m.name)))
                    .toList(),
                onChanged: (v) =>
                    setState(() => _metodoPago = v ?? MetodoPago.efectivo),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: _procesando ? null : () => _registrarPago(orden),
                child: const Text('Registrar pago'),
              ),
            ],

            if (orden.estado == EstadoOrdenTrabajo.pagado &&
                orden.saldoPendiente <= 0 &&
                orden.estado != EstadoOrdenTrabajo.entregado) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _procesando ? null : _entregarVehiculo,
                icon: const Icon(Icons.two_wheeler),
                label: const Text('Entregar vehículo'),
                style: FilledButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],

            if (orden.saldoPendiente <= 0 &&
                orden.esInmutable &&
                orden.estado != EstadoOrdenTrabajo.entregado) ...[
              const SizedBox(height: 20),
              TextField(
                controller: _rfcController,
                decoration: const InputDecoration(
                  labelText: 'RFC del receptor',
                ),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: _procesando ? null : () => _emitirFactura(orden),
                child: const Text('Emitir factura'),
              ),
            ],

            const SizedBox(height: 24),
            const Text(
              'Pagos registrados',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            pagosAsync.when(
              data: (pagos) {
                if (pagos.isEmpty) return const Text('Sin pagos todavía.');
                return Column(
                  children: pagos
                      .map(
                        (p) => ListTile(
                          dense: true,
                          title: Text(
                            '\$${p.monto.toStringAsFixed(2)} · ${p.metodoPago.name}',
                          ),
                          subtitle: Text(
                            p.esReversion
                                ? 'Reversión'
                                : p.fechaPago.toString(),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
            ),

            const SizedBox(height: 24),
            const Text(
              'Historial de estados',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            historialAsync.when(
              data: (historial) {
                if (historial.isEmpty)
                  return const Text(
                    'Sin cambios registrados.',
                    style: TextStyle(color: Colors.grey),
                  );
                return Column(
                  children: historial
                      .map(
                        (h) => ListTile(
                          dense: true,
                          leading: const Icon(Icons.history, size: 18),
                          title: Text(
                            '${_labelEstado(h.estadoAnterior)} → ${_labelEstado(h.estadoNuevo)}',
                          ),
                          subtitle: Text(h.fechaCambio.toString()),
                        ),
                      )
                      .toList(),
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

  Widget _buildExtensionesSection(bool puedeAprobar) {
    final extAsync = ref.watch(extensionesPorOrdenProvider(widget.idOrden));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Extensiones de cotización',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        extAsync.when(
          data: (exts) {
            if (exts.isEmpty) {
              return const Text(
                'Sin extensiones solicitadas.',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              );
            }
            return Column(
              children: exts
                  .map(
                    (e) => ListTile(
                      dense: true,
                      title: Text(e.descripcion),
                      subtitle: Text(
                        '\$${e.montoAdicional.toStringAsFixed(2)} · ${e.estado.name}',
                      ),
                      trailing:
                          e.estado == EstadoExtensionCotizacion.pendiente &&
                              puedeAprobar
                          ? TextButton(
                              onPressed: _procesando
                                  ? null
                                  : () => _aprobarExtension(e.id),
                              child: const Text('Aprobar'),
                            )
                          : null,
                    ),
                  )
                  .toList(),
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text('Error: $e'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _extDescripcionController,
          decoration: const InputDecoration(labelText: 'Descripción adicional'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _extMontoController,
          decoration: const InputDecoration(labelText: 'Monto adicional (\$)'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _procesando ? null : _solicitarExtension,
          icon: const Icon(Icons.add_circle_outline),
          label: const Text('Solicitar extensión'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  String _labelEstado(EstadoOrdenTrabajo? estado) {
    if (estado == null) return '—';
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
