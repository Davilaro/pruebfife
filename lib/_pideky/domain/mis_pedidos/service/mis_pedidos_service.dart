import 'package:emart/_pideky/domain/mis_pedidos/interface/i_mis_pedidos_repository.dart';
import 'package:emart/_pideky/domain/mis_pedidos/model/historico.dart';
import 'package:emart/_pideky/domain/mis_pedidos/model/seguimiento_pedido.dart';
import 'package:emart/src/modelos/pedido.dart';

class MisPedidosService {
  final IMisPedidosRepository misPedidosRepository;

  MisPedidosService(this.misPedidosRepository);

  Future<List<Historico>> consultarHistoricos(
          String filtro, String fechaInicio, String fechaFin) =>
      misPedidosRepository.consultarHistoricos(filtro, fechaInicio, fechaFin);

  Future<List<Historico>> consultarGrupoHistorico(String numeroDoc) =>
      misPedidosRepository.consultarGrupoHistorico(numeroDoc);

  Future<List<Historico>> consultarDetalleGrupoHistorico(
          String numeroDoc, String fabricante) =>
      misPedidosRepository.consultarDetalleGrupoHistorico(
          numeroDoc, fabricante);

  Future<List<SeguimientoPedido>> consultarSeguimientoPedido(
          String filtro, String fechaInicio, String fechaFin) =>
      misPedidosRepository.consultarSeguimientoPedido(
          filtro, fechaInicio, fechaFin);

  Future<List<SeguimientoPedido>> consultarGrupoSeguimientoPedido(
          String numeroDoc) =>
      misPedidosRepository.consultarGrupoSeguimientoPedido(numeroDoc);

  Future<void> guardarSeguimientoPedido(Pedido miPedido, String documento) =>
      misPedidosRepository.guardarSeguimientoPedido(miPedido, documento);

  Future<List<Historico>> consultarDetalleGrupo(
          String numeroDoc, String fabricante) =>
      misPedidosRepository.consultarDetalleGrupo(numeroDoc, fabricante);
}
