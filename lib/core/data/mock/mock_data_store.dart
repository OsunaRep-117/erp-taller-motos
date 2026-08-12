import 'dart:async';
import 'dart:typed_data';

import 'package:uuid/uuid.dart';

import '../../../features/auth/domain/entities/usuario.dart';
import '../../../features/compras/domain/entities/proveedor.dart';
import '../../../features/crm/domain/entities/cliente.dart';
import '../../../features/crm/domain/entities/motocicleta.dart';
import '../../../features/finanzas/domain/entities/factura.dart';
import '../../../features/finanzas/domain/entities/pago.dart';
import '../../../features/inventario/domain/entities/refaccion.dart';
import '../../../features/rrhh/domain/entities/comision.dart';
import '../../../features/rrhh/domain/entities/empleado.dart';
import '../../../features/taller/data/models/orden_trabajo_model.dart';
import '../../../features/taller/domain/entities/orden_trabajo.dart';

/// Almacén en memoria para desarrollo sin Supabase.
/// Simula tablas, RPCs y reglas de negocio del backend.
class MockDataStore {
  MockDataStore._();
  static final instance = MockDataStore._();

  static const _uuid = Uuid();
  static const tarifaManoObraPorHora = 350.0;
  static const porcentajeComision = 0.08;

  Usuario? currentUser;
  final empleados = <Empleado>[];
  final clientes = <Cliente>[];
  final motocicletas = <Motocicleta>[];
  final refacciones = <Refaccion>[];
  final ordenes = <OrdenTrabajo>[];
  final pagos = <Pago>[];
  final facturas = <Factura>[];
  final comisiones = <Comision>[];
  final proveedores = <Proveedor>[];
  final entradasInventario = <EntradaInventario>[];
  final historialEstados = <HistorialEstado>[];
  final evidencias = <EvidenciaOt>[];
  final reservasPorOrden = <String, List<ReservaRefaccion>>{};
  final ventasPos = <VentaPos>[];
  final ajustesInventario = <AjusteInventario>[];
  final invitacionesEmpleados = <EmpleadoInvitacionRecord>[];

  String? _googleEmailSimulado;
  String? _googleNombreSimulado;

  final _authController = StreamController<Usuario?>.broadcast();
  final _ordenesController = StreamController<List<OrdenTrabajo>>.broadcast();

  Stream<Usuario?> get authStream => _authController.stream;
  Stream<List<OrdenTrabajo>> get ordenesStream => _ordenesController.stream;

  /// Credenciales demo: email -> password
  static const demoCredentials = {
    'admin@taller.com': 'admin123',
    'recep@taller.com': 'recep123',
    'mec@taller.com': 'mec123',
    'super@taller.com': 'super123',
  };

  bool _seeded = false;

  /// Reinicia datos demo entre pruebas de integración.
  void resetForTesting() {
    currentUser = null;
    empleados.clear();
    clientes.clear();
    motocicletas.clear();
    refacciones.clear();
    ordenes.clear();
    pagos.clear();
    facturas.clear();
    comisiones.clear();
    proveedores.clear();
    entradasInventario.clear();
    historialEstados.clear();
    evidencias.clear();
    reservasPorOrden.clear();
    ventasPos.clear();
    ajustesInventario.clear();
    invitacionesEmpleados.clear();
    _googleEmailSimulado = null;
    _googleNombreSimulado = null;
    _seeded = false;
    ensureSeeded();
    _authController.add(null);
    _emitOrdenes();
  }

  void ensureSeeded() {
    if (_seeded) return;
    _seeded = true;
    _seed();
  }

