import 'dart:convert';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/data/mock/mock_taller_datasource.dart';
import '../../../../core/data/mock_backend.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/evidencia_ot_remote_datasource.dart';
import '../../data/repositories/evidencia_ot_repository_impl.dart';
import '../../domain/entities/evidencia_ot.dart';
import '../../domain/repositories/evidencia_ot_repository.dart';
import '../../domain/usecases/subir_evidencia_ot.dart';

part 'crear_orden_providers.g.dart';

@riverpod
EvidenciaOtRemoteDatasource evidenciaOtRemoteDatasource(
  EvidenciaOtRemoteDatasourceRef ref,
) {
  return EvidenciaOtRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
MockEvidenciaOtDatasource evidenciaOtMockDatasource(
  EvidenciaOtMockDatasourceRef ref,
) {
  return MockEvidenciaOtDatasource(MockBackend.store);
}

@riverpod
EvidenciaOtRepository evidenciaOtRepository(EvidenciaOtRepositoryRef ref) {
  if (AppConfig.useMockBackend) {
    return _MockEvidenciaOtRepository(
      ref.watch(evidenciaOtMockDatasourceProvider),
      ref,
    );
  }
  final datasource = ref.watch(evidenciaOtRemoteDatasourceProvider);
  return EvidenciaOtRepositoryImpl(
    datasource,
    () => ref.read(supabaseClientProvider).auth.currentUser!.id,
  );
}

@riverpod
SubirEvidenciaOT subirEvidenciaOtUseCase(SubirEvidenciaOtUseCaseRef ref) {
  return SubirEvidenciaOT(ref.watch(evidenciaOtRepositoryProvider));
}

@riverpod
Future<List<EvidenciaOt>> evidenciasPorOrden(
  EvidenciasPorOrdenRef ref,
  String idOrden,
) async {
  final result = await ref
      .watch(evidenciaOtRepositoryProvider)
      .listarPorOrden(idOrden);
  return result.fold((f) => throw Exception(f.mensaje), (r) => r);
}

class _MockEvidenciaOtRepository implements EvidenciaOtRepository {
  final MockEvidenciaOtDatasource mock;
  final EvidenciaOtRepositoryRef ref;

  _MockEvidenciaOtRepository(this.mock, this.ref);

  @override
  Future<Either<Failure, String>> subirEvidencia({
    required String idOrden,
    required Uint8List bytes,
    required String nombreArchivo,
    required String etapa,
  }) async {
    try {
      final user = await ref.read(authStateProvider.future);
      final path = await mock.subirEvidencia(
        idOrden: idOrden,
        bytes: bytes,
        nombreArchivo: nombreArchivo,
        etapa: etapa,
        subidaPor: user?.id ?? 'demo',
      );
      return Right(path);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EvidenciaOt>>> listarPorOrden(
    String idOrden,
  ) async {
    try {
      final lista = await mock.listarPorOrden(idOrden);
      return Right(
        lista
            .map(
              (e) => EvidenciaOt(
                id: e.id,
                idOrden: e.idOrden,
                storagePath: e.storagePath,
                etapa: e.etapa,
                subidaPor: e.subidaPor,
                urlFirmada: 'data:image/jpeg;base64,${base64Encode(e.bytes)}',
                fechaSubida: DateTime.now(),
              ),
            )
            .toList(),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
