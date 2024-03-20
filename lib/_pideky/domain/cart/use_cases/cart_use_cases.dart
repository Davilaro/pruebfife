
import 'package:emart/_pideky/domain/cart/interface/interface_cart_gate_way.dart';
import 'package:emart/_pideky/infrastructure/cart/cart_services.dart';

class CartUseCases {
  final InterfaceCartGateWay _carGateWay = CartServices();

  Future sendOrder () async => await _carGateWay.sendOrder();
}