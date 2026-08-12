import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/domain/entities/usuario.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../providers/rrhh_providers.dart';

class CrearEmpleadoScreen extends ConsumerStatefulWidget {
  const CrearEmpleadoScreen({super.key});

  @override
  ConsumerState<CrearEmpleadoScreen> createState() => _CrearEmpleadoScreenState();
}

class _CrearEmpleadoScreenState extends ConsumerState<CrearEmpleadoScreen> {
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  RolEmpleado _rol = RolEmpleado.mecanico;
  bool _procesando = false;

  Future<void> _crear() async {
    setState(() => _procesando = true);
    final resultado = await ref.read(rrhhRepositoryProvider).crearEmpleado(
          nombre: _nombreController.text.trim(),
          email: _emailController.text.trim(),
          rol: _rol.name,
        );

    if (!mounted) return;
    setState(() => _procesando = false);

    resultado.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ref.invalidate(listaEmpleadosProvider);
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
      title: 'Nuevo empleado',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre completo'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<RolEmpleado>(
              value: _rol,
              decoration: const InputDecoration(labelText: 'Rol'),
              items: RolEmpleado.values
                  .map((r) => DropdownMenuItem(value: r, child: Text(r.name)))
                  .toList(),
              onChanged: (v) => setState(() => _rol = v ?? RolEmpleado.mecanico),
            ),
            const Spacer(),
            FilledButton(
              onPressed: _procesando ? null : _crear,
              child: _procesando
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Crear empleado'),
            ),
          ],
        ),
      ),
    );
  }
}
