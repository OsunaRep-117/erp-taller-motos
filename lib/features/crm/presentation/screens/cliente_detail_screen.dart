import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../domain/entities/cliente.dart';
import '../providers/crm_providers.dart';

class ClienteDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const ClienteDetailScreen({super.key, required this.id});

  @override
  ConsumerState<ClienteDetailScreen> createState() => _ClienteDetailScreenState();
}

class _ClienteDetailScreenState extends ConsumerState<ClienteDetailScreen> {
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _rfcController = TextEditingController();
  final _limiteController = TextEditingController();
  bool _esFlotilla = false;
  bool _editando = false;
  bool _procesando = false;

  void _cargar(Cliente c) {
    _nombreController.text = c.nombreCompleto;
    _telefonoController.text = c.telefono;
    _rfcController.text = c.rfc ?? '';
    _limiteController.text = c.limiteCredito.toString();
    _esFlotilla = c.esFlotilla;
  }

  Future<void> _guardar(Cliente original) async {
    setState(() => _procesando = true);
    final cliente = original.copyWith(
      nombreCompleto: _nombreController.text.trim(),
      telefono: _telefonoController.text.trim(),
      rfc: _rfcController.text.trim().isEmpty ? null : _rfcController.text.trim(),
      esFlotilla: _esFlotilla,
      limiteCredito: double.tryParse(_limiteController.text) ?? 0,
    );
    final resultado = await ref.read(actualizarClienteUseCaseProvider)(cliente);
    if (!mounted) return;
    setState(() {
      _procesando = false;
      _editando = false;
    });
    resultado.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ref.invalidate(clientesDisponiblesProvider);
        ref.invalidate(clientePorIdProvider(widget.id));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cliente actualizado.')));
      },
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _rfcController.dispose();
    _limiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clienteAsync = ref.watch(clientePorIdProvider(widget.id));

    return AppScaffold(
      title: 'Detalle cliente',
      actions: [
        clienteAsync.maybeWhen(
          data: (c) => IconButton(
            icon: Icon(_editando ? Icons.close : Icons.edit),
            onPressed: () => setState(() => _editando = !_editando),
          ),
          orElse: () => null,
        ) ?? const SizedBox.shrink(),
      ],
      body: clienteAsync.when(
        data: (cliente) {
          if (!_editando && _nombreController.text.isEmpty) _cargar(cliente);
          if (_editando) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(controller: _nombreController, decoration: const InputDecoration(labelText: 'Nombre')),
                  TextField(controller: _telefonoController, decoration: const InputDecoration(labelText: 'Teléfono')),
                  TextField(controller: _rfcController, decoration: const InputDecoration(labelText: 'RFC')),
                  TextField(
                    controller: _limiteController,
                    decoration: const InputDecoration(labelText: 'Límite crédito'),
                    keyboardType: TextInputType.number,
                  ),
                  SwitchListTile(
                    title: const Text('Es flotilla'),
                    value: _esFlotilla,
                    onChanged: (v) => setState(() => _esFlotilla = v),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _procesando ? null : () => _guardar(cliente),
                    child: _procesando
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Guardar'),
                  ),
                ],
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ListTile(title: const Text('Nombre'), subtitle: Text(cliente.nombreCompleto)),
              ListTile(title: const Text('Teléfono'), subtitle: Text(cliente.telefono)),
              ListTile(title: const Text('RFC'), subtitle: Text(cliente.rfc ?? '—')),
              ListTile(title: const Text('Flotilla'), subtitle: Text(cliente.esFlotilla ? 'Sí' : 'No')),
              ListTile(
                title: const Text('Límite crédito'),
                subtitle: Text('\$${cliente.limiteCredito.toStringAsFixed(2)}'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}
