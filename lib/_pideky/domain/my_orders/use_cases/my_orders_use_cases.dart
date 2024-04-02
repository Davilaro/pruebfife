import 'package:emart/_pideky/domain/my_orders/interface/interface_mi_orders_gate_way.dart';
import 'package:emart/_pideky/domain/my_orders/model/historical_model.dart';
import 'package:emart/_pideky/domain/my_orders/model/order_tracking.dart';
import 'package:emart/src/modelos/pedido.dart';

class MyOrdersUseCases {
  final InterfaceMyOrdersGateWay misPedidosRepository;

  MyOrdersUseCases(this.misPedidosRepository);

  Future<List<HistoricalModel>> consultarHistoricos(
          String filtro, String fechaInicio, String fechaFin) =>
      misPedidosRepository.consultarHistoricos(filtro, fechaInicio, fechaFin);

  Future<List<HistoricalModel>> consultarGrupoHistorico(String numeroDoc) =>
      misPedidosRepository.consultarGrupoHistorico(numeroDoc);

  Future<List<HistoricalModel>> consultarDetalleGrupoHistorico(
          String numeroDoc, String fabricante) =>
      misPedidosRepository.consultarDetalleGrupoHistorico(
          numeroDoc, fabricante);

  Future<List<OrderTracking>> consultarSeguimientoPedido(
          String filtro, String fechaInicio, String fechaFin) =>
      misPedidosRepository.consultarSeguimientoPedido(
          filtro, fechaInicio, fechaFin);

  Future<List<OrderTracking>> consultarGrupoSeguimientoPedido(
          String numeroDoc, int tipo) =>
      misPedidosRepository.consultarGrupoSeguimientoPedido(numeroDoc, tipo);

  Future<void> guardarSeguimientoPedido(Pedido miPedido, String documento) =>
      misPedidosRepository.guardarSeguimientoPedido(miPedido, documento);

  Future<List<HistoricalModel>> consultarDetalleGrupo(
          String numeroDoc, String fabricante) =>
      misPedidosRepository.consultarDetalleGrupo(numeroDoc, fabricante);
}
