import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/domain/entities/usuario.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../providers/rrhh_providers.dart';

class InvitarEmpleadoGoogleScreen extends ConsumerStatefulWidget {
  const InvitarEmpleadoGoogleScreen({super.key});

  @override
  ConsumerState<InvitarEmpleadoGoogleScreen> createState() =>
      _InvitarEmpleadoGoogleScreenState();
}

class _InvitarEmpleadoGoogleScreenState
    extends ConsumerState<InvitarEmpleadoGoogleScreen> {
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  RolEmpleado _rol = RolEmpleado.mecanico;
  bool _procesando = false;

  Future<void> _invitar() async {
    final admin = ref.read(authStateProvider).valueOrNull;
    if (admin == null) return;

    setState(() => _procesando = true);
    final resultado = await ref
        .read(rrhhRepositoryProvider)
        .invitarEmpleadoGoogle(
          nombre: _nombreController.text.trim(),
          email: _emailController.text.trim(),
          rol: _rol.name,
          invitadoPorId: admin.id,
        );

    if (!mounted) return;
    setState(() => _procesando = false);

    resultado.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ref.invalidate(invitacionesPendientesProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Invitación creada. La persona debe iniciar sesión con Google usando ese correo.',
            ),
          ),
        );
        context.pop();
      },
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Invitar con Google',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Registra el correo de Google del nuevo empleado. '
                  'Cuando inicie sesión con Google por primera vez, el ERP lo '
                  'reconocerá y le asignará el rol indicado.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre completo'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo de Google',
                hintText: 'nombre@gmail.com',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<RolEmpleado>(
              value: _rol,
              decoration: const InputDecoration(labelText: 'Rol en el ERP'),
              items: RolEmpleado.values
                  .map(
                    (r) =>
                        DropdownMenuItem(value: r, child: Text(_rolLabel(r))),
                  )
                  .toList(),
              onChanged: (v) =>
                  setState(() => _rol = v ?? RolEmpleado.mecanico),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _procesando ? null : _invitar,
              icon: _procesando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.mail_outline),
              label: const Text('Crear invitación Google'),
            ),
          ],
        ),
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
}
