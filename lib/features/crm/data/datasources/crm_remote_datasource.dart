import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/cliente.dart';
import '../../domain/entities/motocicleta.dart';
import 'crm_datasource.dart';

class CrmRemoteDatasource implements CrmDataSource {
  final SupabaseClient client;
  const CrmRemoteDatasource(this.client);

  Future<List<Cliente>> listarClientes() async {
    final data = await client.from('clientes').select().order('nombre_completo');
    return data.map(_clienteFromJson).toList();
  }

  Future<Cliente> obtenerClientePorId(String id) async {
    final data = await client.from('clientes').select().eq('id', id).single();
    return _clienteFromJson(data);
  }

  Future<Cliente> crearCliente({
    required String nombreCompleto,
    required String telefono,
    String? rfc,
    required bool esFlotilla,
  }) async {
    final data = await client
        .from('clientes')
        .insert({
          'nombre_completo': nombreCompleto,
          'telefono': telefono,
          'rfc': rfc,
          'es_flotilla': esFlotilla,
        })
        .select()
        .single();
    return _clienteFromJson(data);
  }

  @override
  Future<Cliente> actualizarCliente(Cliente cliente) async {
    final data = await client
        .from('clientes')
        .update({
          'nombre_completo': cliente.nombreCompleto,
          'telefono': cliente.telefono,
          'rfc': cliente.rfc,
          'es_flotilla': cliente.esFlotilla,
          'limite_credito': cliente.limiteCredito,
        })
        .eq('id', cliente.id)
        .select()
        .single();
    return _clienteFromJson(data);
  }

  Future<List<Motocicleta>> listarMotocicletas() async {
    final data = await client.from('motocicletas').select().order('placa');
    return data.map(_motoFromJson).toList();
  }

  Future<Motocicleta> obtenerMotocicletaPorVin(String vin) async {
    final data = await client.from('motocicletas').select().eq('vin', vin).single();
    return _motoFromJson(data);
  }

  @override
  Future<Motocicleta> actualizarMotocicleta({
    required String vin,
    required String placa,
    required String marca,
    required String modelo,
    required int anio,
    required String idCliente,
  }) async {
    final data = await client
        .from('motocicletas')
        .update({
          'placa': placa,
          'marca': marca,
          'modelo': modelo,
          'anio': anio,
          'id_cliente': idCliente,
        })
        .eq('vin', vin)
        .select()
        .single();
    return _motoFromJson(data);
  }

  Future<Motocicleta> crearMotocicleta({
    required String vin,
    required String placa,
    required String marca,
    required String modelo,
    required int anio,
    required String idCliente,
  }) async {
    final data = await client
        .from('motocicletas')
        .insert({
          'vin': vin,
          'placa': placa,
          'marca': marca,
          'modelo': modelo,
          'anio': anio,
          'id_cliente': idCliente,
        })
        .select()
        .single();
    return _motoFromJson(data);
  }

  Cliente _clienteFromJson(Map<String, dynamic> json) => Cliente(
        id: json['id'] as String,
        nombreCompleto: json['nombre_completo'] as String,
        telefono: json['telefono'] as String,
        rfc: json['rfc'] as String?,
        limiteCredito: (json['limite_credito'] as num?)?.toDouble() ?? 0,
        esFlotilla: json['es_flotilla'] as bool? ?? false,
      );

  Motocicleta _motoFromJson(Map<String, dynamic> json) => Motocicleta(
        vin: json['vin'] as String,
        placa: json['placa'] as String,
        marca: json['marca'] as String,
        modelo: json['modelo'] as String,
        anio: json['anio'] as int,
        idCliente: json['id_cliente'] as String,
      );
}
