import 'package:emart/_pideky/domain/my_orders/model/historical_model.dart';
import 'package:emart/_pideky/domain/my_orders/model/order_tracking.dart';
import 'package:emart/src/modelos/pedido.dart';

abstract class InterfaceMyOrdersGateWay {
  Future<List<HistoricalModel>> consultarHistoricos(
      String filtro, String fechaInicio, String fechaFin);

  Future<List<HistoricalModel>> consultarGrupoHistorico(String numeroDoc);

  Future<List<HistoricalModel>> consultarDetalleGrupoHistorico(
      String numeroDoc, String fabricante);

  Future<List<OrderTracking>> consultarSeguimientoPedido(
      String filtro, String fechaInicio, String fechaFin);

  Future<List<OrderTracking>> consultarGrupoSeguimientoPedido(
      String numeroDoc, int tipo);

  Future<void> guardarSeguimientoPedido(Pedido miPedido, String documento);

  Future<List<HistoricalModel>> consultarDetalleGrupo(
      String numeroDoc, String fabricante);
}