  void _seed() {
    final now = DateTime.now();

    empleados.addAll([
      Empleado(
        id: 'emp-admin',
        nombre: 'Ana Administradora',
        email: 'admin@taller.com',
        rol: RolEmpleado.admin,
        fechaContratacion: now.subtract(const Duration(days: 800)),
      ),
      Empleado(
        id: 'emp-recep',
        nombre: 'Carlos Recepción',
        email: 'recep@taller.com',
        rol: RolEmpleado.recepcionista,
        fechaContratacion: now.subtract(const Duration(days: 400)),
      ),
      Empleado(
        id: 'emp-mec',
        nombre: 'Diego Mecánico',
        email: 'mec@taller.com',
        rol: RolEmpleado.mecanico,
        fechaContratacion: now.subtract(const Duration(days: 300)),
      ),
      Empleado(
        id: 'emp-super',
        nombre: 'Laura Supervisora',
        email: 'super@taller.com',
        rol: RolEmpleado.supervisor,
        fechaContratacion: now.subtract(const Duration(days: 600)),
      ),
    ]);

    clientes.addAll([
      const Cliente(
        id: 'cli-001',
        nombreCompleto: 'Juan Pérez',
        telefono: '5551234567',
        esFlotilla: false,
      ),
      Cliente(
        id: 'cli-002',
        nombreCompleto: 'Transportes Rápidos SA',
        telefono: '5559876543',
        rfc: 'TRA850101ABC',
        limiteCredito: 15000,
        esFlotilla: true,
      ),
    ]);

    motocicletas.addAll([
      const Motocicleta(
        vin: '1HGBH41JXMN109186',
        placa: 'ABC-123',
        marca: 'Honda',
        modelo: 'CBR600',
        anio: 2022,
        idCliente: 'cli-001',
      ),
      const Motocicleta(
        vin: 'JH2RC4670MK200001',
        placa: 'FLO-001',
        marca: 'Kawasaki',
        modelo: 'Ninja 400',
        anio: 2023,
        idCliente: 'cli-002',
      ),
    ]);

    refacciones.addAll([
      const Refaccion(
        sku: 'ACE-001',
        nombre: 'Aceite 10W40',
        precioCosto: 85,
        precioVenta: 150,
        stockActual: 24,
        stockReservado: 0,
        stockMinimo: 5,
      ),
      const Refaccion(
        sku: 'PAST-001',
        nombre: 'Pastillas de freno',
        precioCosto: 220,
        precioVenta: 380,
        stockActual: 8,
        stockReservado: 0,
        stockMinimo: 4,
      ),
      const Refaccion(
        sku: 'CAD-001',
        nombre: 'Cadena de transmisión',
        precioCosto: 450,
        precioVenta: 720,
        stockActual: 3,
        stockReservado: 0,
        stockMinimo: 2,
      ),
    ]);

    proveedores.addAll([
      const Proveedor(id: 'prov-001', nombre: 'Refacciones del Norte', contacto: 'ventas@rdn.com'),
      const Proveedor(id: 'prov-002', nombre: 'MotoPartes MX', contacto: '5551112233', rfc: 'MPM900101XYZ'),
    ]);

    final ot1 = OrdenTrabajo(
      id: 'ot-001',
      idMoto: '1HGBH41JXMN109186',
      idMecanico: 'emp-mec',
      estado: EstadoOrdenTrabajo.enProceso,
      fallaReportada: 'Ruido en transmisión al acelerar',
      horasFacturables: 1.5,
      fechaCreacion: now.subtract(const Duration(days: 2)),
      fechaInicioReparacion: now.subtract(const Duration(days: 1)),
    );

    final ot2 = OrdenTrabajo(
      id: 'ot-002',
      idMoto: 'JH2RC4670MK200001',
      estado: EstadoOrdenTrabajo.pendiente,
      fallaReportada: 'Servicio de 5,000 km',
      fechaCreacion: now.subtract(const Duration(hours: 5)),
    );

    ordenes.addAll([ot1, ot2]);
    _registrarHistorial(ot1.id, null, ot1.estado, 'emp-recep');
    _registrarHistorial(ot2.id, null, ot2.estado, 'emp-recep');

    _emitOrdenes();
  }

  Usuario? empleadoToUsuario(Empleado emp) {
    if (!emp.activo) return null;
    return Usuario(id: emp.id, email: emp.email, nombre: emp.nombre, rol: emp.rol);
  }

