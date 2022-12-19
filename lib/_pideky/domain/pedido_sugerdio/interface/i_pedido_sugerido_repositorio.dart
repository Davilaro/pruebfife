import 'package:emart/_pideky/domain/pedido_sugerdio/model/pedido_sugerido.dart';

abstract class IPedidoSugerido {
  Future<List<PedidoSugeridoModel>> obtenerPedidoSugerido();
}
