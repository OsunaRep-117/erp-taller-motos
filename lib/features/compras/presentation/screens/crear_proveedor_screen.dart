import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../providers/compras_providers.dart';

class CrearProveedorScreen extends ConsumerStatefulWidget {
  const CrearProveedorScreen({super.key});

  @override
  ConsumerState<CrearProveedorScreen> createState() =>
      _CrearProveedorScreenState();
}

class _CrearProveedorScreenState extends ConsumerState<CrearProveedorScreen> {
  final _nombreController = TextEditingController();
  final _contactoController = TextEditingController();
  final _rfcController = TextEditingController();
  bool _procesando = false;

  Future<void> _crear() async {
    setState(() => _procesando = true);
    final resultado = await ref
        .read(comprasRepositoryProvider)
        .crearProveedor(
          nombre: _nombreController.text.trim(),
          contacto: _contactoController.text.trim(),
          rfc: _rfcController.text.trim().isEmpty
              ? null
              : _rfcController.text.trim(),
        );
    if (!mounted) return;
    setState(() => _procesando = false);
    resultado.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ref.invalidate(proveedoresDisponiblesProvider);
        context.pop();
      },
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _contactoController.dispose();
    _rfcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Nuevo proveedor',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contactoController,
              decoration: const InputDecoration(
                labelText: 'Contacto (email o teléfono)',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _rfcController,
              decoration: const InputDecoration(labelText: 'RFC (opcional)'),
            ),
            const Spacer(),
            FilledButton(
              onPressed: _procesando ? null : _crear,
              child: _procesando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Crear proveedor'),
            ),
          ],
        ),
      ),
    );
  }
}
