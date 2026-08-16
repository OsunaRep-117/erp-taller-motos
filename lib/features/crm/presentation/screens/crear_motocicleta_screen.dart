import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/xp_window.dart';
import '../providers/crm_providers.dart';

class CrearMotocicletaScreen extends ConsumerStatefulWidget {
  const CrearMotocicletaScreen({super.key});

  @override
  ConsumerState<CrearMotocicletaScreen> createState() =>
      _CrearMotocicletaScreenState();
}

class _CrearMotocicletaScreenState
    extends ConsumerState<CrearMotocicletaScreen> {
  final _vinController = TextEditingController();
  final _placaController = TextEditingController();
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _anioController = TextEditingController(
    text: DateTime.now().year.toString(),
  );
  String? _idClienteSeleccionado;
  bool _guardando = false;
  String? _error;

  Future<void> _guardar() async {
    if (_idClienteSeleccionado == null) {
      setState(() => _error = 'Selecciona el propietario.');
      return;
    }

    setState(() {
      _guardando = true;
      _error = null;
    });

    final useCase = ref.read(crearMotocicletaUseCaseProvider);
    final resultado = await useCase(
      vin: _vinController.text,
      placa: _placaController.text,
      marca: _marcaController.text,
      modelo: _modeloController.text,
      anio: int.tryParse(_anioController.text) ?? 0,
      idCliente: _idClienteSeleccionado!,
    );

    if (!mounted) return;

    resultado.fold(
      (failure) => setState(() {
        _error = failure.mensaje;
        _guardando = false;
      }),
      (moto) {
        ref.invalidate(motocicletasCrmProvider);
        if (context.mounted) context.go('/motocicletas');
      },
    );
  }

  @override
  void dispose() {
    _vinController.dispose();
    _placaController.dispose();
    _marcaController.dispose();
    _modeloController.dispose();
    _anioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clientesAsync = ref.watch(clientesDisponiblesProvider);

    return AppScaffold(
      title: 'Nueva Motocicleta',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: XpWindow(
            title: 'Registro de motocicleta',
            maxWidth: 480,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                clientesAsync.when(
                  data: (clientes) {
                    if (clientes.isEmpty) {
                      return const Text(
                        'No hay clientes registrados. Crea uno primero.',
                      );
                    }
                    return DropdownButtonFormField<String>(
                      value: _idClienteSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Propietario',
                      ),
                      items: clientes
                          .map(
                            (c) => DropdownMenuItem(
                              value: c.id,
                              child: Text(c.nombreCompleto),
                            ),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _idClienteSeleccionado = v),
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('Error: $e'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _vinController,
                  decoration: const InputDecoration(
                    labelText: 'VIN (17 caracteres)',
                  ),
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 17,
                ),
                TextField(
                  controller: _placaController,
                  decoration: const InputDecoration(labelText: 'Placa'),
                  textCapitalization: TextCapitalization.characters,
                ),
                TextField(
                  controller: _marcaController,
                  decoration: const InputDecoration(labelText: 'Marca'),
                ),
                TextField(
                  controller: _modeloController,
                  decoration: const InputDecoration(labelText: 'Modelo'),
                ),
                TextField(
                  controller: _anioController,
                  decoration: const InputDecoration(labelText: 'Año'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                if (_error != null) ...[
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),
                ],
                FilledButton(
                  onPressed: _guardando ? null : _guardar,
                  child: _guardando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Guardar motocicleta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
