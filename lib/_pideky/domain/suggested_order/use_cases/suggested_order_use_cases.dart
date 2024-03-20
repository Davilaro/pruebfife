import 'package:emart/_pideky/domain/suggested_order/interface/interface_suggested_order_gate_way.dart';
import 'package:emart/_pideky/domain/suggested_order/model/suggested_order_model.dart';

class SuggestedOrderUseCases {
  final IPedidoSugerido pedidoSugerido;

  SuggestedOrderUseCases(this.pedidoSugerido);

  Future<List<SuggestedOrderModel>> obtenerPedidoSugerido() {
    return pedidoSugerido.obtenerPedidoSugerido();
  }
}
