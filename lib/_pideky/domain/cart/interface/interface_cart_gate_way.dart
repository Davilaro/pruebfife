import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/src/modelos/pedido.dart';

abstract class InterfaceCartGateWay {
  Future sendOrder(List<Pedido> listaPedido, String usuarioLogin,
      String fechaPedido, String numDoc, CartViewModel cartProvider);
}