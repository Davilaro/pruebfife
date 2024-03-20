import 'package:emart/_pideky/domain/suggested_order/model/suggested_order_model.dart';

abstract class IPedidoSugerido {
  Future<List<SuggestedOrderModel>> obtenerPedidoSugerido();
}