  Usuario? login(String email, String password) {
    ensureSeeded();
    final expected = demoCredentials[email.trim().toLowerCase()];
    if (expected == null || expected != password) {
      throw Exception('Credenciales incorrectas.');
    }
    final emp = empleados.firstWhere(
      (e) => e.email.toLowerCase() == email.trim().toLowerCase() && e.activo,
      orElse: () => throw Exception('Empleado no encontrado o inactivo.'),
    );
    currentUser = empleadoToUsuario(emp);
    _authController.add(currentUser);
    return currentUser;
  }

  void configurarGoogleSimulado({required String email, required String nombre}) {
    _googleEmailSimulado = email.trim().toLowerCase();
    _googleNombreSimulado = nombre.trim();
  }

  Usuario resolverAccesoGoogle({
    required String authUserId,
    required String email,
    required String nombre,
  }) {
    ensureSeeded();
    final emailNorm = email.trim().toLowerCase();

    final idxEmp = empleados.indexWhere((e) => e.id == authUserId);
    if (idxEmp >= 0) {
      final existente = empleados[idxEmp];
      if (!existente.activo) throw Exception('Tu cuenta de empleado está desactivada.');
      currentUser = empleadoToUsuario(existente);
      _authController.add(currentUser);
      return currentUser!;
    }

    final idxInv = invitacionesEmpleados.indexWhere(
      (i) => i.email == emailNorm && !i.activado,
    );
    if (idxInv >= 0) {
      final inv = invitacionesEmpleados[idxInv];
      final emp = Empleado(
        id: authUserId,
        nombre: inv.nombre,
        email: inv.email,
        rol: inv.rol,
        fechaContratacion: DateTime.now(),
      );
      empleados.add(emp);
      invitacionesEmpleados[idxInv] = inv.copyWith(activado: true);
      currentUser = empleadoToUsuario(emp);
      _authController.add(currentUser);
      return currentUser!;
    }

    if (empleados.isEmpty) {
      final admin = Empleado(
        id: authUserId,
        nombre: nombre,
        email: emailNorm,
        rol: RolEmpleado.admin,
        fechaContratacion: DateTime.now(),
      );
      empleados.add(admin);
      currentUser = empleadoToUsuario(admin);
      _authController.add(currentUser);
      return currentUser!;
    }

    throw Exception(
      'No tienes acceso al ERP. Pide a un administrador que te invite desde Gestión de Personal.',
    );
  }

  Usuario? loginWithGoogle() {
    ensureSeeded();
    final email = _googleEmailSimulado ?? 'admin@taller.com';
    final nombre = _googleNombreSimulado ?? 'Administrador Google';
    final authId = 'google-${email.hashCode.abs()}';
    _googleEmailSimulado = null;
    _googleNombreSimulado = null;
    return resolverAccesoGoogle(authUserId: authId, email: email, nombre: nombre);
  }

  EmpleadoInvitacionRecord invitarEmpleadoGoogle({
    required String nombre,
    required String email,
    required RolEmpleado rol,
    required String invitadoPorId,
  }) {
    final emailNorm = email.trim().toLowerCase();
    if (empleados.any((e) => e.email.toLowerCase() == emailNorm)) {
      throw Exception('Ya existe un empleado activo con ese correo.');
    }
    if (invitacionesEmpleados.any((i) => i.email == emailNorm && !i.activado)) {
      throw Exception('Ya hay una invitación pendiente para ese correo.');
    }
    final inv = EmpleadoInvitacionRecord(
      id: _uuid.v4(),
      email: emailNorm,
      nombre: nombre.trim(),
      rol: rol,
      invitadoPorId: invitadoPorId,
      creadoEn: DateTime.now(),
    );
    invitacionesEmpleados.add(inv);
    return inv;
  }

  void cancelarInvitacion(String id) {
    invitacionesEmpleados.removeWhere((i) => i.id == id && !i.activado);
  }

  void logout() {
    currentUser = null;
    _authController.add(null);
  }

  String requireUserId() {
    final id = currentUser?.id;
    if (id == null) throw Exception('Sesión no iniciada.');
    return id;
  }

  OrdenTrabajo _findOrden(String id) =>
      ordenes.firstWhere((o) => o.id == id, orElse: () => throw Exception('Orden no encontrada.'));

