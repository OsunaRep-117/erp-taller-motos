import '../../domain/entities/item_carrito.dart';
import '../../domain/entities/resultado_cierre_caja.dart';

abstract class PosDataSource {
  Future<List<Map<String, dynamic>>> listarRefaccionesPos();
  Future<String> registrarVenta(List<ItemCarrito> items, {String metodoPago});
  Future<List<Map<String, dynamic>>> listarVentas();
  Future<ResultadoCierreCaja> registrarCierreCajaCiego({
    required double efectivoContado,
  });
  Future<void> devolverVenta({
    required String idVenta,
    required String pinAutorizacion,
  });
}
