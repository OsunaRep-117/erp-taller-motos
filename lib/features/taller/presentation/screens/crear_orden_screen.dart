import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/xp_window.dart';
import '../../../crm/presentation/providers/crm_providers.dart';
import '../providers/crear_orden_providers.dart';
import '../providers/orden_trabajo_providers.dart';

class _FotoPendiente {
  final String nombre;
  final Uint8List bytes;
  const _FotoPendiente(this.nombre, this.bytes);
}

class CrearOrdenScreen extends ConsumerStatefulWidget {
  const CrearOrdenScreen({super.key});

  @override
  ConsumerState<CrearOrdenScreen> createState() => _CrearOrdenScreenState();
}

class _CrearOrdenScreenState extends ConsumerState<CrearOrdenScreen> {
  final _fallaController = TextEditingController();
  String? _vinSeleccionado;
  final List<_FotoPendiente> _fotos = [];
  bool _guardando = false;

  Future<void> _agregarFotos() async {
    final picker = ImagePicker();
    final archivos = await picker.pickMultiImage(imageQuality: 80);
    if (archivos.isEmpty) return;
    for (final archivo in archivos) {
      final bytes = await archivo.readAsBytes();
      setState(() => _fotos.add(_FotoPendiente(archivo.name, bytes)));
    }
  }

  void _quitarFoto(int index) => setState(() => _fotos.removeAt(index));

  Future<void> _guardar() async {
    if (_vinSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona la motocicleta.')));
      return;
    }
    if (_fallaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Describe la falla reportada.')));
      return;
    }
    if (_fotos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adjunta al menos una fotografía del estado de la motocicleta.')),
      );
      return;
    }

    setState(() => _guardando = true);

    final crearOrden = ref.read(crearOrdenTrabajoUseCaseProvider);
    final resultadoOrden = await crearOrden(
      idMoto: _vinSeleccionado!,
      fallaReportada: _fallaController.text.trim(),
      fotosEvidencia: _fotos.map((f) => f.nombre).toList(),
    );

    final ordenCreada = resultadoOrden.fold(
      (failure) {
        setState(() => _guardando = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.mensaje)));
        return null;
      },
      (orden) => orden,
    );

    if (ordenCreada == null) return;

    final subirEvidencia = ref.read(subirEvidenciaOtUseCaseProvider);
    bool huboErrorFoto = false;
    for (final foto in _fotos) {
      final resultadoFoto = await subirEvidencia(
        idOrden: ordenCreada.id,
        bytes: foto.bytes,
        nombreArchivo: foto.nombre,
        etapa: 'recepcion',
      );
      if (resultadoFoto.isLeft()) {
        huboErrorFoto = true;
      }
    }

    if (!mounted) return;
    setState(() => _guardando = false);

    if (huboErrorFoto) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La orden se creó, pero falló la subida de algunas fotos.')),
      );
    }

    if (context.mounted) {
      context.go('/ordenes');
    }
  }

  @override
  void dispose() {
    _fallaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final motosAsync = ref.watch(motocicletasCrmProvider);

    return AppScaffold(
      title: 'Nueva Orden de Trabajo',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: XpWindow(
            title: 'Recepción de motocicleta',
            maxWidth: 560,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              motosAsync.when(
                data: (motos) {
                  if (motos.isEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('No hay motocicletas registradas todavía.'),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () => context.go('/motocicletas/crear'),
                          child: const Text('Registrar una motocicleta'),
                        ),
                      ],
                    );
                  }
                  return DropdownButtonFormField<String>(
                    value: _vinSeleccionado,
                    decoration: const InputDecoration(labelText: 'Motocicleta'),
                    items: motos.map((m) {
                      final label = '${m.placa} · ${m.marca} ${m.modelo}';
                      return DropdownMenuItem(value: m.vin, child: Text(label));
                    }).toList(),
                    onChanged: (value) => setState(() => _vinSeleccionado = value),
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error al cargar motocicletas: $e'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _fallaController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Falla reportada por el cliente',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Evidencia fotográfica', style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _agregarFotos,
                    icon: const Icon(Icons.add_a_photo_outlined),
                    label: const Text('Agregar fotos'),
                  ),
                ],
              ),
              if (_fotos.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(_fotos.length, (index) {
                    final foto = _fotos[index];
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(foto.bytes, width: 90, height: 90, fit: BoxFit.cover),
                        ),
                        Positioned(
                          top: -8,
                          right: -8,
                          child: IconButton(
                            icon: const Icon(Icons.cancel, size: 20),
                            onPressed: () => _quitarFoto(index),
                          ),
                        ),
                      ],
                    );
                  }),
                )
              else
                const Text(
                  'Sin fotos adjuntas. Se requiere al menos una para crear la orden.',
                  style: TextStyle(color: Colors.grey),
                ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _guardando ? null : _guardar,
                child: _guardando
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Crear orden'),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