  Refaccion _findRefaccion(String sku) {
    final idx = refacciones.indexWhere((r) => r.sku == sku && !r.inactivo);
    if (idx < 0) throw Exception('Refacción no encontrada.');
    return refacciones[idx];
  }

  void _updateOrden(int idx, OrdenTrabajo orden) {
    ordenes[idx] = orden;
    _emitOrdenes();
  }

  void _emitOrdenes() {
    if (!_ordenesController.isClosed) {
      _ordenesController.add(List.unmodifiable(ordenes));
    }
  }

  void _registrarHistorial(
    String idOrden,
    EstadoOrdenTrabajo? anterior,
    EstadoOrdenTrabajo nuevo,
    String idUsuario,
  ) {
    historialEstados.add(HistorialEstado(
      id: _uuid.v4(),
      idOrden: idOrden,
      estadoAnterior: anterior,
      estadoNuevo: nuevo,
      fechaCambio: DateTime.now(),
      idUsuario: idUsuario,
    ));
  }

  OrdenTrabajo crearOrden({
    required String idMoto,
    required String fallaReportada,
  }) {
    ensureSeeded();
    final orden = OrdenTrabajo(
      id: _uuid.v4(),
      idMoto: idMoto,
      estado: EstadoOrdenTrabajo.pendiente,
      fallaReportada: fallaReportada,
      fechaCreacion: DateTime.now(),
    );
    ordenes.insert(0, orden);
    _registrarHistorial(orden.id, null, orden.estado, requireUserId());
    _emitOrdenes();
    return orden;
  }

  int contarOrdenesEnProcesoDeMecanico(String idMecanico) =>
      ordenes.where((o) => o.idMecanico == idMecanico && o.estado == EstadoOrdenTrabajo.enProceso).length;

  OrdenTrabajo asignarMecanico({required String idOrden, required String idMecanico}) {
    if (contarOrdenesEnProcesoDeMecanico(idMecanico) >= 2) {
      throw Exception('El mecánico ya tiene 2 órdenes en proceso.');
    }
    final idx = ordenes.indexWhere((o) => o.id == idOrden);
    final anterior = ordenes[idx];
    final actualizada = anterior.copyWith(
      idMecanico: idMecanico,
      estado: EstadoOrdenTrabajo.enProceso,
      fechaInicioReparacion: DateTime.now(),
    );
    _registrarHistorial(idOrden, anterior.estado, actualizada.estado, requireUserId());
    _updateOrden(idx, actualizada);
    return actualizada;
  }

  OrdenTrabajo actualizarHoras({required String idOrden, required double horas}) {
    final idx = ordenes.indexWhere((o) => o.id == idOrden);
    final actualizada = ordenes[idx].copyWith(horasFacturables: horas);
    _updateOrden(idx, actualizada);
    return actualizada;
  }

  OrdenTrabajo marcarComoTerminada(String idOrden) {
    final idx = ordenes.indexWhere((o) => o.id == idOrden);
    final orden = ordenes[idx];
    confirmarSalidaPorOrden(idOrden);

    final reservas = reservasPorOrden[idOrden] ?? [];
    final costoRefacciones = reservas.fold<double>(
      0,
      (sum, r) => sum + (r.cantidad * r.precioUnitario),
    );
    final costoManoObra = orden.horasFacturables * tarifaManoObraPorHora;
    final saldo = costoRefacciones + costoManoObra;

    final actualizada = orden.copyWith(
      estado: EstadoOrdenTrabajo.terminado,
      saldoPendiente: saldo,
      fechaTerminado: DateTime.now(),
    );
    _registrarHistorial(idOrden, orden.estado, actualizada.estado, requireUserId());
    _updateOrden(idx, actualizada);
    return actualizada;
  }

  OrdenTrabajo marcarComoEntregada(String idOrden) {
    final idx = ordenes.indexWhere((o) => o.id == idOrden);
    final anterior = ordenes[idx];
    final actualizada = anterior.copyWith(estado: EstadoOrdenTrabajo.entregado);
    _registrarHistorial(idOrden, anterior.estado, actualizada.estado, requireUserId());
    _updateOrden(idx, actualizada);
    return actualizada;
  }

