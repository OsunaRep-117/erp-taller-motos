import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/xp_window.dart';
import '../../../auth/domain/entities/usuario.dart';
import '../../domain/entities/empleado.dart';
import '../providers/rrhh_providers.dart';

class EmpleadosListScreen extends ConsumerWidget {
  const EmpleadosListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: AppScaffold(
        title: 'Gestión de Personal',
        bottom: const TabBar(
          tabs: [
            Tab(text: 'Empleados activos'),
            Tab(text: 'Invitaciones Google'),
          ],
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.extended(
              heroTag: 'invitar_google',
              onPressed: () => context.go('/empleados/invitar-google'),
              icon: const Icon(Icons.mail),
              label: const Text('Invitar Google'),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: 'crear_legacy',
              onPressed: () => context.go('/empleados/crear'),
              tooltip: 'Alta manual (demo)',
              child: const Icon(Icons.person_add),
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            _ListaEmpleadosTab(),
            _InvitacionesTab(),
          ],
        ),
      ),
    );
  }
}

class _ListaEmpleadosTab extends ConsumerWidget {
  const _ListaEmpleadosTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final empleadosAsync = ref.watch(listaEmpleadosProvider);

    return empleadosAsync.when(
      data: (empleados) {
        if (empleados.isEmpty) {
          return const XpEmptyState('No hay empleados registrados.');
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: empleados.length,
          itemBuilder: (context, index) => _EmpleadoTile(empleado: empleados[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }
}

class _InvitacionesTab extends ConsumerWidget {
  const _InvitacionesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invitacionesAsync = ref.watch(invitacionesPendientesProvider);

    return invitacionesAsync.when(
      data: (invitaciones) {
        if (invitaciones.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: XpWindow(
                title: 'Invitaciones pendientes',
                child: Text(
                  'No hay invitaciones Google pendientes.\n\n'
                  'Usa «Invitar Google» para pre-registrar un correo. '
                  'Esa persona iniciará sesión con Google y entrará automáticamente al ERP.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: invitaciones.length,
          itemBuilder: (context, index) {
            final inv = invitaciones[index];
            return XpEntityCard(
              leading: const Icon(Icons.mark_email_unread_outlined),
              title: Text(inv.nombre),
              subtitle: Text('${inv.email} · ${inv.rol.name}'),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Cancelar invitación',
                onPressed: () async {
                  await ref.read(rrhhRepositoryProvider).cancelarInvitacion(inv.id);
                  ref.invalidate(invitacionesPendientesProvider);
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
    );
  }
}

class _EmpleadoTile extends ConsumerWidget {
  final Empleado empleado;
  const _EmpleadoTile({required this.empleado});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return XpEntityCard(
      leading: CircleAvatar(
        backgroundColor: XpColors.selection,
        child: Text(empleado.nombre[0], style: const TextStyle(color: Colors.white)),
      ),
      title: Text(empleado.nombre),
      subtitle: Text('${_rolLabel(empleado.rol)} · ${empleado.email}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!empleado.activo) const XpStatusChip(label: 'Inactivo', color: Colors.grey),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _mostrarDialogoEdicion(context, ref, empleado),
          ),
          if (empleado.activo)
            IconButton(
              icon: const Icon(Icons.person_off_outlined),
              onPressed: () => _desactivar(context, ref, empleado),
            ),
        ],
      ),
    );
  }

  String _rolLabel(RolEmpleado rol) {
    switch (rol) {
      case RolEmpleado.admin:
        return 'Administrador';
      case RolEmpleado.recepcionista:
        return 'Recepcionista';
      case RolEmpleado.mecanico:
        return 'Mecánico';
      case RolEmpleado.supervisor:
        return 'Supervisor';
    }
  }

  void _mostrarDialogoEdicion(BuildContext context, WidgetRef ref, Empleado empleado) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar rol: ${empleado.nombre}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: RolEmpleado.values.map((rol) {
            return RadioListTile<RolEmpleado>(
              title: Text(_rolLabel(rol)),
              value: rol,
              groupValue: empleado.rol,
              onChanged: (nuevoRol) async {
                if (nuevoRol != null) {
                  await ref.read(rrhhRepositoryProvider).actualizarRolEmpleado(empleado.id, nuevoRol.name);
                  ref.invalidate(listaEmpleadosProvider);
                  if (context.mounted) Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _desactivar(BuildContext context, WidgetRef ref, Empleado empleado) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Desactivar empleado'),
        content: Text('¿Desactivar a ${empleado.nombre}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Desactivar')),
        ],
      ),
    );
    if (confirmar != true) return;

    final resultado = await ref.read(rrhhRepositoryProvider).desactivarEmpleado(empleado.id);
    resultado.fold(
      (f) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.mensaje)));
        }
      },
      (_) => ref.invalidate(listaEmpleadosProvider),
    );
  }
}
