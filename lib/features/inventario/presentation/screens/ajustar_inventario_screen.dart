import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../domain/entities/refaccion.dart';
import '../providers/inventario_providers.dart';

class AjustarInventarioScreen extends ConsumerStatefulWidget {
  const AjustarInventarioScreen({super.key});

  @override
  ConsumerState<AjustarInventarioScreen> createState() =>
      _AjustarInventarioScreenState();
}

class _AjustarInventarioScreenState
    extends ConsumerState<AjustarInventarioScreen> {
  String? _skuSeleccionado;
  final _cantidadController = TextEditingController();
  final _justificacionController = TextEditingController();
  bool _procesando = false;

  Future<void> _ajustar() async {
    final usuario = ref.read(authStateProvider).value;
    if (usuario == null || _skuSeleccionado == null) return;

    setState(() => _procesando = true);
    final cantidad = int.tryParse(_cantidadController.text) ?? 0;

    final resultado = await ref.read(ajustarInventarioUseCaseProvider)(
      usuarioActual: usuario,
      sku: _skuSeleccionado!,
      cantidadAjuste: cantidad,
      justificacion: _justificacionController.text,
    );

    if (!mounted) return;
    setState(() => _procesando = false);

    resultado.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.mensaje))),
      (_) {
        ref.invalidate(refaccionesDisponiblesProvider);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Ajuste registrado.')));
        Navigator.of(context).pop();
      },
    );
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _justificacionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final refaccionesAsync = ref.watch(refaccionesDisponiblesProvider);

    return AppScaffold(
      title: 'Ajuste manual de inventario',
      body: refaccionesAsync.when(
        data: (refacciones) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _skuSeleccionado,
                decoration: const InputDecoration(labelText: 'Refacción'),
                items: refacciones
                    .map(
                      (Refaccion r) => DropdownMenuItem(
                        value: r.sku,
                        child: Text('${r.sku} - ${r.nombre}'),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _skuSeleccionado = v),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _cantidadController,
                decoration: const InputDecoration(
                  labelText: 'Cantidad (+ entrante, - saliente)',
                  helperText: 'Usa números negativos para reducir stock',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _justificacionController,
                decoration: const InputDecoration(
                  labelText: 'Justificación (obligatoria)',
                ),
                maxLines: 3,
              ),
              const Spacer(),
              FilledButton(
                onPressed: _procesando ? null : _ajustar,
                child: _procesando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Registrar ajuste'),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}
