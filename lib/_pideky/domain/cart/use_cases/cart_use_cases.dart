import 'package:emart/_pideky/domain/cart/interface/interface_cart_gate_way.dart';
import 'package:emart/_pideky/infrastructure/cart/cart_services.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/src/modelos/pedido.dart';

class CartUseCases {
  final InterfaceCartGateWay _carGateWay = CartServices();

  Future sendOrder(
          List<Pedido> listaPedido,
          String usuarioLogin,
          String fechaPedido,
          String numDoc,
          CartViewModel cartProvider) async =>
      await _carGateWay.sendOrder(
          listaPedido, usuarioLogin, fechaPedido, numDoc, cartProvider);
}
