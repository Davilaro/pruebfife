import 'package:emart/_pideky/domain/delivery_conditions/model/condicionEntrega.dart';

abstract class InterfaceDeliveryConditionsGateWay {
  Future<List<CondicionEntrega>> consultarCondicionEntrega();
}