  OrdenTrabajo cancelarOrden(String idOrden, String motivo) {
    final idx = ordenes.indexWhere((o) => o.id == idOrden);
    final orden = ordenes[idx];
    if (orden.estado == EstadoOrdenTrabajo.entregado ||
        orden.estado == EstadoOrdenTrabajo.pagado) {
      throw Exception('No se puede cancelar una orden entregada o pagada.');
    }

    // Liberar reservas
    final reservas = reservasPorOrden.remove(idOrden) ?? [];
    for (final r in reservas) {
      final rIdx = refacciones.indexWhere((x) => x.sku == r.sku);
      if (rIdx >= 0) {
        final ref = refacciones[rIdx];
        refacciones[rIdx] = ref.copyWith(
          stockReservado: ref.stockReservado - r.cantidad,
        );
      }
    }

    final actualizada = orden.copyWith(estado: EstadoOrdenTrabajo.cancelada);
    _registrarHistorial(idOrden, orden.estado, actualizada.estado, requireUserId());
    _updateOrden(idx, actualizada);
    return actualizada;
  }

  OrdenTrabajo cambiarEstado({required String idOrden, required EstadoOrdenTrabajo nuevoEstado}) {
    final idx = ordenes.indexWhere((o) => o.id == idOrden);
    final orden = ordenes[idx];
    if (orden.esInmutable) {
      throw Exception('La orden ya no admite cambios de estado.');
    }
    final actualizada = orden.copyWith(estado: nuevoEstado);
    _registrarHistorial(idOrden, orden.estado, nuevoEstado, requireUserId());
    _updateOrden(idx, actualizada);
    return actualizada;
  }

  void reservarParaOrden({
    required String idOrden,
    required String sku,
    required int cantidad,
    required double precioUnitarioVenta,
  }) {
    if (cantidad <= 0) throw Exception('Cantidad inválida.');
    final rIdx = refacciones.indexWhere((r) => r.sku == sku);
    final ref = refacciones[rIdx];
    if (ref.stockDisponible < cantidad) {
      throw Exception('Stock insuficiente para $sku.');
    }
    refacciones[rIdx] = ref.copyWith(stockReservado: ref.stockReservado + cantidad);
    reservasPorOrden.putIfAbsent(idOrden, () => []);
    reservasPorOrden[idOrden]!.add(ReservaRefaccion(
      sku: sku,
      cantidad: cantidad,
      precioUnitario: precioUnitarioVenta,
    ));
  }

  void confirmarSalidaPorOrden(String idOrden) {
    final reservas = reservasPorOrden.remove(idOrden) ?? [];
    for (final r in reservas) {
      final rIdx = refacciones.indexWhere((x) => x.sku == r.sku);
      if (rIdx < 0) continue;
      final ref = refacciones[rIdx];
      refacciones[rIdx] = ref.copyWith(
        stockActual: ref.stockActual - r.cantidad,
        stockReservado: ref.stockReservado - r.cantidad,
      );
    }
  }

  void ajustarInventarioManual({
    required String sku,
    required int cantidadAjuste,
    required String justificacion,
  }) {
    final rIdx = refacciones.indexWhere((r) => r.sku == sku);
    final ref = refacciones[rIdx];
    final nuevoStock = ref.stockActual + cantidadAjuste;
    if (nuevoStock < 0) throw Exception('El ajuste dejaría stock negativo.');
    refacciones[rIdx] = ref.copyWith(stockActual: nuevoStock);
    ajustesInventario.add(AjusteInventario(
      sku: sku,
      cantidad: cantidadAjuste,
      justificacion: justificacion,
      fecha: DateTime.now(),
      idUsuario: requireUserId(),
    ));
  }

