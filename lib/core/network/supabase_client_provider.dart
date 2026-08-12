import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_client_provider.g.dart';

/// Punto único de acceso al cliente de Supabase.
/// Cualquier datasource de cualquier feature debe pedir el cliente
/// a través de este provider, nunca instanciarlo directamente.
@riverpod
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  return Supabase.instance.client;
}
