import 'dart:async';
import 'dart:typed_data';

import 'package:uuid/uuid.dart';

import '../../../features/auth/domain/entities/usuario.dart';
import '../../../features/compras/domain/entities/orden_compra.dart';
import '../../../features/compras/domain/entities/proveedor.dart';
import '../../../features/crm/domain/entities/cita.dart';
import '../../../features/finanzas/domain/entities/gasto_operativo.dart';
import '../../../features/inventario/domain/entities/movimiento_inventario.dart';
import '../../../features/taller/domain/entities/extension_cotizacion.dart';
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
  static const maxCitasPorHora = 3;

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
  final consumosPorOrden = <String, List<ConsumoRefaccion>>{};
  final ventasPos = <VentaPos>[];
  final cierresCaja = <CierreCajaRecord>[];
  final ajustesInventario = <AjusteInventario>[];
  final invitacionesEmpleados = <EmpleadoInvitacionRecord>[];
  final citas = <Cita>[];
  final ordenesCompra = <OrdenCompra>[];
  final compraDetalle = <CompraDetalle>[];
  final extensionesCotizacion = <ExtensionCotizacion>[];
  final gastosOperativos = <GastoOperativo>[];
  final movimientosInventario = <MovimientoInventario>[];

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
    consumosPorOrden.clear();
    ventasPos.clear();
    cierresCaja.clear();
    ajustesInventario.clear();
    invitacionesEmpleados.clear();
    citas.clear();
    ordenesCompra.clear();
    compraDetalle.clear();
    extensionesCotizacion.clear();
    gastosOperativos.clear();
    movimientosInventario.clear();
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
      const Proveedor(
        id: 'prov-001',
        nombre: 'Refacciones del Norte',
        contacto: 'ventas@rdn.com',
      ),
      const Proveedor(
        id: 'prov-002',
        nombre: 'MotoPartes MX',
        contacto: '5551112233',
        rfc: 'MPM900101XYZ',
      ),
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
    return Usuario(
      id: emp.id,
      email: emp.email,
      nombre: emp.nombre,
      rol: emp.rol,
    );
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

  void configurarGoogleSimulado({
    required String email,
    required String nombre,
  }) {
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
      if (!existente.activo)
        throw Exception('Tu cuenta de empleado está desactivada.');
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
    return resolverAccesoGoogle(
      authUserId: authId,
      email: email,
      nombre: nombre,
    );
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

  OrdenTrabajo _findOrden(String id) => ordenes.firstWhere(
    (o) => o.id == id,
    orElse: () => throw Exception('Orden no encontrada.'),
  );

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
    historialEstados.add(
      HistorialEstado(
        id: _uuid.v4(),
        idOrden: idOrden,
        estadoAnterior: anterior,
        estadoNuevo: nuevo,
        fechaCambio: DateTime.now(),
        idUsuario: idUsuario,
      ),
    );
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

  int contarOrdenesEnProcesoDeMecanico(String idMecanico) => ordenes
      .where(
        (o) =>
            o.idMecanico == idMecanico &&
            o.estado == EstadoOrdenTrabajo.enProceso,
      )
      .length;

  OrdenTrabajo asignarMecanico({
    required String idOrden,
    required String idMecanico,
  }) {
    if (contarOrdenesEnProcesoDeMecanico(idMecanico) >= 2) {
      throw Exception('El mecánico ya tiene 2 órdenes en proceso.');
    }
    final idx = ordenes.indexWhere((o) => o.id == idOrden);
    final anterior = ordenes[idx];
    final actualizada = anterior.copyWith(
      idMecanico: idMecanico,
      estado: EstadoOrdenTrabajo.enProceso,
      fechaInicioReparacion: DateTime.now(),
      horasEstimadas: anterior.horasEstimadas > 0 ? anterior.horasEstimadas : 2,
    );
    _registrarHistorial(
      idOrden,
      anterior.estado,
      actualizada.estado,
      requireUserId(),
    );
    _updateOrden(idx, actualizada);
    return actualizada;
  }

  OrdenTrabajo actualizarHoras({
    required String idOrden,
    required double horas,
  }) {
    final idx = ordenes.indexWhere((o) => o.id == idOrden);
    final actualizada = ordenes[idx].copyWith(horasFacturables: horas);
    _updateOrden(idx, actualizada);
    return actualizada;
  }

  OrdenTrabajo marcarComoTerminada(String idOrden) {
    final idx = ordenes.indexWhere((o) => o.id == idOrden);
    final orden = ordenes[idx];

    final reservas = List<ReservaRefaccion>.from(
      reservasPorOrden[idOrden] ?? [],
    );
    final costoRefacciones = reservas.fold<double>(
      0,
      (sum, r) => sum + (r.cantidad * r.precioUnitario),
    );
    final costoManoObra = orden.horasFacturables * tarifaManoObraPorHora;
    final saldo = costoRefacciones + costoManoObra;

    confirmarSalidaPorOrden(idOrden);

    final actualizada = orden.copyWith(
      estado: EstadoOrdenTrabajo.terminado,
      saldoPendiente: saldo,
      fechaTerminado: DateTime.now(),
    );
    _registrarHistorial(
      idOrden,
      orden.estado,
      actualizada.estado,
      requireUserId(),
    );
    _updateOrden(idx, actualizada);
    return actualizada;
  }

  /// Exposición de crédito B2B: suma saldo pendiente en OT activas del cliente (§5.4).
  double calcularExposicionCredito(String idCliente) {
    final vinsCliente = motocicletas
        .where((m) => m.idCliente == idCliente)
        .map((m) => m.vin)
        .toSet();
    return ordenes
        .where(
          (o) =>
              vinsCliente.contains(o.idMoto) &&
              o.estado != EstadoOrdenTrabajo.entregado &&
              o.estado != EstadoOrdenTrabajo.cancelada &&
              o.saldoPendiente > 0,
        )
        .fold<double>(0, (sum, o) => sum + o.saldoPendiente);
  }

  /// §5.4 — bloqueo suave flotilla con adeudo > 30 días.
  bool clienteFlotillaMoroso(String idCliente) {
    ensureSeeded();
    final cliente = clientes.firstWhere((c) => c.id == idCliente);
    if (!cliente.esFlotilla) return false;

    final vinsCliente = motocicletas
        .where((m) => m.idCliente == idCliente)
        .map((m) => m.vin)
        .toSet();
    final limite = DateTime.now().subtract(const Duration(days: 30));

    return ordenes.any(
      (o) =>
          vinsCliente.contains(o.idMoto) &&
          o.saldoPendiente > 0 &&
          o.estado != EstadoOrdenTrabajo.cancelada &&
          o.estado != EstadoOrdenTrabajo.entregado &&
          o.fechaCreacion.isBefore(limite),
    );
  }

  int _contarCitasEnSlot(DateTime fecha) {
    final slot = DateTime(fecha.year, fecha.month, fecha.day, fecha.hour);
    return citas.where((c) {
      if (c.estado != EstadoCita.agendada &&
          c.estado != EstadoCita.confirmada) {
        return false;
      }
      final cSlot = DateTime(
        c.fechaCita.year,
        c.fechaCita.month,
        c.fechaCita.day,
        c.fechaCita.hour,
      );
      return cSlot == slot;
    }).length;
  }

  Cita agendarCita({
    required String idCliente,
    required DateTime fechaCita,
    required String motivo,
    String? idMoto,
  }) {
    ensureSeeded();
    if (motivo.trim().isEmpty) {
      throw Exception('El motivo de la cita es obligatorio.');
    }
    if (_contarCitasEnSlot(fechaCita) >= maxCitasPorHora) {
      throw Exception(
        'Horario saturado: no se permiten más citas en ese slot.',
      );
    }

    final cita = Cita(
      id: _uuid.v4(),
      idCliente: idCliente,
      idMoto: idMoto,
      fechaCita: fechaCita,
      motivo: motivo.trim(),
      estado: EstadoCita.agendada,
      createdAt: DateTime.now(),
    );
    citas.insert(0, cita);
    return cita;
  }

  Cita confirmarCita(String idCita) {
    final idx = citas.indexWhere((c) => c.id == idCita);
    final cita = citas[idx];
    if (cita.estado != EstadoCita.agendada) {
      throw Exception('Cita no encontrada o no está agendada.');
    }
    final actualizada = Cita(
      id: cita.id,
      idCliente: cita.idCliente,
      idMoto: cita.idMoto,
      idOrden: cita.idOrden,
      fechaCita: cita.fechaCita,
      motivo: cita.motivo,
      estado: EstadoCita.confirmada,
      createdAt: cita.createdAt,
    );
    citas[idx] = actualizada;
    return actualizada;
  }

  Cita cancelarCita(String idCita) {
    final idx = citas.indexWhere((c) => c.id == idCita);
    final cita = citas[idx];
    if (cita.estado != EstadoCita.agendada &&
        cita.estado != EstadoCita.confirmada) {
      throw Exception('Cita no encontrada o ya fue completada/cancelada.');
    }
    final actualizada = Cita(
      id: cita.id,
      idCliente: cita.idCliente,
      idMoto: cita.idMoto,
      idOrden: cita.idOrden,
      fechaCita: cita.fechaCita,
      motivo: cita.motivo,
      estado: EstadoCita.cancelada,
      createdAt: cita.createdAt,
    );
    citas[idx] = actualizada;
    return actualizada;
  }

  Cita completarCita({
    required String idCita,
    required String idMoto,
    required String idOrden,
  }) {
    final idx = citas.indexWhere((c) => c.id == idCita);
    final cita = citas[idx];
    if (cita.estado != EstadoCita.agendada &&
        cita.estado != EstadoCita.confirmada) {
      throw Exception('Cita no encontrada o no puede completarse.');
    }
    if (!ordenes.any((o) => o.id == idOrden)) {
      throw Exception('La orden de trabajo indicada no existe.');
    }
    final actualizada = Cita(
      id: cita.id,
      idCliente: cita.idCliente,
      idMoto: idMoto,
      idOrden: idOrden,
      fechaCita: cita.fechaCita,
      motivo: cita.motivo,
      estado: EstadoCita.completada,
      createdAt: cita.createdAt,
    );
    citas[idx] = actualizada;
    return actualizada;
  }

  OrdenTrabajo marcarComoEntregada(String idOrden) {
    final idx = ordenes.indexWhere((o) => o.id == idOrden);
    final anterior = ordenes[idx];
    final actualizada = anterior.copyWith(estado: EstadoOrdenTrabajo.entregado);
    _registrarHistorial(
      idOrden,
      anterior.estado,
      actualizada.estado,
      requireUserId(),
    );
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
    _registrarHistorial(
      idOrden,
      orden.estado,
      actualizada.estado,
      requireUserId(),
    );
    _updateOrden(idx, actualizada);
    return actualizada;
  }

  OrdenTrabajo cambiarEstado({
    required String idOrden,
    required EstadoOrdenTrabajo nuevoEstado,
  }) {
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

  OrdenTrabajo aprobarPresupuesto(String idOrden) {
    final idx = ordenes.indexWhere((o) => o.id == idOrden);
    final orden = ordenes[idx];
    if (orden.esInmutable) {
      throw Exception('La orden ya no admite cambios.');
    }
    final actualizada = orden.copyWith(
      fechaAprobacionPresupuesto: DateTime.now(),
      estado: EstadoOrdenTrabajo.enProceso,
    );
    _registrarHistorial(
      idOrden,
      orden.estado,
      actualizada.estado,
      requireUserId(),
    );
    _updateOrden(idx, actualizada);
    return actualizada;
  }

  OrdenTrabajo reabrirOrden(String idOrden) {
    final user = requireUserId();
    if (currentUser?.rol != RolEmpleado.admin) {
      throw Exception('Solo un administrador puede reabrir la orden.');
    }
    final idx = ordenes.indexWhere((o) => o.id == idOrden);
    final orden = ordenes[idx];
    if (orden.estado != EstadoOrdenTrabajo.terminado) {
      throw Exception('Solo se puede reabrir una orden en estado terminado.');
    }
    final actualizada = orden.copyWith(
      estado: EstadoOrdenTrabajo.enProceso,
      fechaTerminado: null,
    );
    _registrarHistorial(idOrden, orden.estado, actualizada.estado, user);
    _updateOrden(idx, actualizada);
    return actualizada;
  }

  ExtensionCotizacion solicitarExtensionCotizacion({
    required String idOrden,
    required String descripcion,
    required double montoAdicional,
  }) {
    final orden = ordenes.firstWhere((o) => o.id == idOrden);
    if (!orden.presupuestoAprobado || orden.esInmutable) {
      throw Exception(
        'La orden debe tener presupuesto aprobado y estar activa.',
      );
    }
    if (montoAdicional <= 0)
      throw Exception('El monto adicional debe ser mayor a cero.');
    final ext = ExtensionCotizacion(
      id: _uuid.v4(),
      idOrden: idOrden,
      descripcion: descripcion,
      montoAdicional: montoAdicional,
      estado: EstadoExtensionCotizacion.pendiente,
      fechaSolicitud: DateTime.now(),
    );
    extensionesCotizacion.insert(0, ext);
    return ext;
  }

  ExtensionCotizacion aprobarExtensionCotizacion(String idExtension) {
    if (currentUser?.rol != RolEmpleado.admin &&
        currentUser?.rol != RolEmpleado.supervisor) {
      throw Exception('Sin permisos para aprobar extensiones.');
    }
    final idx = extensionesCotizacion.indexWhere((e) => e.id == idExtension);
    final ext = extensionesCotizacion[idx];
    if (ext.estado != EstadoExtensionCotizacion.pendiente) {
      throw Exception('La extensión ya fue procesada.');
    }
    final actualizada = ext.copyWith(
      estado: EstadoExtensionCotizacion.aprobada,
    );
    extensionesCotizacion[idx] = actualizada;
    return actualizada;
  }

  OrdenCompra crearOrdenCompra({
    required String idProveedor,
    required List<CompraDetalle> items,
  }) {
    if (currentUser?.rol != RolEmpleado.admin &&
        currentUser?.rol != RolEmpleado.supervisor) {
      throw Exception('Sin permisos para crear órdenes de compra.');
    }
    final id = _uuid.v4();
    final oc = OrdenCompra(
      id: id,
      idProveedor: idProveedor,
      fechaCreacion: DateTime.now(),
      estado: EstadoOrdenCompra.borrador,
      total: items.fold<double>(0, (s, i) => s + i.cantidad * i.precioCompra),
    );
    ordenesCompra.insert(0, oc);
    for (final item in items) {
      compraDetalle.add(
        CompraDetalle(
          idCompra: id,
          skuRefaccion: item.skuRefaccion,
          cantidad: item.cantidad,
          precioCompra: item.precioCompra,
        ),
      );
    }
    return oc;
  }

  OrdenCompra aprobarOrdenCompra(String idCompra) {
    if (currentUser?.rol != RolEmpleado.admin &&
        currentUser?.rol != RolEmpleado.supervisor) {
      throw Exception('Sin permisos para aprobar órdenes de compra.');
    }
    final idx = ordenesCompra.indexWhere((o) => o.id == idCompra);
    final oc = ordenesCompra[idx];
    if (oc.estado != EstadoOrdenCompra.borrador) {
      throw Exception('La orden de compra no está en borrador.');
    }
    final actualizada = OrdenCompra(
      id: oc.id,
      idProveedor: oc.idProveedor,
      fechaCreacion: oc.fechaCreacion,
      estado: EstadoOrdenCompra.aprobada,
      total: oc.total,
    );
    ordenesCompra[idx] = actualizada;
    return actualizada;
  }

  void recibirOrdenCompra(String idCompra) {
    if (currentUser?.rol != RolEmpleado.admin &&
        currentUser?.rol != RolEmpleado.supervisor) {
      throw Exception('Sin permisos para recibir órdenes de compra.');
    }
    final idx = ordenesCompra.indexWhere((o) => o.id == idCompra);
    final oc = ordenesCompra[idx];
    if (oc.estado != EstadoOrdenCompra.aprobada) {
      throw Exception('La orden de compra debe estar aprobada.');
    }
    final items = compraDetalle.where((d) => d.idCompra == idCompra);
    for (final item in items) {
      registrarEntrada(
        sku: item.skuRefaccion,
        cantidad: item.cantidad,
        costoUnitario: item.precioCompra,
        idProveedor: oc.idProveedor,
      );
    }
    ordenesCompra[idx] = OrdenCompra(
      id: oc.id,
      idProveedor: oc.idProveedor,
      fechaCreacion: oc.fechaCreacion,
      estado: EstadoOrdenCompra.recibida,
      total: oc.total,
    );
  }

  GastoOperativo registrarGastoOperativo({
    required String concepto,
    required double monto,
    String? categoria,
  }) {
    if (currentUser?.rol != RolEmpleado.admin &&
        currentUser?.rol != RolEmpleado.supervisor) {
      throw Exception('Sin permisos para registrar gastos operativos.');
    }
    if (monto <= 0) throw Exception('Monto inválido.');
    final gasto = GastoOperativo(
      id: _uuid.v4(),
      concepto: concepto,
      categoria: categoria,
      monto: monto,
      fechaGasto: DateTime.now(),
    );
    gastosOperativos.insert(0, gasto);
    return gasto;
  }

  double obtenerGastosOperativosMes() {
    final now = DateTime.now();
    return gastosOperativos
        .where(
          (g) =>
              g.fechaGasto.month == now.month && g.fechaGasto.year == now.year,
        )
        .fold(0.0, (s, g) => s + g.monto);
  }

  List<Map<String, dynamic>> obtenerReservasPorOrden(String idOrden) {
    final reservas = reservasPorOrden[idOrden] ?? const <ReservaRefaccion>[];
    return reservas.map((r) {
      final ref = refacciones.firstWhere(
        (item) => item.sku == r.sku,
        orElse: () => Refaccion(
          sku: r.sku,
          nombre: r.sku,
          precioCosto: 0,
          precioVenta: r.precioUnitario,
          stockActual: 0,
          stockReservado: 0,
          stockMinimo: 0,
        ),
      );
      return {
        'sku': r.sku,
        'nombre': ref.nombre,
        'cantidad': r.cantidad,
        'precio_unitario': r.precioUnitario,
        'subtotal': r.cantidad * r.precioUnitario,
      };
    }).toList();
  }

  List<Map<String, dynamic>> obtenerConsumosPorOrden(String idOrden) {
    final consumos = consumosPorOrden[idOrden] ?? const <ConsumoRefaccion>[];
    return consumos.map((c) {
      final ref = refacciones.firstWhere(
        (item) => item.sku == c.sku,
        orElse: () => Refaccion(
          sku: c.sku,
          nombre: c.nombre,
          precioCosto: 0,
          precioVenta: c.precioUnitario,
          stockActual: 0,
          stockReservado: 0,
          stockMinimo: 0,
        ),
      );
      return {
        'sku': c.sku,
        'nombre': ref.nombre,
        'cantidad': c.cantidad,
        'precio_unitario': c.precioUnitario,
        'subtotal': c.cantidad * c.precioUnitario,
        'tipo': c.tipo,
      };
    }).toList();
  }

  void reservarParaOrden({
    required String idOrden,
    required String sku,
    required int cantidad,
    required double precioUnitarioVenta,
  }) {
    if (cantidad <= 0) throw Exception('Cantidad inválida.');
    final orden = ordenes.firstWhere((o) => o.id == idOrden);
    if (!orden.presupuestoAprobado) {
      throw Exception(
        'Debe aprobar el presupuesto antes de reservar refacciones.',
      );
    }
    final reservas = reservasPorOrden[idOrden] ?? [];
    if (reservas.isNotEmpty) {
      final extension = extensionesCotizacion.where(
        (e) =>
            e.idOrden == idOrden &&
            e.estado == EstadoExtensionCotizacion.aprobada &&
            !e.utilizada,
      );
      if (extension.isEmpty) {
        throw Exception(
          'Se requiere una extensión de cotización aprobada para agregar refacciones.',
        );
      }
      final idxExt = extensionesCotizacion.indexWhere(
        (e) => e.id == extension.first.id,
      );
      extensionesCotizacion[idxExt] = extension.first.copyWith(utilizada: true);
    }
    final rIdx = refacciones.indexWhere((r) => r.sku == sku);
    final ref = refacciones[rIdx];
    if (ref.stockDisponible < cantidad) {
      throw Exception('Stock insuficiente para $sku.');
    }
    refacciones[rIdx] = ref.copyWith(
      stockReservado: ref.stockReservado + cantidad,
    );
    reservasPorOrden.putIfAbsent(idOrden, () => []);
    reservasPorOrden[idOrden]!.add(
      ReservaRefaccion(
        sku: sku,
        cantidad: cantidad,
        precioUnitario: precioUnitarioVenta,
      ),
    );
  }

  void registrarConsumoParaOrden({
    required String idOrden,
    required String sku,
    required String nombre,
    required int cantidad,
    required double precioUnitario,
  }) {
    if (cantidad <= 0) throw Exception('Cantidad inválida.');
    _findOrden(idOrden);

    final rIdx = refacciones.indexWhere((r) => r.sku == sku);
    if (rIdx < 0) throw Exception('Refacción no encontrada.');

    final ref = refacciones[rIdx];
    if (ref.stockActual < cantidad) {
      throw Exception('Stock insuficiente para $sku.');
    }

    refacciones[rIdx] = ref.copyWith(stockActual: ref.stockActual - cantidad);
    consumosPorOrden.putIfAbsent(idOrden, () => []);
    consumosPorOrden[idOrden]!.add(
      ConsumoRefaccion(
        sku: sku,
        nombre: nombre,
        cantidad: cantidad,
        precioUnitario: precioUnitario,
        tipo: 'consumo_real',
      ),
    );

    _registrarMovimientoKardex(
      sku: sku,
      tipo: TipoMovimientoInventario.salidaOt,
      cantidad: -cantidad,
      costoUnitario: ref.precioCosto,
      referenciaTipo: 'consumo_ot',
      referenciaId: idOrden,
      idUsuario: currentUser?.id,
    );
  }

  void confirmarSalidaPorOrden(String idOrden) {
    final reservas = reservasPorOrden.remove(idOrden) ?? [];
    for (final r in reservas) {
      final rIdx = refacciones.indexWhere((x) => x.sku == r.sku);
      if (rIdx < 0) continue;
      final ref = refacciones[rIdx];
      _registrarMovimientoKardex(
        sku: r.sku,
        tipo: TipoMovimientoInventario.salidaOt,
        cantidad: -r.cantidad,
        costoUnitario: ref.precioCosto,
        referenciaTipo: 'salida_ot',
        referenciaId: idOrden,
        idUsuario: currentUser?.id,
      );
      refacciones[rIdx] = ref.copyWith(
        stockActual: ref.stockActual - r.cantidad,
        stockReservado: ref.stockReservado - r.cantidad,
      );
    }
  }

  void _registrarMovimientoKardex({
    required String sku,
    required TipoMovimientoInventario tipo,
    required int cantidad,
    double? costoUnitario,
    required String referenciaTipo,
    required String referenciaId,
    String? idUsuario,
  }) {
    movimientosInventario.insert(
      0,
      MovimientoInventario(
        id: _uuid.v4(),
        sku: sku,
        tipo: tipo,
        cantidad: cantidad,
        costoUnitario: costoUnitario,
        referenciaTipo: referenciaTipo,
        referenciaId: referenciaId,
        idUsuario: idUsuario,
        createdAt: DateTime.now(),
      ),
    );
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
    final ajusteId = _uuid.v4();
    ajustesInventario.add(
      AjusteInventario(
        id: ajusteId,
        sku: sku,
        cantidad: cantidadAjuste,
        justificacion: justificacion,
        fecha: DateTime.now(),
        idUsuario: requireUserId(),
      ),
    );
    _registrarMovimientoKardex(
      sku: sku,
      tipo: TipoMovimientoInventario.ajuste,
      cantidad: cantidadAjuste,
      referenciaTipo: 'ajuste_inventario',
      referenciaId: ajusteId,
      idUsuario: requireUserId(),
    );
  }

  void registrarPago({
    required String idOrden,
    required double monto,
    required MetodoPago metodoPago,
  }) {
    final idx = ordenes.indexWhere((o) => o.id == idOrden);
    final orden = ordenes[idx];
    if (monto <= 0) throw Exception('Monto inválido.');

    final pagosActivos = pagos
        .where((p) => p.idOrden == idOrden && !p.esReversion)
        .fold<double>(0, (s, p) => s + p.monto);
    if (pagosActivos + monto > orden.saldoPendiente + 0.01) {
      throw Exception('El pago excede el saldo pendiente.');
    }

    pagos.add(
      Pago(
        id: _uuid.v4(),
        idOrden: idOrden,
        monto: monto,
        metodoPago: metodoPago,
        fechaPago: DateTime.now(),
      ),
    );

    final nuevoSaldo = orden.saldoPendiente - monto;
    var nuevoEstado = orden.estado;
    if (nuevoSaldo <= 0.01) {
      nuevoEstado = EstadoOrdenTrabajo.pagado;
      _registrarHistorial(idOrden, orden.estado, nuevoEstado, requireUserId());

      // Comisión solo sobre mano de obra (§5.5)
      if (orden.idMecanico != null) {
        final manoObra = orden.horasFacturables * tarifaManoObraPorHora;
        comisiones.insert(
          0,
          Comision(
            id: _uuid.v4(),
            idOrden: idOrden,
            idMecanico: orden.idMecanico!,
            monto: manoObra * porcentajeComision,
            porcentajeAplicado: porcentajeComision,
            fechaGenerada: DateTime.now(),
          ),
        );
      }
    }

    _updateOrden(
      idx,
      orden.copyWith(
        saldoPendiente: nuevoSaldo.clamp(0, double.infinity),
        estado: nuevoEstado,
      ),
    );
  }

  void revertirPago(String idPago) {
    final pago = pagos.firstWhere((p) => p.id == idPago);
    if (pago.esReversion || pago.monto <= 0) {
      throw Exception('No se puede revertir este pago.');
    }
    pagos.add(
      Pago(
        id: _uuid.v4(),
        idOrden: pago.idOrden,
        monto: -pago.monto,
        metodoPago: pago.metodoPago,
        idPagoRevertido: idPago,
        fechaPago: DateTime.now(),
      ),
    );

    final idx = ordenes.indexWhere((o) => o.id == pago.idOrden);
    final orden = ordenes[idx];
    var nuevoEstado = orden.estado;
    if (orden.estado == EstadoOrdenTrabajo.pagado) {
      nuevoEstado = EstadoOrdenTrabajo.terminado;
      comisiones.removeWhere((c) => c.idOrden == pago.idOrden);
    }
    _updateOrden(
      idx,
      orden.copyWith(
        saldoPendiente: orden.saldoPendiente + pago.monto,
        estado: nuevoEstado,
      ),
    );
  }

  Factura emitirFactura({
    required String idOrden,
    required String rfcReceptor,
  }) {
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
        .where(
          (p) =>
              !p.esReversion &&
              p.monto > 0 &&
              p.fechaPago.month == now.month &&
              p.fechaPago.year == now.year,
        )
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
    final entradaId = _uuid.v4();
    entradasInventario.insert(
      0,
      EntradaInventario(
        id: entradaId,
        sku: sku,
        cantidad: cantidad,
        costoUnitario: costoUnitario,
        idProveedor: idProveedor,
        fecha: DateTime.now(),
      ),
    );
    _registrarMovimientoKardex(
      sku: sku,
      tipo: TipoMovimientoInventario.entradaCompra,
      cantidad: cantidad,
      costoUnitario: costoUnitario,
      referenciaTipo: 'entrada_inventario',
      referenciaId: entradaId,
    );
  }

  void incrementarStock(String sku, int cantidad) {
    final rIdx = refacciones.indexWhere((r) => r.sku == sku);
    final ref = refacciones[rIdx];
    refacciones[rIdx] = ref.copyWith(stockActual: ref.stockActual + cantidad);
  }

  String registrarVentaPos(
    List<Map<String, dynamic>> items, {
    String metodoPago = 'efectivo',
  }) {
    final id = _uuid.v4();
    for (final item in items) {
      final sku = item['sku'] as String;
      final cantidad = item['cantidad'] as int;
      final precioUnitario = (item['precio_unitario'] as num).toDouble();
      final rIdx = refacciones.indexWhere((r) => r.sku == sku);
      final ref = refacciones[rIdx];
      if (ref.stockDisponible < cantidad) {
        throw Exception('Stock insuficiente para $sku.');
      }
      if (precioUnitario < ref.precioCosto) {
        throw Exception(
          'El precio de venta (\$${precioUnitario.toStringAsFixed(2)}) '
          'no puede ser menor al costo (\$${ref.precioCosto.toStringAsFixed(2)}) para $sku.',
        );
      }
      refacciones[rIdx] = ref.copyWith(stockActual: ref.stockActual - cantidad);
      final itemId = _uuid.v4();
      _registrarMovimientoKardex(
        sku: sku,
        tipo: TipoMovimientoInventario.salidaVentaPos,
        cantidad: -cantidad,
        costoUnitario: ref.precioCosto,
        referenciaTipo: 'venta_pos_item',
        referenciaId: itemId,
        idUsuario: requireUserId(),
      );
    }
    ventasPos.insert(
      0,
      VentaPos(
        id: id,
        items: items,
        fecha: DateTime.now(),
        idUsuario: requireUserId(),
        metodoPago: metodoPago,
      ),
    );
    return id;
  }

  double calcularEfectivoEsperadoTurno({String? idUsuario}) {
    ensureSeeded();
    final hoy = DateTime.now();
    return ventasPos
        .where((v) {
          if (v.devuelta || v.metodoPago != 'efectivo') return false;
          if (idUsuario != null && v.idUsuario != idUsuario) return false;
          return v.fecha.year == hoy.year &&
              v.fecha.month == hoy.month &&
              v.fecha.day == hoy.day;
        })
        .fold<double>(0, (sum, v) => sum + v.total);
  }

  CierreCajaRecord registrarCierreCajaCiego({required double efectivoContado}) {
    if (efectivoContado < 0) {
      throw Exception('El efectivo contado debe ser un monto válido.');
    }
    final userId = requireUserId();
    final esperado = calcularEfectivoEsperadoTurno(idUsuario: userId);
    final cierre = CierreCajaRecord(
      id: _uuid.v4(),
      idUsuario: userId,
      efectivoContado: efectivoContado,
      efectivoEsperado: esperado,
      diferencia: efectivoContado - esperado,
      fecha: DateTime.now(),
    );
    cierresCaja.insert(0, cierre);
    return cierre;
  }

  void devolverVentaPos(String idVenta) {
    ensureSeeded();
    final idx = ventasPos.indexWhere((v) => v.id == idVenta);
    final venta = ventasPos[idx];
    if (venta.devuelta) {
      throw Exception('Esta venta ya fue devuelta.');
    }
    for (final item in venta.items) {
      final sku = item['sku'] as String;
      final cantidad = item['cantidad'] as int;
      final rIdx = refacciones.indexWhere((r) => r.sku == sku);
      final ref = refacciones[rIdx];
      refacciones[rIdx] = ref.copyWith(stockActual: ref.stockActual + cantidad);
      _registrarMovimientoKardex(
        sku: sku,
        tipo: TipoMovimientoInventario.ajuste,
        cantidad: cantidad,
        costoUnitario: ref.precioCosto,
        referenciaTipo: 'devolucion_pos',
        referenciaId: idVenta,
        idUsuario: requireUserId(),
      );
    }
    ventasPos[idx] = VentaPos(
      id: venta.id,
      items: venta.items,
      fecha: venta.fecha,
      idUsuario: venta.idUsuario,
      metodoPago: venta.metodoPago,
      devuelta: true,
    );
  }

  List<Map<String, dynamic>> listOrdenesCompra() {
    ensureSeeded();
    return ordenesCompra
        .map(
          (oc) => {
            'id': oc.id,
            'id_proveedor': oc.idProveedor,
            'fecha_creacion': oc.fechaCreacion.toIso8601String(),
            'estado': oc.estado.name,
            'total': oc.total,
          },
        )
        .toList();
  }

  List<Map<String, dynamic>> detalleOrdenCompra(String idCompra) {
    return compraDetalle
        .where((d) => d.idCompra == idCompra)
        .map(
          (d) => {
            'sku': d.skuRefaccion,
            'cantidad': d.cantidad,
            'precio_compra': d.precioCompra,
          },
        )
        .toList();
  }

  String subirEvidencia({
    required String idOrden,
    required Uint8List bytes,
    required String nombreArchivo,
    required String etapa,
    required String subidaPor,
  }) {
    final path =
        '$idOrden/${DateTime.now().millisecondsSinceEpoch}_$nombreArchivo';
    evidencias.add(
      EvidenciaOt(
        id: _uuid.v4(),
        idOrden: idOrden,
        storagePath: path,
        etapa: etapa,
        subidaPor: subidaPor,
        bytes: bytes,
      ),
    );
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

class ConsumoRefaccion {
  final String sku;
  final String nombre;
  final int cantidad;
  final double precioUnitario;
  final String tipo;

  ConsumoRefaccion({
    required this.sku,
    required this.nombre,
    required this.cantidad,
    required this.precioUnitario,
    required this.tipo,
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
  final bool devuelta;

  VentaPos({
    required this.id,
    required this.items,
    required this.fecha,
    required this.idUsuario,
    this.metodoPago = 'efectivo',
    this.devuelta = false,
  });

  double get total => items.fold<double>(
    0,
    (sum, i) =>
        sum +
        (i['cantidad'] as int) * ((i['precio_unitario'] as num).toDouble()),
  );
}

class CierreCajaRecord {
  final String id;
  final String idUsuario;
  final double efectivoContado;
  final double efectivoEsperado;
  final double diferencia;
  final DateTime fecha;

  CierreCajaRecord({
    required this.id,
    required this.idUsuario,
    required this.efectivoContado,
    required this.efectivoEsperado,
    required this.diferencia,
    required this.fecha,
  });
}

class AjusteInventario {
  final String id;
  final String sku;
  final int cantidad;
  final String justificacion;
  final DateTime fecha;
  final String idUsuario;

  AjusteInventario({
    required this.id,
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

  EmpleadoInvitacionRecord copyWith({bool? activado}) =>
      EmpleadoInvitacionRecord(
        id: id,
        email: email,
        nombre: nombre,
        rol: rol,
        invitadoPorId: invitadoPorId,
        creadoEn: creadoEn,
        activado: activado ?? this.activado,
      );
}
