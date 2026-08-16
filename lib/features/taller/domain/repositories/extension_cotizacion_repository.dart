import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/extension_cotizacion.dart';

abstract class ExtensionCotizacionRepository {
  Future<Either<Failure, List<ExtensionCotizacion>>> listarPorOrden(
    String idOrden,
  );

  Future<Either<Failure, ExtensionCotizacion>> solicitar({
    required String idOrden,
    required String descripcion,
    required double montoAdicional,
  });

  Future<Either<Failure, ExtensionCotizacion>> aprobar(String idExtension);
}
