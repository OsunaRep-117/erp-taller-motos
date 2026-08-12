import 'package:flutter/services.dart';

Future<String?> readEnvFile() async {
  try {
    return await rootBundle.loadString('.env');
  } catch (_) {
    return null;
  }
}
