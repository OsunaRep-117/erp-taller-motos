import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../providers/crm_providers.dart';

class MotocicletaDetailScreen extends ConsumerStatefulWidget {
  final String vin;
  const MotocicletaDetailScreen({super.key, required this.vin});

  @override
  ConsumerState<MotocicletaDetailScreen> createState() => _MotocicletaDetailScreenState();
}

class _MotocicletaDetailScreenState extends ConsumerState<MotocicletaDetailScreen> {
  final _placaController = TextEditingController();
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _anioController = TextEditingController();
  String? _idCliente;
  bool _editando = false;
  bool _procesando = false;

  Future<void> _guardar() async {
    setState(() => _procesando = true);
    final resultado = await ref.read(actualizarMotocicletaUseCaseProvider)(
      vin: widget.vin,
      placa: _placaController.text,
      marca: _marcaController.text,
      modelo: _modeloController.text,
      anio: int.tryParse(_anioController.text) ?? 0,
      idCliente: _idCliente ?? '',
    );
    if (!mounted) return;
    setState(() {
      _procesando = false;
      _editando = false;
    });
    resultado.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ref.invalidate(motocicletasCrmProvider);
        ref.invalidate(motocicletaPorVinProvider(widget.vin));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Motocicleta actualizada.')));
      },
    );
  }

  @override
  void dispose() {
    _placaController.dispose();
    _marcaController.dispose();
    _modeloController.dispose();
    _anioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final motoAsync = ref.watch(motocicletaPorVinProvider(widget.vin));
    final clientesAsync = ref.watch(clientesDisponiblesProvider);

    return AppScaffold(
      title: 'Detalle motocicleta',
      actions: [
        IconButton(
          icon: Icon(_editando ? Icons.close : Icons.edit),
          onPressed: () => setState(() => _editando = !_editando),
        ),
      ],
      body: motoAsync.when(
        data: (moto) {
          if (_placaController.text.isEmpty) {
            _placaController.text = moto.placa;
            _marcaController.text = moto.marca;
            _modeloController.text = moto.modelo;
            _anioController.text = moto.anio.toString();
            _idCliente = moto.idCliente;
          }
          if (_editando) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('VIN: ${moto.vin}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextField(controller: _placaController, decoration: const InputDecoration(labelText: 'Placa')),
                  TextField(controller: _marcaController, decoration: const InputDecoration(labelText: 'Marca')),
                  TextField(controller: _modeloController, decoration: const InputDecoration(labelText: 'Modelo')),
                  TextField(
                    controller: _anioController,
                    decoration: const InputDecoration(labelText: 'Año'),
                    keyboardType: TextInputType.number,
                  ),
                  clientesAsync.when(
                    data: (clientes) => DropdownButtonFormField<String>(
                      value: _idCliente,
                      decoration: const InputDecoration(labelText: 'Cliente'),
                      items: clientes
                          .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nombreCompleto)))
                          .toList(),
                      onChanged: (v) => setState(() => _idCliente = v),
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text('$e'),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _procesando ? null : _guardar,
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
              ListTile(title: const Text('VIN'), subtitle: Text(moto.vin)),
              ListTile(title: const Text('Placa'), subtitle: Text(moto.placa)),
              ListTile(title: const Text('Marca / Modelo'), subtitle: Text('${moto.marca} ${moto.modelo}')),
              ListTile(title: const Text('Año'), subtitle: Text('${moto.anio}')),
              ListTile(title: const Text('Cliente ID'), subtitle: Text(moto.idCliente)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}
