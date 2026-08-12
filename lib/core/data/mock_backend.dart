import '../config/app_config.dart';
import 'mock/mock_data_store.dart';

/// Acceso centralizado al backend mock.
class MockBackend {
  MockBackend._();

  static final store = MockDataStore.instance;

  static void initialize() {
    if (AppConfig.useMockBackend) {
      store.ensureSeeded();
    }
  }
}
