import 'package:erp_flutter/core/data/mock/mock_data_store.dart';
import 'package:erp_flutter/core/data/mock_backend.dart';
import 'package:erp_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pruebas de UI sobre backend mock (sin credenciales reales de Supabase).
void main() {
  setUp(() {
    MockDataStore.instance.resetForTesting();
    MockBackend.initialize();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: ErpTallerApp()));
    await tester.pumpAndSettle();
  }

  Future<void> loginDemoAdmin(WidgetTester tester) async {
    if (find.text('Órdenes de Trabajo').evaluate().isNotEmpty) return;

    expect(find.text('Iniciar sesión'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Iniciar sesión'));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.text('Órdenes de Trabajo'), findsOneWidget);
  }

  testWidgets('login demo admin muestra listado de órdenes', (tester) async {
    await pumpApp(tester);
    await loginDemoAdmin(tester);
    expect(find.text('Nueva orden'), findsOneWidget);
  });

  testWidgets('admin ve drawer con finanzas y personal', (tester) async {
    await pumpApp(tester);
    await loginDemoAdmin(tester);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.text('Finanzas'), findsOneWidget);
    expect(find.text('Compras'), findsOneWidget);
    expect(find.text('Gestión de Personal'), findsOneWidget);
  });

  testWidgets('navegación a inventario lista refacciones demo', (tester) async {
    await pumpApp(tester);
    await loginDemoAdmin(tester);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Inventario'));
    await tester.pumpAndSettle();

    expect(find.text('Aceite 10W40'), findsOneWidget);
    expect(find.text('Pastillas de freno'), findsOneWidget);
  });
}
