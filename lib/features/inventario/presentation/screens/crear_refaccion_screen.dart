import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/xp_window.dart';
import '../providers/inventario_providers.dart';

class CrearRefaccionScreen extends ConsumerStatefulWidget {
  const CrearRefaccionScreen({super.key});

  @override
  ConsumerState<CrearRefaccionScreen> createState() => _CrearRefaccionScreenState();
}

class _CrearRefaccionScreenState extends ConsumerState<CrearRefaccionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _skuController = TextEditingController();
  final _nombreController = TextEditingController();
  final _costoController = TextEditingController();
  final _ventaController = TextEditingController();
  final _minimoController = TextEditingController(text: '5');
  bool _guardando = false;

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    final result = await ref.read(inventarioRepositoryProvider).crearRefaccion(
      sku: _skuController.text.trim(),
      nombre: _nombreController.text.trim(),
      precioCosto: double.parse(_costoController.text),
      precioVenta: double.parse(_ventaController.text),
      stockMinimo: int.parse(_minimoController.text),
    );

    if (!mounted) return;
    setState(() => _guardando = false);

    result.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Producto creado exitosamente.')));
        ref.invalidate(refaccionesDisponiblesProvider);
        context.pop();
      },
    );
  }

  @override
  void dispose() {
    _skuController.dispose();
    _nombreController.dispose();
    _costoController.dispose();
    _ventaController.dispose();
    _minimoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Nuevo Producto / Refacción',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: XpWindow(
            title: 'Alta de refacción',
            maxWidth: 520,
            child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _skuController,
                  decoration: const InputDecoration(labelText: 'SKU (Código único)'),
                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre de la refacción'),
                  validator: (v) => v!.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _costoController,
                        decoration: const InputDecoration(labelText: 'Precio Costo'),
                        keyboardType: TextInputType.number,
                        validator: (v) => double.tryParse(v ?? '') == null ? 'Número inválido' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _ventaController,
                        decoration: const InputDecoration(labelText: 'Precio Venta'),
                        keyboardType: TextInputType.number,
                        validator: (v) => double.tryParse(v ?? '') == null ? 'Número inválido' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _minimoController,
                  decoration: const InputDecoration(labelText: 'Stock Mínimo (Alerta de reorden)'),
                  keyboardType: TextInputType.number,
                  validator: (v) => int.tryParse(v ?? '') == null ? 'Número inválido' : null,
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _guardando ? null : _guardar,
                  child: _guardando
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Crear Producto'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
