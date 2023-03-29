import 'package:emart/_pideky/domain/mis_pedidos/model/historico.dart';

abstract class IMisPedidosRepository {
  Future<List<Historico>> consultarHistoricos(
      String filtro, String fechaInicio, String fechaFin);

  Future<List<Historico>> consultarGrupoHistorico(String numeroDoc);

  Future<List<Historico>> consultarDetalleGrupoHistorico(
      String numeroDoc, String fabricante);
}
