import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/xp_window.dart';
import '../providers/crm_providers.dart';

class CrearClienteScreen extends ConsumerStatefulWidget {
  const CrearClienteScreen({super.key});

  @override
  ConsumerState<CrearClienteScreen> createState() => _CrearClienteScreenState();
}

class _CrearClienteScreenState extends ConsumerState<CrearClienteScreen> {
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _rfcController = TextEditingController();
  bool _esFlotilla = false;
  bool _guardando = false;
  String? _error;

  Future<void> _guardar() async {
    setState(() {
      _guardando = true;
      _error = null;
    });

    final useCase = ref.read(crearClienteUseCaseProvider);
    final resultado = await useCase(
      nombreCompleto: _nombreController.text,
      telefono: _telefonoController.text,
      rfc: _rfcController.text.isEmpty ? null : _rfcController.text,
      esFlotilla: _esFlotilla,
    );

    if (!mounted) return;

    resultado.fold(
      (failure) => setState(() {
        _error = failure.mensaje;
        _guardando = false;
      }),
      (cliente) {
        ref.invalidate(clientesDisponiblesProvider);
        if (context.mounted) context.go('/clientes');
      },
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _rfcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Nuevo Cliente',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: XpWindow(
            title: 'Registro de cliente',
            maxWidth: 480,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre completo'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Cliente de flotilla (B2B)'),
                value: _esFlotilla,
                onChanged: (v) => setState(() => _esFlotilla = v),
                contentPadding: EdgeInsets.zero,
              ),
              if (_esFlotilla) ...[
                const SizedBox(height: 4),
                TextField(
                  controller: _rfcController,
                  decoration: const InputDecoration(
                    labelText: 'RFC (obligatorio para flotilla)',
                  ),
                ),
              ],
              const SizedBox(height: 20),
              if (_error != null) ...[
                Text(_error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
              ],
              FilledButton(
                onPressed: _guardando ? null : _guardar,
                child: _guardando
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Guardar cliente'),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
