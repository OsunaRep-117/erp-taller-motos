import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/cita.dart';
import '../models/cita_model.dart';
import 'citas_datasource.dart';

class CitasRemoteDatasource implements CitasDataSource {
  final SupabaseClient client;
  const CitasRemoteDatasource(this.client);

  @override
  Future<List<Cita>> listarCitas() async {
    final data = await client.from('citas').select().order('fecha_cita');
    return (data as List)
        .map((row) => CitaModel.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Cita> agendarCita({
    required String idCliente,
    required DateTime fechaCita,
    required String motivo,
    String? idMoto,
  }) async {
    final row = await client.rpc(
      'agendar_cita',
      params: {
        'p_id_cliente': idCliente,
        'p_fecha_cita': fechaCita.toIso8601String(),
        'p_motivo': motivo,
        'p_id_moto': idMoto,
      },
    );
    return CitaModel.fromJson(row as Map<String, dynamic>);
  }

  @override
  Future<Cita> confirmarCita(String idCita) async {
    final row = await client.rpc(
      'confirmar_cita',
      params: {'p_id_cita': idCita},
    );
    return CitaModel.fromJson(row as Map<String, dynamic>);
  }

  @override
  Future<Cita> cancelarCita(String idCita) async {
    final row = await client.rpc(
      'cancelar_cita',
      params: {'p_id_cita': idCita},
    );
    return CitaModel.fromJson(row as Map<String, dynamic>);
  }

  @override
  Future<Cita> completarCita({
    required String idCita,
    required String idMoto,
    required String idOrden,
  }) async {
    final row = await client.rpc(
      'completar_cita',
      params: {'p_id_cita': idCita, 'p_id_moto': idMoto, 'p_id_orden': idOrden},
    );
    return CitaModel.fromJson(row as Map<String, dynamic>);
  }
}
