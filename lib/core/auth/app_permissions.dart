import '../../features/auth/domain/entities/usuario.dart';

/// Permisos por ruta y acción. Centraliza RBAC del ERP.
class AppPermissions {
  AppPermissions._();

  static const _rutasPublicas = {'/login'};

  static bool esRutaPublica(String ruta) => _rutasPublicas.contains(ruta);

  static bool puedeAccederRuta(RolEmpleado rol, String ruta) {
    if (esRutaPublica(ruta)) return true;

    if (ruta.startsWith('/empleados')) {
      return rol == RolEmpleado.admin;
    }

    if (ruta.startsWith('/finanzas')) {
      return rol == RolEmpleado.admin || rol == RolEmpleado.supervisor;
    }

    if (ruta.startsWith('/compras')) {
      return rol == RolEmpleado.admin || rol == RolEmpleado.supervisor;
    }

    if (ruta.startsWith('/inventario/ajustar')) {
      return rol == RolEmpleado.admin;
    }

    if (ruta.startsWith('/pos')) {
      return rol != RolEmpleado.mecanico;
    }

    if (ruta.startsWith('/citas')) {
      return rol != RolEmpleado.mecanico;
    }

    if (ruta.startsWith('/reportes')) {
      return rol == RolEmpleado.admin || rol == RolEmpleado.supervisor;
    }

    return true;
  }

  static bool puedeVerCostos(RolEmpleado rol) =>
      rol == RolEmpleado.admin || rol == RolEmpleado.supervisor;

  static bool puedeAjustarInventario(RolEmpleado rol) =>
      rol == RolEmpleado.admin;

  static bool puedeGestionarPersonal(RolEmpleado rol) =>
      rol == RolEmpleado.admin;

  static bool puedeVerFinanzas(RolEmpleado rol) =>
      rol == RolEmpleado.admin || rol == RolEmpleado.supervisor;

  static bool puedeVerCompras(RolEmpleado rol) =>
      rol == RolEmpleado.admin || rol == RolEmpleado.supervisor;

  static List<String> rutasDrawer(RolEmpleado rol) {
    final rutas = <String>[
      '/ordenes',
      '/inventario',
      '/clientes',
      '/motocicletas',
    ];

    if (rol != RolEmpleado.mecanico) {
      rutas.add('/citas');
      rutas.add('/pos');
    }

    rutas.add('/comisiones');

    if (puedeVerFinanzas(rol)) {
      rutas.add('/finanzas');
    }

    if (puedeVerCompras(rol)) {
      rutas.add('/compras');
    }

    if (puedeGestionarPersonal(rol)) {
      rutas.add('/empleados');
    }

    return rutas;
  }
}
