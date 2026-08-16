import 'package:erp_flutter/core/config/app_config.dart';
import 'package:erp_flutter/features/compras/domain/entities/orden_compra.dart';
import 'package:erp_flutter/features/compras/domain/usecases/orden_compra_usecases.dart';
import 'package:erp_flutter/features/pos/domain/entities/item_carrito.dart';
import 'package:erp_flutter/features/pos/domain/usecases/cierre_caja_ciego.dart';
import 'package:erp_flutter/features/pos/domain/usecases/devolver_venta_pos.dart';
import 'package:erp_flutter/features/pos/domain/usecases/registrar_venta.dart';
import '../helpers/mock_integration_harness.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MockIntegrationHarness h;
  late RegistrarVenta registrarVenta;
  late CierreCajaCiego cierreCaja;
  late DevolverVentaPos devolverVenta;
  late CrearOrdenCompra crearOc;
  late AprobarOrdenCompra aprobarOc;
  late RecibirOrdenCompra recibirOc;

  setUp(() {
    h = MockIntegrationHarness();
    registrarVenta = RegistrarVenta(h.posRepo);
    cierreCaja = CierreCajaCiego(h.posRepo);
    devolverVenta = DevolverVentaPos(h.posRepo);
    crearOc = CrearOrdenCompra(h.comprasRepo);
    aprobarOc = AprobarOrdenCompra(h.comprasRepo);
    recibirOc = RecibirOrdenCompra(h.comprasRepo);
  });

  test('cierre ciego revela diferencia vs efectivo esperado', () async {
    await h.loginRecepcion();
    await registrarVenta([
      const ItemCarrito(
        sku: 'ACE-001',
        nombre: 'Aceite',
        cantidad: 2,
        precioUnitario: 150,
      ),
    ], metodoPago: 'efectivo');

    final cierre = await cierreCaja(efectivoContado: 300);
    cierre.fold((f) => fail(f.mensaje), (r) {
      expect(r.efectivoEsperado, 300);
      expect(r.diferencia, 0);
    });
  });

  test('devolución POS con PIN reingresa stock', () async {
    await h.loginRecepcion();
    final stockAntes = h.store.refacciones
        .firstWhere((r) => r.sku == 'ACE-001')
        .stockActual;

    final ventaId = (await registrarVenta([
      const ItemCarrito(
        sku: 'ACE-001',
        nombre: 'Aceite',
        cantidad: 1,
        precioUnitario: 150,
      ),
    ])).fold((f) => throw Exception(f.mensaje), (id) => id);

    final dev = await devolverVenta(
      idVenta: ventaId,
      pinAutorizacion: AppConfig.posAutorizacionPin,
    );
    expect(dev.isRight(), true);

    final stockDespues = h.store.refacciones
        .firstWhere((r) => r.sku == 'ACE-001')
        .stockActual;
    expect(stockDespues, stockAntes);
  });

  test('flujo OC borrador → aprobada → recibida', () async {
    await h.loginAdmin();
    h.store.ensureSeeded();
    final prov = h.store.proveedores.first.id;
    final stockAntes = h.store.refacciones
        .firstWhere((r) => r.sku == 'ACE-001')
        .stockActual;

    final oc = (await crearOc(
      idProveedor: prov,
      items: [
        CompraDetalle(
          idCompra: '',
          skuRefaccion: 'ACE-001',
          cantidad: 5,
          precioCompra: 80,
        ),
      ],
    )).fold((f) => throw Exception(f.mensaje), (o) => o);

    expect(oc.estado, EstadoOrdenCompra.borrador);

    await aprobarOc(oc.id);
    await recibirOc(oc.id);

    final stockDespues = h.store.refacciones
        .firstWhere((r) => r.sku == 'ACE-001')
        .stockActual;
    expect(stockDespues, stockAntes + 5);
  });
}