  void registrarPago({
    required String idOrden,
    required double monto,
    required MetodoPago metodoPago,
  }) {
    final idx = ordenes.indexWhere((o) => o.id == idOrden);
    final orden = ordenes[idx];
    if (monto <= 0) throw Exception('Monto inválido.');

    final pagosActivos = pagos.where((p) => p.idOrden == idOrden && !p.esReversion).fold<double>(
          0,
          (s, p) => s + p.monto,
        );
    if (pagosActivos + monto > orden.saldoPendiente + 0.01) {
      throw Exception('El pago excede el saldo pendiente.');
    }

    pagos.add(Pago(
      id: _uuid.v4(),
      idOrden: idOrden,
      monto: monto,
      metodoPago: metodoPago,
      fechaPago: DateTime.now(),
    ));

    final nuevoSaldo = orden.saldoPendiente - monto;
    var nuevoEstado = orden.estado;
    if (nuevoSaldo <= 0.01) {
      nuevoEstado = EstadoOrdenTrabajo.pagado;
      _registrarHistorial(idOrden, orden.estado, nuevoEstado, requireUserId());

      // Generar comisión
      if (orden.idMecanico != null) {
        comisiones.insert(
          0,
          Comision(
            id: _uuid.v4(),
            idOrden: idOrden,
            idMecanico: orden.idMecanico!,
            monto: orden.saldoPendiente * porcentajeComision,
            porcentajeAplicado: porcentajeComision,
            fechaGenerada: DateTime.now(),
          ),
        );
      }
    }

    _updateOrden(idx, orden.copyWith(saldoPendiente: nuevoSaldo.clamp(0, double.infinity), estado: nuevoEstado));
  }

  void revertirPago(String idPago) {
    final pago = pagos.firstWhere((p) => p.id == idPago);
    pagos.add(Pago(
      id: _uuid.v4(),
      idOrden: pago.idOrden,
      monto: -pago.monto,
      metodoPago: pago.metodoPago,
      idPagoRevertido: idPago,
      fechaPago: DateTime.now(),
    ));

    final idx = ordenes.indexWhere((o) => o.id == pago.idOrden);
    final orden = ordenes[idx];
    _updateOrden(
      idx,
      orden.copyWith(saldoPendiente: orden.saldoPendiente + pago.monto),
    );
  }

  Factura emitirFactura({required String idOrden, required String rfcReceptor}) {
    final factura = Factura(
      id: _uuid.v4(),
      idOrden: idOrden,
      folioFiscal: 'FOLIO-${_uuid.v4().substring(0, 8).toUpperCase()}',
      rfcReceptor: rfcReceptor,
      estado: EstadoFactura.vigente,
      fechaEmision: DateTime.now(),
    );
    facturas.insert(0, factura);
    return factura;
  }

  void generarNotaCredito({
    required String idFactura,
    required String motivo,
    required double monto,
  }) {
    final idx = facturas.indexWhere((f) => f.id == idFactura);
    final f = facturas[idx];
    facturas[idx] = Factura(
      id: f.id,
      idOrden: f.idOrden,
      folioFiscal: f.folioFiscal,
      rfcReceptor: f.rfcReceptor,
      estado: EstadoFactura.cancelada,
      fechaEmision: f.fechaEmision,
    );
  }

  double obtenerIngresosMensuales() {
    final now = DateTime.now();
    return pagos
        .where((p) =>
            !p.esReversion &&
            p.monto > 0 &&
            p.fechaPago.month == now.month &&
            p.fechaPago.year == now.year)
        .fold(0.0, (s, p) => s + p.monto);
  }

  double obtenerValorInventario() => refacciones
      .where((r) => !r.inactivo)
      .fold(0.0, (s, r) => s + r.stockActual * r.precioCosto);

  void registrarEntrada({
    required String sku,
    required int cantidad,
    required double costoUnitario,
    required String idProveedor,
  }) {
    incrementarStock(sku, cantidad);
    entradasInventario.insert(
      0,
      EntradaInventario(
        id: _uuid.v4(),
        sku: sku,
        cantidad: cantidad,
        costoUnitario: costoUnitario,
        idProveedor: idProveedor,
        fecha: DateTime.now(),
      ),
    );
  }

  void incrementarStock(String sku, int cantidad) {
    final rIdx = refacciones.indexWhere((r) => r.sku == sku);
    final ref = refacciones[rIdx];
    refacciones[rIdx] = ref.copyWith(stockActual: ref.stockActual + cantidad);
  }

