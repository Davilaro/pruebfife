import 'package:emart/_pideky/domain/delivery_conditions/interface/interface_delivery_conditions_gate_way.dart';
import 'package:emart/_pideky/domain/delivery_conditions/model/condicionEntrega.dart';

class CondicionEntregaUseCases {
  final InterfaceDeliveryConditionsGateWay condicionEntregaRepository;

  CondicionEntregaUseCases(this.condicionEntregaRepository);

  Future<List<CondicionEntrega>> consultarCondicionEntrega() {
    return condicionEntregaRepository.consultarCondicionEntrega();
  }
}
