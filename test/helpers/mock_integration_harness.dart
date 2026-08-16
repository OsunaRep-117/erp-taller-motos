import 'package:erp_flutter/core/data/mock/mock_auth_datasource.dart';
import 'package:erp_flutter/core/data/mock/mock_compras_datasource.dart';
import 'package:erp_flutter/core/data/mock/mock_crm_datasource.dart';
import 'package:erp_flutter/core/data/mock/mock_data_store.dart';
import 'package:erp_flutter/core/data/mock/mock_finanzas_datasource.dart';
import 'package:erp_flutter/core/data/mock/mock_inventario_datasource.dart';
import 'package:erp_flutter/core/data/mock/mock_pos_datasource.dart';
import 'package:erp_flutter/core/data/mock/mock_taller_datasource.dart';
import 'package:erp_flutter/features/auth/data/repositories/mock_auth_repository_impl.dart';
import 'package:erp_flutter/features/auth/domain/entities/usuario.dart';
import 'package:erp_flutter/features/auth/domain/usecases/iniciar_sesion.dart';
import 'package:erp_flutter/features/compras/data/repositories/compras_repository_impl.dart';
import 'package:erp_flutter/features/crm/data/repositories/crm_repository_impl.dart';
import 'package:erp_flutter/features/finanzas/data/repositories/finanzas_repository_impl.dart';
import 'package:erp_flutter/features/finanzas/domain/entities/pago.dart';
import 'package:erp_flutter/features/finanzas/domain/usecases/registrar_pago.dart';
import 'package:erp_flutter/features/inventario/data/repositories/inventario_repository_impl.dart';
import 'package:erp_flutter/features/inventario/domain/usecases/ajustar_inventario_manual.dart';
import 'package:erp_flutter/features/inventario/domain/usecases/solicitar_refaccion_para_orden.dart';
import 'package:erp_flutter/features/pos/data/repositories/pos_repository_impl.dart';
import 'package:erp_flutter/features/pos/domain/entities/item_carrito.dart';
import 'package:erp_flutter/features/pos/domain/usecases/registrar_venta.dart';
import 'package:erp_flutter/features/taller/data/repositories/orden_trabajo_repository_impl.dart';
import 'package:erp_flutter/features/taller/domain/entities/orden_trabajo.dart';
import 'package:erp_flutter/features/taller/domain/usecases/asignar_mecanico.dart';
import 'package:erp_flutter/features/taller/domain/usecases/crear_orden_trabajo.dart';
import 'package:erp_flutter/core/data/mock/mock_extension_cotizacion_datasource.dart';
import 'package:erp_flutter/features/finanzas/domain/usecases/revertir_pago.dart';
import 'package:erp_flutter/features/taller/data/repositories/extension_cotizacion_repository_impl.dart';
import 'package:erp_flutter/features/taller/domain/usecases/aprobar_presupuesto.dart';
import 'package:erp_flutter/features/taller/domain/usecases/entregar_orden.dart';
import 'package:erp_flutter/features/taller/domain/usecases/reabrir_orden.dart';
import 'package:erp_flutter/features/taller/domain/usecases/solicitar_extension_cotizacion.dart';
import 'package:erp_flutter/features/taller/domain/usecases/terminar_orden.dart';
import 'package:erp_flutter/features/crm/domain/usecases/crear_cliente.dart';

/// Arma repositorios y casos de uso contra [MockDataStore] para pruebas E2E de negocio.
class MockIntegrationHarness {
  MockIntegrationHarness() {
    store.resetForTesting();
  }

  final store = MockDataStore.instance;

  late final auth = MockAuthRepositoryImpl(MockAuthDatasource(store));
  late final crmRepo = CrmRepositoryImpl(MockCrmDatasource(store));
  late final ordenRepo = OrdenTrabajoRepositoryImpl(
    MockOrdenTrabajoDatasource(store),
  );
  late final inventarioRepo = InventarioRepositoryImpl(
    MockInventarioDatasource(store),
  );
  late final finanzasRepo = FinanzasRepositoryImpl(
    MockFinanzasDatasource(store),
  );
  late final posRepo = PosRepositoryImpl(MockPosDatasource(store));
  late final comprasRepo = ComprasRepositoryImpl(MockComprasDatasource(store));

  late final iniciarSesion = IniciarSesion(auth);
  late final crearCliente = CrearCliente(crmRepo);
  late final crearOrden = CrearOrdenTrabajo(ordenRepo, crmRepo);
  late final asignarMecanico = AsignarMecanico(ordenRepo);
  late final solicitarRefaccion = SolicitarRefaccionParaOrden(
    inventarioRepo,
    ordenRepo,
  );
  late final aprobarPresupuesto = AprobarPresupuesto(ordenRepo);
  late final reabrirOrden = ReabrirOrden(ordenRepo);
  late final solicitarExtension = SolicitarExtensionCotizacion(
    ExtensionCotizacionRepositoryImpl(MockExtensionCotizacionDatasource(store)),
  );
  late final revertirPago = RevertirPago(finanzasRepo);
  late final terminarOrdenUseCase = TerminarOrden(ordenRepo);
  late final registrarPago = RegistrarPago(finanzasRepo);
  late final entregarOrden = EntregarOrden(ordenRepo, crmRepo);
  late final registrarVenta = RegistrarVenta(posRepo);
  late final ajustarInventario = AjustarInventarioManual(inventarioRepo);

  Future<Usuario> loginAdmin() async {
    final result = await iniciarSesion(
      email: 'admin@taller.com',
      password: 'admin123',
    );
    return result.fold((f) => throw Exception(f.mensaje), (u) => u);
  }

  Future<Usuario> loginRecepcion() async {
    final result = await iniciarSesion(
      email: 'recep@taller.com',
      password: 'recep123',
    );
    return result.fold((f) => throw Exception(f.mensaje), (u) => u);
  }

  Future<Usuario> loginMecanico() async {
    final result = await iniciarSesion(
      email: 'mec@taller.com',
      password: 'mec123',
    );
    return result.fold((f) => throw Exception(f.mensaje), (u) => u);
  }

  Future<OrdenTrabajo> orden(String id) async {
    final result = await ordenRepo.obtenerOrdenPorId(id);
    return result.fold((f) => throw Exception(f.mensaje), (o) => o);
  }
}
