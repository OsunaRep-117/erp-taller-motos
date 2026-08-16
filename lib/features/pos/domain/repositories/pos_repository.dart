import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/item_carrito.dart';
import '../entities/resultado_cierre_caja.dart';

abstract class PosRepository {
  Future<Either<Failure, String>> registrarVenta(
    List<ItemCarrito> items, {
    String metodoPago = 'efectivo',
  });

  /// §5.3 — el cajero ingresa el conteo antes de ver el esperado.
  Future<Either<Failure, ResultadoCierreCaja>> registrarCierreCajaCiego({
    required double efectivoContado,
  });

  /// §5.3 — devolución con ticket + PIN supervisor.
  Future<Either<Failure, void>> devolverVenta({
    required String idVenta,
    required String pinAutorizacion,
  });
}