  String registrarVentaPos(List<Map<String, dynamic>> items, {String metodoPago = 'efectivo'}) {
    for (final item in items) {
      final sku = item['sku'] as String;
      final cantidad = item['cantidad'] as int;
      final rIdx = refacciones.indexWhere((r) => r.sku == sku);
      final ref = refacciones[rIdx];
      if (ref.stockDisponible < cantidad) {
        throw Exception('Stock insuficiente para $sku.');
      }
      refacciones[rIdx] = ref.copyWith(stockActual: ref.stockActual - cantidad);
    }
    final id = _uuid.v4();
    ventasPos.insert(0, VentaPos(
      id: id,
      items: items,
      fecha: DateTime.now(),
      idUsuario: requireUserId(),
      metodoPago: metodoPago,
    ));
    return id;
  }

  String subirEvidencia({
    required String idOrden,
    required Uint8List bytes,
    required String nombreArchivo,
    required String etapa,
    required String subidaPor,
  }) {
    final path = '$idOrden/${DateTime.now().millisecondsSinceEpoch}_$nombreArchivo';
    evidencias.add(EvidenciaOt(
      id: _uuid.v4(),
      idOrden: idOrden,
      storagePath: path,
      etapa: etapa,
      subidaPor: subidaPor,
      bytes: bytes,
    ));
    return path;
  }
}

class HistorialEstado {
  final String id;
  final String idOrden;
  final EstadoOrdenTrabajo? estadoAnterior;
  final EstadoOrdenTrabajo estadoNuevo;
  final DateTime fechaCambio;
  final String idUsuario;

  HistorialEstado({
    required this.id,
    required this.idOrden,
    required this.estadoAnterior,
    required this.estadoNuevo,
    required this.fechaCambio,
    required this.idUsuario,
  });
}

class ReservaRefaccion {
  final String sku;
  final int cantidad;
  final double precioUnitario;

  ReservaRefaccion({
    required this.sku,
    required this.cantidad,
    required this.precioUnitario,
  });
}

class EntradaInventario {
  final String id;
  final String sku;
  final int cantidad;
  final double costoUnitario;
  final String idProveedor;
  final DateTime fecha;

  EntradaInventario({
    required this.id,
    required this.sku,
    required this.cantidad,
    required this.costoUnitario,
    required this.idProveedor,
    required this.fecha,
  });
}

class EvidenciaOt {
  final String id;
  final String idOrden;
  final String storagePath;
  final String etapa;
  final String subidaPor;
  final Uint8List bytes;

  EvidenciaOt({
    required this.id,
    required this.idOrden,
    required this.storagePath,
    required this.etapa,
    required this.subidaPor,
    required this.bytes,
  });
}

class VentaPos {
  final String id;
  final List<Map<String, dynamic>> items;
  final DateTime fecha;
  final String idUsuario;
  final String metodoPago;

  VentaPos({
    required this.id,
    required this.items,
    required this.fecha,
    required this.idUsuario,
    this.metodoPago = 'efectivo',
  });
}

class AjusteInventario {
  final String sku;
  final int cantidad;
  final String justificacion;
  final DateTime fecha;
  final String idUsuario;

  AjusteInventario({
    required this.sku,
    required this.cantidad,
    required this.justificacion,
    required this.fecha,
    required this.idUsuario,
  });
}

class EmpleadoInvitacionRecord {
  final String id;
  final String email;
  final String nombre;
  final RolEmpleado rol;
  final String invitadoPorId;
  final DateTime creadoEn;
  final bool activado;

  EmpleadoInvitacionRecord({
    required this.id,
    required this.email,
    required this.nombre,
    required this.rol,
    required this.invitadoPorId,
    required this.creadoEn,
    this.activado = false,
  });

  EmpleadoInvitacionRecord copyWith({bool? activado}) => EmpleadoInvitacionRecord(
        id: id,
        email: email,
        nombre: nombre,
        rol: rol,
        invitadoPorId: invitadoPorId,
        creadoEn: creadoEn,
        activado: activado ?? this.activado,
      );
}
