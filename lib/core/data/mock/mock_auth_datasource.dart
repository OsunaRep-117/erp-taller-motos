import 'dart:async';

import '../../../features/auth/domain/entities/usuario.dart';
import 'mock_data_store.dart';

/// Auth en memoria para desarrollo sin Supabase.
class MockAuthDatasource {
  final MockDataStore store;
  const MockAuthDatasource(this.store);

  Future<Usuario> iniciarSesion({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    store.ensureSeeded();
    final user = store.login(email, password);
    if (user == null) throw Exception('No se pudo iniciar sesión.');
    return user;
  }

  Future<Usuario> iniciarSesionConGoogle() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    store.ensureSeeded();
    final user = store.loginWithGoogle();
    if (user == null) throw Exception('No se pudo iniciar sesión con Google.');
    return user;
  }

  Future<void> cerrarSesion() async {
    store.logout();
  }

  Future<Usuario?> obtenerUsuarioActual() async => store.currentUser;

  Stream<Usuario?> observarEstadoAuth() {
    store.ensureSeeded();
    return Stream.multi((controller) {
      controller.add(store.currentUser);
      final sub = store.authStream.listen(
        controller.add,
        onError: controller.addError,
      );
      controller.onCancel = sub.cancel;
    });
  }
}
