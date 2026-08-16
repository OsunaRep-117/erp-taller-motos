import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/compras/presentation/screens/crear_orden_compra_screen.dart';
import '../../features/compras/presentation/screens/ordenes_compra_list_screen.dart';
import '../../features/compras/presentation/screens/compras_home_screen.dart';
import '../../features/compras/presentation/screens/crear_proveedor_screen.dart';
import '../../features/compras/presentation/screens/recibir_mercancia_screen.dart';
import '../../features/crm/presentation/screens/agendar_cita_screen.dart';
import '../../features/crm/presentation/screens/citas_list_screen.dart';
import '../../features/crm/presentation/screens/cliente_detail_screen.dart';
import '../../features/crm/presentation/screens/clientes_list_screen.dart';
import '../../features/crm/presentation/screens/crear_cliente_screen.dart';
import '../../features/crm/presentation/screens/crear_motocicleta_screen.dart';
import '../../features/crm/presentation/screens/motocicleta_detail_screen.dart';
import '../../features/crm/presentation/screens/motocicletas_list_screen.dart';
import '../../features/finanzas/presentation/screens/finanzas_dashboard_screen.dart';
import '../../features/finanzas/presentation/screens/reportes_ejecutivos_screen.dart';
import '../../features/inventario/presentation/screens/ajustar_inventario_screen.dart';
import '../../features/inventario/presentation/screens/crear_refaccion_screen.dart';
import '../../features/inventario/presentation/screens/refaccion_detail_screen.dart';
import '../../features/inventario/presentation/screens/inventario_list_screen.dart';
import '../../features/pos/presentation/screens/pos_screen.dart';
import '../../features/rrhh/presentation/screens/comisiones_list_screen.dart';
import '../../features/rrhh/presentation/screens/crear_empleado_screen.dart';
import '../../features/rrhh/presentation/screens/invitar_empleado_google_screen.dart';
import '../../features/rrhh/presentation/screens/empleados_list_screen.dart';
import '../../features/taller/presentation/screens/crear_orden_screen.dart';
import '../../features/taller/presentation/screens/dashboard_operativo_screen.dart';
import '../../features/taller/presentation/screens/mis_ordenes_screen.dart';
import '../../features/taller/presentation/screens/orden_detail_screen.dart';
import '../../features/taller/presentation/screens/ordenes_kanban_screen.dart';
import '../../features/taller/presentation/screens/ordenes_list_screen.dart';
import '../auth/app_permissions.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/ordenes',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/ordenes',
        builder: (context, state) => const OrdenesListScreen(),
        routes: [
          GoRoute(
            path: 'kanban',
            builder: (context, state) => const OrdenesKanbanScreen(),
          ),
          GoRoute(
            path: 'crear',
            builder: (context, state) => const CrearOrdenScreen(),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) =>
                OrdenDetailScreen(idOrden: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: '/mis-ordenes',
        builder: (context, state) => const MisOrdenesScreen(),
      ),
      GoRoute(
        path: '/inventario',
        builder: (context, state) => const InventarioListScreen(),
        routes: [
          GoRoute(
            path: 'crear',
            builder: (context, state) => const CrearRefaccionScreen(),
          ),
          GoRoute(
            path: 'ajustar',
            builder: (context, state) => const AjustarInventarioScreen(),
          ),
          GoRoute(
            path: ':sku',
            builder: (context, state) =>
                RefaccionDetailScreen(sku: state.pathParameters['sku']!),
          ),
        ],
      ),
      GoRoute(
        path: '/compras',
        builder: (context, state) => const ComprasHomeScreen(),
      ),
      GoRoute(
        path: '/compras/ordenes',
        builder: (context, state) => const OrdenesCompraListScreen(),
        routes: [
          GoRoute(
            path: 'crear',
            builder: (context, state) => const CrearOrdenCompraScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/compras/recibir',
        builder: (context, state) => const RecibirMercanciaScreen(),
      ),
      GoRoute(
        path: '/compras/proveedores/crear',
        builder: (context, state) => const CrearProveedorScreen(),
      ),
      GoRoute(
        path: '/citas',
        builder: (context, state) => const CitasListScreen(),
        routes: [
          GoRoute(
            path: 'agendar',
            builder: (context, state) => const AgendarCitaScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/clientes',
        builder: (context, state) => const ClientesListScreen(),
        routes: [
          GoRoute(
            path: 'crear',
            builder: (context, state) => const CrearClienteScreen(),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) =>
                ClienteDetailScreen(id: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: '/motocicletas',
        builder: (context, state) => const MotocicletasListScreen(),
        routes: [
          GoRoute(
            path: 'crear',
            builder: (context, state) => const CrearMotocicletaScreen(),
          ),
          GoRoute(
            path: ':vin',
            builder: (context, state) =>
                MotocicletaDetailScreen(vin: state.pathParameters['vin']!),
          ),
        ],
      ),
      GoRoute(
        path: '/finanzas',
        builder: (context, state) => const FinanzasDashboardScreen(),
      ),
      GoRoute(
        path: '/reportes',
        builder: (context, state) => const ReportesEjecutivosScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardOperativoScreen(),
      ),
      GoRoute(
        path: '/comisiones',
        builder: (context, state) => const ComisionesListScreen(),
      ),
      GoRoute(
        path: '/empleados',
        builder: (context, state) => const EmpleadosListScreen(),
        routes: [
          GoRoute(
            path: 'crear',
            builder: (context, state) => const CrearEmpleadoScreen(),
          ),
          GoRoute(
            path: 'invitar-google',
            builder: (context, state) => const InvitarEmpleadoGoogleScreen(),
          ),
        ],
      ),
      GoRoute(path: '/pos', builder: (context, state) => const PosScreen()),
    ],
    redirect: (context, state) {
      final authAsync = ref.read(authStateProvider);
      final usuario = authAsync.value;
      final haySesion = usuario != null;
      final ruta = state.matchedLocation;
      final vaAlLogin = ruta == '/login';

      if (authAsync.isLoading) return null;
      if (!haySesion && !vaAlLogin) return '/login';
      if (haySesion && vaAlLogin) return '/ordenes';

      if (usuario != null &&
          !AppPermissions.puedeAccederRuta(usuario.rol, ruta)) {
        return '/ordenes';
      }

      return null;
    },
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authRepositoryProvider).observarEstadoAuth(),
    ),
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
