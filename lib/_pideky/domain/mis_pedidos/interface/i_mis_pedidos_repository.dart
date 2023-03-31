import 'package:emart/_pideky/domain/mis_pedidos/model/historico.dart';
import 'package:emart/_pideky/domain/mis_pedidos/model/seguimiento_pedido.dart';
import 'package:emart/src/modelos/pedido.dart';

abstract class IMisPedidosRepository {
  Future<List<Historico>> consultarHistoricos(
      String filtro, String fechaInicio, String fechaFin);

  Future<List<Historico>> consultarGrupoHistorico(String numeroDoc);

  Future<List<Historico>> consultarDetalleGrupoHistorico(
      String numeroDoc, String fabricante);

  Future<List<SeguimientoPedido>> consultarSeguimientoPedido(
      String filtro, String fechaInicio, String fechaFin);

  Future<List<SeguimientoPedido>> consultarGrupoSeguimientoPedido(
      String numeroDoc);

  Future<void> guardarSeguimientoPedido(Pedido miPedido, String documento);

  Future<List<Historico>> consultarDetalleGrupo(
      String numeroDoc, String fabricante);
}
