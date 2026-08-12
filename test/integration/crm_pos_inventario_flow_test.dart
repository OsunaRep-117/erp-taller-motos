import 'package:dartz/dartz.dart';
import 'package:erp_flutter/features/pos/domain/entities/item_carrito.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/mock_integration_harness.dart';

void main() {
  late MockIntegrationHarness h;

  setUp(() => h = MockIntegrationHarness());

  test('flujo CRM: crear cliente particular', () async {
    await h.loginRecepcion();

    final result = await h.crearCliente(
      nombreCompleto: 'Cliente Prueba Auto',
      telefono: '5550001122',
    );

    expect(result.isRight(), true);
    final cliente = result.getOrElse(() => throw StateError(''));
    expect(cliente.nombreCompleto, 'Cliente Prueba Auto');
    expect(cliente.esFlotilla, false);
  });

  test('flujo CRM: rechaza flotilla sin RFC', () async {
    await h.loginRecepcion();

    final result = await h.crearCliente(
      nombreCompleto: 'Flotilla Sin RFC',
      telefono: '5550003344',
      esFlotilla: true,
    );

    expect(result.isLeft(), true);
  });

  test('flujo POS: venta mostrador descuenta stock', () async {
    await h.loginRecepcion();

    const sku = 'ACE-001';
    final antes = await h.inventarioRepo.obtenerPorSku(sku);
    final stockAntes = antes.getOrElse(() => throw StateError('')).stockActual;

    final venta = await h.registrarVenta([
      const ItemCarrito(sku: sku, nombre: 'Aceite 10W40', cantidad: 1, precioUnitario: 150),
    ], metodoPago: 'efectivo');

    expect(venta.isRight(), true);

    final despues = await h.inventarioRepo.obtenerPorSku(sku);
    final stockDespues = despues.getOrElse(() => throw StateError('')).stockActual;
    expect(stockDespues, stockAntes - 1);
  });

  test('flujo inventario: admin ajusta stock con justificación', () async {
    final admin = await h.loginAdmin();

    const sku = 'CAD-001';
    final antes = await h.inventarioRepo.obtenerPorSku(sku);
    final stockAntes = antes.getOrElse(() => throw StateError('')).stockActual;

    final result = await h.ajustarInventario(
      usuarioActual: admin,
      sku: sku,
      cantidadAjuste: 2,
      justificacion: 'Conteo físico de prueba',
    );

    expect(result, const Right(null));

    final despues = await h.inventarioRepo.obtenerPorSku(sku);
    expect(despues.getOrElse(() => throw StateError('')).stockActual, stockAntes + 2);
  });

  test('flujo compras: registrar entrada incrementa stock', () async {
    await h.loginAdmin();

    const sku = 'ACE-001';
    final antes = await h.inventarioRepo.obtenerPorSku(sku);
    final stockAntes = antes.getOrElse(() => throw StateError('')).stockActual;

    final result = await h.comprasRepo.recibirMercancia(
      sku: sku,
      cantidad: 5,
      costoUnitario: 80,
      idProveedor: 'prov-001',
    );

    expect(result.isRight(), true);

    final despues = await h.inventarioRepo.obtenerPorSku(sku);
    expect(despues.getOrElse(() => throw StateError('')).stockActual, stockAntes + 5);
  });
}
