import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../domain/entities/motocicleta.dart';
import '../providers/citas_providers.dart';
import '../providers/crm_providers.dart';

class AgendarCitaScreen extends ConsumerStatefulWidget {
  const AgendarCitaScreen({super.key});

  @override
  ConsumerState<AgendarCitaScreen> createState() => _AgendarCitaScreenState();
}

class _AgendarCitaScreenState extends ConsumerState<AgendarCitaScreen> {
  final _motivoController = TextEditingController();
  String? _clienteId;
  String? _motoVin;
  DateTime _fecha = DateTime.now().add(const Duration(hours: 1));
  TimeOfDay _hora = TimeOfDay.fromDateTime(
    DateTime.now().add(const Duration(hours: 1)),
  );
  bool _guardando = false;

  Future<void> _elegirFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) setState(() => _fecha = picked);
  }

  Future<void> _elegirHora() async {
    final picked = await showTimePicker(context: context, initialTime: _hora);
    if (picked != null) setState(() => _hora = picked);
  }

  DateTime get _fechaCita =>
      DateTime(_fecha.year, _fecha.month, _fecha.day, _hora.hour, _hora.minute);

  Future<void> _guardar() async {
    if (_clienteId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecciona un cliente.')));
      return;
    }
    if (_motivoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Indica el motivo de la cita.')),
      );
      return;
    }

    setState(() => _guardando = true);
    final result = await ref.read(agendarCitaUseCaseProvider)(
      idCliente: _clienteId!,
      fechaCita: _fechaCita,
      motivo: _motivoController.text.trim(),
      idMoto: _motoVin,
    );
    if (!mounted) return;
    setState(() => _guardando = false);

    result.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ref.invalidate(citasAgendaProvider);
        context.go('/citas');
      },
    );
  }

  @override
  void dispose() {
    _motivoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clientesAsync = ref.watch(clientesDisponiblesProvider);
    final motosAsync = ref.watch(motocicletasCrmProvider);

    final motosCliente = motosAsync.maybeWhen(
      data: (motos) => _clienteId == null
          ? <Motocicleta>[]
          : motos.where((m) => m.idCliente == _clienteId).toList(),
      orElse: () => <Motocicleta>[],
    );

    return AppScaffold(
      title: 'Agendar cita',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              clientesAsync.when(
                data: (clientes) => DropdownButtonFormField<String>(
                  value: _clienteId,
                  decoration: const InputDecoration(labelText: 'Cliente'),
                  items: clientes
                      .map(
                        (c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(c.nombreCompleto),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() {
                    _clienteId = v;
                    _motoVin = null;
                  }),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
              ),
              const SizedBox(height: 16),
              if (_clienteId != null && motosCliente.isNotEmpty)
                DropdownButtonFormField<String>(
                  value: _motoVin,
                  decoration: const InputDecoration(
                    labelText: 'Motocicleta (opcional)',
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Sin especificar'),
                    ),
                    ...motosCliente.map(
                      (m) => DropdownMenuItem(
                        value: m.vin,
                        child: Text('${m.placa} · ${m.modelo}'),
                      ),
                    ),
                  ],
                  onChanged: (v) => setState(() => _motoVin = v),
                ),
              const SizedBox(height: 16),
              TextField(
                controller: _motivoController,
                decoration: const InputDecoration(
                  labelText: 'Motivo / servicio solicitado',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _elegirFecha,
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: Text(
                        '${_fecha.day}/${_fecha.month}/${_fecha.year}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _elegirHora,
                      icon: const Icon(Icons.access_time, size: 18),
                      label: Text(_hora.format(context)),
                    ),
                  ),
                ],
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
                    : const Text('Agendar cita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
