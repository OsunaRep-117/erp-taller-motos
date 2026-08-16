import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/xp_window.dart';
import '../../domain/entities/cita.dart';
import '../providers/citas_providers.dart';
import '../providers/crm_providers.dart';
import '../../../taller/presentation/providers/orden_trabajo_providers.dart';

class CitasListScreen extends ConsumerWidget {
  const CitasListScreen({super.key});

  Color _colorEstado(EstadoCita estado) {
    switch (estado) {
      case EstadoCita.confirmada:
        return Colors.green.shade700;
      case EstadoCita.cancelada:
        return Colors.red.shade700;
      case EstadoCita.completada:
        return Colors.grey.shade600;
      default:
        return XpColors.selection;
    }
  }

  Future<void> _confirmar(
    WidgetRef ref,
    BuildContext context,
    String id,
  ) async {
    final result = await ref.read(confirmarCitaUseCaseProvider)(id);
    if (!context.mounted) return;
    result.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ref.invalidate(citasAgendaProvider);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Cita confirmada.')));
      },
    );
  }

  Future<void> _cancelar(WidgetRef ref, BuildContext context, String id) async {
    final result = await ref.read(cancelarCitaUseCaseProvider)(id);
    if (!context.mounted) return;
    result.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ref.invalidate(citasAgendaProvider);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Cita cancelada.')));
      },
    );
  }

  Future<void> _registrarLlegada(
    WidgetRef ref,
    BuildContext context,
    Cita cita,
  ) async {
    final motos = await ref.read(motocicletasCrmProvider.future);
    final motosCliente = motos
        .where((m) => m.idCliente == cita.idCliente)
        .toList();
    if (motosCliente.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El cliente no tiene motocicletas registradas.'),
          ),
        );
      }
      return;
    }

    String? vin = cita.idMoto ?? motosCliente.first.vin;
    if (!context.mounted) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Registrar llegada'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: vin,
                decoration: const InputDecoration(labelText: 'Motocicleta'),
                items: motosCliente
                    .map(
                      (m) => DropdownMenuItem(
                        value: m.vin,
                        child: Text('${m.placa} · ${m.modelo}'),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setDialogState(() => vin = v),
              ),
              const SizedBox(height: 8),
              const Text(
                'Se creará una OT con el motivo de la cita. '
                'Adjunta evidencia en recepción si es necesario.',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Crear OT'),
            ),
          ],
        ),
      ),
    );

    if (confirmar != true || vin == null) return;

    final result = await ref.read(completarCitaUseCaseProvider)(
      idCita: cita.id,
      idMoto: vin!,
      motivo: cita.motivo,
      fotosEvidencia: const ['cita-llegada.jpg'],
    );

    if (!context.mounted) return;
    result.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (citaActualizada) {
        ref.invalidate(citasAgendaProvider);
        ref.invalidate(ordenesTrabajoStreamProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OT ${citaActualizada.idOrden} vinculada a la cita.'),
          ),
        );
        if (citaActualizada.idOrden != null) {
          context.go('/ordenes/${citaActualizada.idOrden}');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final citasAsync = ref.watch(citasAgendaProvider);
    final clientesAsync = ref.watch(clientesDisponiblesProvider);

    return AppScaffold(
      title: 'Agenda de Citas',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/citas/agendar'),
        icon: const Icon(Icons.event_available),
        label: const Text('Agendar cita'),
      ),
      body: citasAsync.when(
        data: (citas) {
          if (citas.isEmpty) {
            return const XpEmptyState('No hay citas agendadas.');
          }
          final clientes = clientesAsync.valueOrNull ?? [];
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: citas.length,
            itemBuilder: (context, index) {
              final cita = citas[index];
              final matches = clientes.where((c) => c.id == cita.idCliente);
              final nombreCliente = matches.isEmpty
                  ? cita.idCliente
                  : matches.first.nombreCompleto;

              return XpEntityCard(
                title: Row(
                  children: [
                    Expanded(child: Text(nombreCliente)),
                    XpStatusChip(
                      label: cita.estado.name,
                      color: _colorEstado(cita.estado),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cita.motivo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${cita.fechaCita.day}/${cita.fechaCita.month}/${cita.fechaCita.year} '
                      '${cita.fechaCita.hour.toString().padLeft(2, '0')}:'
                      '${cita.fechaCita.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    if (cita.idOrden != null)
                      Text(
                        'OT: ${cita.idOrden}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.teal,
                        ),
                      ),
                    if (cita.puedeConfirmar ||
                        cita.puedeCancelar ||
                        cita.puedeCompletar) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          if (cita.puedeConfirmar)
                            OutlinedButton(
                              onPressed: () =>
                                  _confirmar(ref, context, cita.id),
                              child: const Text('Confirmar'),
                            ),
                          if (cita.puedeCompletar)
                            FilledButton(
                              onPressed: () =>
                                  _registrarLlegada(ref, context, cita),
                              child: const Text('Registrar llegada'),
                            ),
                          if (cita.puedeCancelar)
                            TextButton(
                              onPressed: () => _cancelar(ref, context, cita.id),
                              child: const Text('Cancelar'),
                            ),
                        ],
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
