import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/data/mock/mock_extension_cotizacion_datasource.dart';
import '../../../../core/data/mock/mock_taller_datasource.dart';
import '../../../../core/data/mock_backend.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../data/datasources/extension_cotizacion_datasource.dart';
import '../../data/datasources/extension_cotizacion_remote_datasource.dart';
import '../../data/datasources/orden_trabajo_datasource.dart';
import '../../data/datasources/orden_trabajo_remote_datasource.dart';
import '../../data/repositories/extension_cotizacion_repository_impl.dart';
import '../../data/repositories/orden_trabajo_repository_impl.dart';
import '../../domain/entities/estado_historial.dart';
import '../../domain/entities/extension_cotizacion.dart';
import '../../domain/entities/orden_trabajo.dart';
import '../../domain/entities/reserva_refaccion_ot.dart';
import '../../domain/repositories/extension_cotizacion_repository.dart';
import '../../domain/repositories/orden_trabajo_repository.dart';
import '../../domain/usecases/actualizar_horas_facturables.dart';
import '../../domain/usecases/aprobar_extension_cotizacion.dart';
import '../../domain/usecases/aprobar_presupuesto.dart';
import '../../domain/usecases/asignar_mecanico.dart';
import '../../domain/usecases/cambiar_estado_orden.dart';
import '../../domain/usecases/cancelar_orden.dart';
import '../../domain/usecases/crear_orden_trabajo.dart';
import '../../domain/usecases/entregar_orden.dart';
import '../../domain/usecases/reabrir_orden.dart';
import '../../domain/usecases/solicitar_extension_cotizacion.dart';
import '../../domain/usecases/terminar_orden.dart';
import '../../../crm/presentation/providers/crm_providers.dart';

part 'orden_trabajo_providers.g.dart';

@riverpod
OrdenTrabajoDataSource ordenTrabajoDataSource(Ref ref) {
  if (AppConfig.useMockBackend) {
    return MockOrdenTrabajoDatasource(MockBackend.store);
  }
  return OrdenTrabajoRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
OrdenTrabajoRepository ordenTrabajoRepository(Ref ref) {
  return OrdenTrabajoRepositoryImpl(ref.watch(ordenTrabajoDataSourceProvider));
}

@riverpod
ExtensionCotizacionDataSource extensionCotizacionDataSource(
  Ref ref,
) {
  if (AppConfig.useMockBackend) {
    return MockExtensionCotizacionDatasource(MockBackend.store);
  }
  return ExtensionCotizacionRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
ExtensionCotizacionRepository extensionCotizacionRepository(
  Ref ref,
) {
  return ExtensionCotizacionRepositoryImpl(
    ref.watch(extensionCotizacionDataSourceProvider),
  );
}

@riverpod
CrearOrdenTrabajo crearOrdenTrabajoUseCase(Ref ref) {
  return CrearOrdenTrabajo(
    ref.watch(ordenTrabajoRepositoryProvider),
    ref.watch(crmRepositoryProvider),
  );
}

@riverpod
AsignarMecanico asignarMecanicoUseCase(Ref ref) {
  return AsignarMecanico(ref.watch(ordenTrabajoRepositoryProvider));
}

@riverpod
ActualizarHorasFacturables actualizarHorasUseCase(
  Ref ref,
) {
  return ActualizarHorasFacturables(ref.watch(ordenTrabajoRepositoryProvider));
}

@riverpod
EntregarOrden entregarOrdenUseCase(Ref ref) {
  return EntregarOrden(
    ref.watch(ordenTrabajoRepositoryProvider),
    ref.watch(crmRepositoryProvider),
  );
}

@riverpod
TerminarOrden terminarOrdenUseCase(Ref ref) {
  return TerminarOrden(ref.watch(ordenTrabajoRepositoryProvider));
}

@riverpod
AprobarPresupuesto aprobarPresupuestoUseCase(Ref ref) {
  return AprobarPresupuesto(ref.watch(ordenTrabajoRepositoryProvider));
}

@riverpod
ReabrirOrden reabrirOrdenUseCase(Ref ref) {
  return ReabrirOrden(ref.watch(ordenTrabajoRepositoryProvider));
}

@riverpod
SolicitarExtensionCotizacion solicitarExtensionCotizacionUseCase(
  Ref ref,
) {
  return SolicitarExtensionCotizacion(
    ref.watch(extensionCotizacionRepositoryProvider),
  );
}

@riverpod
AprobarExtensionCotizacion aprobarExtensionCotizacionUseCase(
  Ref ref,
) {
  return AprobarExtensionCotizacion(
    ref.watch(extensionCotizacionRepositoryProvider),
  );
}

@riverpod
CancelarOrden cancelarOrdenUseCase(Ref ref) {
  return CancelarOrden(ref.watch(ordenTrabajoRepositoryProvider));
}

@riverpod
CambiarEstadoOrden cambiarEstadoOrdenUseCase(Ref ref) {
  return CambiarEstadoOrden(ref.watch(ordenTrabajoRepositoryProvider));
}

@riverpod
Stream<List<OrdenTrabajo>> ordenesTrabajoStream(Ref ref) {
  return ref.watch(ordenTrabajoRepositoryProvider).observarOrdenes();
}

@riverpod
Stream<List<OrdenTrabajo>> ordenesDelMecanico(
  Ref ref,
  String idMecanico,
) {
  return ref
      .watch(ordenTrabajoRepositoryProvider)
      .observarOrdenes()
      .map(
        (ordenes) => ordenes
            .where((orden) => orden.perteneceAMecanico(idMecanico))
            .toList(),
      );
}

@riverpod
Future<OrdenTrabajo> ordenPorId(Ref ref, String id) {
  return ref
      .watch(ordenTrabajoRepositoryProvider)
      .obtenerOrdenPorId(id)
      .then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}

@riverpod
Future<List<EstadoHistorial>> historialOrden(Ref ref, String id) {
  return ref
      .watch(ordenTrabajoRepositoryProvider)
      .obtenerHistorial(id)
      .then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}

@riverpod
Future<List<ReservaRefaccionOt>> refaccionesReservadasPorOrden(
  Ref ref,
  String idOrden,
) {
  return ref
      .watch(ordenTrabajoRepositoryProvider)
      .obtenerRefaccionesReservadas(idOrden)
      .then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}

@riverpod
Future<List<ExtensionCotizacion>> extensionesPorOrden(
  Ref ref,
  String idOrden,
) {
  return ref
      .watch(extensionCotizacionRepositoryProvider)
      .listarPorOrden(idOrden)
      .then(
        (result) => result.fold((f) => throw Exception(f.mensaje), (r) => r),
      );
}

@riverpod
Future<List<Map<String, dynamic>>> mecanicosDisponibles(
  Ref ref,
) async {
  if (AppConfig.useMockBackend) {
    MockBackend.store.ensureSeeded();
    return MockBackend.store.empleados
        .where((e) => e.rol.name == 'mecanico' && e.activo)
        .map((e) => {'id': e.id, 'nombre': e.nombre})
        .toList();
  }
  final client = ref.watch(supabaseClientProvider);
  final data = await client
      .from('empleados')
      .select('id, nombre')
      .eq('rol', 'mecanico');
  return (data as List).cast<Map<String, dynamic>>();
}
