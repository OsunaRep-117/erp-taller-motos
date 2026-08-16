import 'env_loader_io.dart'
    if (dart.library.html) 'env_loader_web.dart'
    as platform;

/// Carga variables desde `.env` (filesystem en desktop/mobile, asset en web).
/// Las `--dart-define` siguen teniendo prioridad sobre el archivo.
class EnvLoader {
  static final Map<String, String> _vars = {};
  static bool _loaded = false;

  static Future<void> load() async {
    if (_loaded) return;
    _loaded = true;

    final content = await platform.readEnvFile();
    if (content == null) return;
    _parse(content);
  }

  static void _parse(String content) {
    for (final raw in content.split('\n')) {
      var line = raw.trim();
      if (line.isEmpty || line.startsWith('#')) continue;

      final eq = line.indexOf('=');
      if (eq <= 0) continue;

      var key = line.substring(0, eq).trim();
      var value = line.substring(eq + 1).trim();

      if ((value.startsWith('"') && value.endsWith('"')) ||
          (value.startsWith("'") && value.endsWith("'"))) {
        value = value.substring(1, value.length - 1);
      }

      _vars[key] = value;
    }
  }

  static String? get(String key) => _vars[key];
}
