import 'package:erp_flutter/features/inventario/domain/entities/movimiento_inventario.dart';
import 'package:erp_flutter/features/pos/domain/entities/item_carrito.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/mock_integration_harness.dart';

/// Fase 1: estructuras de esquema maestro disponibles en mock + kardex automático.
void main() {
  late MockIntegrationHarness h;

  setUp(() => h = MockIntegrationHarness());

  test('MockDataStore expone tablas Fase 1 vacías al iniciar', () {
    expect(h.store.citas, isEmpty);
    expect(h.store.ordenesCompra, isEmpty);
    expect(h.store.compraDetalle, isEmpty);
    expect(h.store.extensionesCotizacion, isEmpty);
    expect(h.store.gastosOperativos, isEmpty);
    expect(h.store.movimientosInventario, isEmpty);
  });

  test('venta POS registra movimiento kardex salida_venta_pos', () async {
    await h.loginRecepcion();

    final antes = h.store.movimientosInventario.length;
    await h.registrarVenta([
      const ItemCarrito(
        sku: 'ACE-001',
        nombre: 'Aceite 10W40',
        cantidad: 1,
        precioUnitario: 150,
      ),
    ]);
    expect(h.store.movimientosInventario.length, antes + 1);
    expect(
      h.store.movimientosInventario.first.tipo,
      TipoMovimientoInventario.salidaVentaPos,
    );
    expect(h.store.movimientosInventario.first.cantidad, -1);
  });

  test(
    'entrada de inventario registra movimiento kardex entrada_compra',
    () async {
      await h.loginAdmin();

      final antes = h.store.movimientosInventario.length;
      h.store.registrarEntrada(
        sku: 'ACE-001',
        cantidad: 5,
        costoUnitario: 85,
        idProveedor: 'prov-001',
      );

      expect(h.store.movimientosInventario.length, antes + 1);
      expect(
        h.store.movimientosInventario.first.tipo,
        TipoMovimientoInventario.entradaCompra,
      );
      expect(h.store.movimientosInventario.first.cantidad, 5);
    },
  );

  test('ajuste manual registra movimiento kardex ajuste', () async {
    final admin = await h.loginAdmin();

    final antes = h.store.movimientosInventario.length;
    await h.ajustarInventario(
      usuarioActual: admin,
      sku: 'CAD-001',
      cantidadAjuste: 1,
      justificacion: 'Conteo físico demo',
    );

    expect(h.store.movimientosInventario.length, antes + 1);
    expect(
      h.store.movimientosInventario.first.tipo,
      TipoMovimientoInventario.ajuste,
    );
  });
}
