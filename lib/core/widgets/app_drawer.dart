import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/entities/usuario.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../auth/app_permissions.dart';
import '../theme/app_theme.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRoute = GoRouterState.of(context).matchedLocation;
    final userAsync = ref.watch(authStateProvider);
    final user = userAsync.value;

    Widget tile({
      required IconData icon,
      required String title,
      required String route,
    }) {
      final selected = currentRoute.startsWith(route);
      return Material(
        color: selected
            ? XpColors.selection.withValues(alpha: 0.15)
            : Colors.transparent,
        child: ListTile(
          dense: true,
          leading: Icon(
            icon,
            size: 22,
            color: selected ? XpColors.selection : null,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected ? XpColors.selection : null,
            ),
          ),
          selected: selected,
          onTap: () {
            context.pop();
            context.go(route);
          },
        ),
      );
    }

    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [XpColors.titleStart, XpColors.titleEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ERP Taller',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                userAsync.when(
                  data: (u) => Text(
                    u == null ? '' : '${u.nombre} (${u.rol.name})',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                tile(
                  icon: Icons.build_outlined,
                  title: 'Órdenes de Trabajo',
                  route: '/ordenes',
                ),
                if (user?.rol == RolEmpleado.mecanico)
                  tile(
                    icon: Icons.engineering_outlined,
                    title: 'Mis órdenes',
                    route: '/mis-ordenes',
                  ),
                tile(
                  icon: Icons.view_kanban_outlined,
                  title: 'Kanban OT',
                  route: '/ordenes/kanban',
                ),
                if (user != null &&
                    AppPermissions.puedeAccederRuta(user.rol, '/citas'))
                  tile(
                    icon: Icons.event_outlined,
                    title: 'Citas',
                    route: '/citas',
                  ),
                tile(
                  icon: Icons.inventory_2_outlined,
                  title: 'Inventario',
                  route: '/inventario',
                ),
                tile(
                  icon: Icons.people_outline,
                  title: 'Clientes',
                  route: '/clientes',
                ),
                tile(
                  icon: Icons.motorcycle_outlined,
                  title: 'Motocicletas',
                  route: '/motocicletas',
                ),
                tile(
                  icon: Icons.dashboard_outlined,
                  title: 'Dashboard',
                  route: '/dashboard',
                ),
                if (user != null &&
                    AppPermissions.puedeAccederRuta(user.rol, '/reportes'))
                  tile(
                    icon: Icons.analytics_outlined,
                    title: 'Reportes',
                    route: '/reportes',
                  ),
                if (user != null &&
                    AppPermissions.puedeAccederRuta(user.rol, '/pos'))
                  tile(
                    icon: Icons.point_of_sale_outlined,
                    title: 'Punto de Venta',
                    route: '/pos',
                  ),
                tile(
                  icon: Icons.payments_outlined,
                  title: 'Comisiones',
                  route: '/comisiones',
                ),
                if (user != null && AppPermissions.puedeVerFinanzas(user.rol))
                  tile(
                    icon: Icons.account_balance_outlined,
                    title: 'Finanzas',
                    route: '/finanzas',
                  ),
                if (user != null && AppPermissions.puedeVerCompras(user.rol))
                  tile(
                    icon: Icons.shopping_cart_outlined,
                    title: 'Compras',
                    route: '/compras',
                  ),
                if (user?.rol == RolEmpleado.admin)
                  tile(
                    icon: Icons.badge_outlined,
                    title: 'Gestión de Personal',
                    route: '/empleados',
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            dense: true,
            leading: const Icon(Icons.logout, size: 22),
            title: const Text('Cerrar sesión'),
            onTap: () {
              context.pop();
              ref.read(cerrarSesionUseCaseProvider)();
            },
          ),
        ],
      ),
    );
  }
}
