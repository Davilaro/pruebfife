import 'package:emart/_pideky/domain/pedido_sugerdio/interface/i_pedido_sugerido_repositorio.dart';
import 'package:emart/_pideky/domain/pedido_sugerdio/model/pedido_sugerido.dart';

class PedidoSugeridoServicio {
  final IPedidoSugerido pedidoSugerido;

  PedidoSugeridoServicio(this.pedidoSugerido);

  Future<List<PedidoSugeridoModel>> obtenerPedidoSugerido() {
    return pedidoSugerido.obtenerPedidoSugerido();
  }
}
