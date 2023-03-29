import 'package:emart/_pideky/domain/mis_pedidos/interface/i_mis_pedidos_repository.dart';
import 'package:emart/_pideky/domain/mis_pedidos/model/historico.dart';

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
}
