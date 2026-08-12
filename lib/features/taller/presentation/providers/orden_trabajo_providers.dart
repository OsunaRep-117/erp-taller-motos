import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/data/mock/mock_taller_datasource.dart';
import '../../../../core/data/mock_backend.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../../inventario/presentation/providers/inventario_providers.dart';
import '../../data/datasources/orden_trabajo_datasource.dart';
import '../../data/datasources/orden_trabajo_remote_datasource.dart';
import '../../data/repositories/orden_trabajo_repository_impl.dart';
import '../../domain/entities/estado_historial.dart';
import '../../domain/entities/orden_trabajo.dart';
import '../../domain/repositories/orden_trabajo_repository.dart';
import '../../domain/usecases/actualizar_horas_facturables.dart';
import '../../domain/usecases/asignar_mecanico.dart';
import '../../domain/usecases/cambiar_estado_orden.dart';
import '../../domain/usecases/cancelar_orden.dart';
import '../../domain/usecases/crear_orden_trabajo.dart';
import '../../domain/usecases/entregar_orden.dart';
import '../../domain/usecases/terminar_orden.dart';
import '../../../crm/presentation/providers/crm_providers.dart';

part 'orden_trabajo_providers.g.dart';

@riverpod
OrdenTrabajoDataSource ordenTrabajoDataSource(OrdenTrabajoDataSourceRef ref) {
  if (AppConfig.useMockBackend) {
    return MockOrdenTrabajoDatasource(MockBackend.store);
  }
  return OrdenTrabajoRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
OrdenTrabajoRepository ordenTrabajoRepository(OrdenTrabajoRepositoryRef ref) {
  return OrdenTrabajoRepositoryImpl(ref.watch(ordenTrabajoDataSourceProvider));
}

@riverpod
CrearOrdenTrabajo crearOrdenTrabajoUseCase(CrearOrdenTrabajoUseCaseRef ref) {
  return CrearOrdenTrabajo(ref.watch(ordenTrabajoRepositoryProvider));
}

@riverpod
AsignarMecanico asignarMecanicoUseCase(AsignarMecanicoUseCaseRef ref) {
  return AsignarMecanico(ref.watch(ordenTrabajoRepositoryProvider));
}

@riverpod
ActualizarHorasFacturables actualizarHorasUseCase(ActualizarHorasUseCaseRef ref) {
  return ActualizarHorasFacturables(ref.watch(ordenTrabajoRepositoryProvider));
}

@riverpod
EntregarOrden entregarOrdenUseCase(EntregarOrdenUseCaseRef ref) {
  return EntregarOrden(
    ref.watch(ordenTrabajoRepositoryProvider),
    ref.watch(crmRepositoryProvider),
  );
}

@riverpod
TerminarOrden terminarOrdenUseCase(TerminarOrdenUseCaseRef ref) {
  return TerminarOrden(
    ref.watch(ordenTrabajoRepositoryProvider),
    ref.watch(confirmarSalidaUseCaseProvider),
  );
}

@riverpod
CancelarOrden cancelarOrdenUseCase(CancelarOrdenUseCaseRef ref) {
  return CancelarOrden(ref.watch(ordenTrabajoRepositoryProvider));
}

@riverpod
CambiarEstadoOrden cambiarEstadoOrdenUseCase(CambiarEstadoOrdenUseCaseRef ref) {
  return CambiarEstadoOrden(ref.watch(ordenTrabajoRepositoryProvider));
}

@riverpod
Stream<List<OrdenTrabajo>> ordenesTrabajoStream(OrdenesTrabajoStreamRef ref) {
  return ref.watch(ordenTrabajoRepositoryProvider).observarOrdenes();
}

@riverpod
Future<OrdenTrabajo> ordenPorId(OrdenPorIdRef ref, String id) {
  return ref.watch(ordenTrabajoRepositoryProvider).obtenerOrdenPorId(id).then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}

@riverpod
Future<List<EstadoHistorial>> historialOrden(HistorialOrdenRef ref, String id) {
  return ref.watch(ordenTrabajoRepositoryProvider).obtenerHistorial(id).then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}

@riverpod
Future<List<Map<String, dynamic>>> mecanicosDisponibles(MecanicosDisponiblesRef ref) async {
  if (AppConfig.useMockBackend) {
    MockBackend.store.ensureSeeded();
    return MockBackend.store.empleados
        .where((e) => e.rol.name == 'mecanico' && e.activo)
        .map((e) => {'id': e.id, 'nombre': e.nombre})
        .toList();
  }
  final client = ref.watch(supabaseClientProvider);
  final data = await client.from('empleados').select('id, nombre').eq('rol', 'mecanico');
  return (data as List).cast<Map<String, dynamic>>();
}
