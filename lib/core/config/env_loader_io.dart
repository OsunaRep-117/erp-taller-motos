import 'dart:io';

import 'package:flutter/services.dart';

Future<String?> readEnvFile() async {
  // Android/iOS empaquetan .env como asset (pubspec.yaml).
  try {
    return await rootBundle.loadString('.env');
  } catch (_) {}

  // Desktop: leer del filesystem al correr desde la raíz del proyecto.
  try {
    final file = File('.env');
    if (!await file.exists()) return null;
    return await file.readAsString();
  } catch (_) {
    return null;
  }
}
