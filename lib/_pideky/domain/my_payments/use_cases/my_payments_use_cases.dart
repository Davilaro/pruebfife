import 'package:emart/_pideky/domain/my_payments/interface/interface_my_payments_gate_way.dart';
import 'package:emart/_pideky/domain/my_payments/model/pagos_nequi_model.dart';

class MyPaymentsUseCases {
  final InterfaceMyPaymentsGateWay pagosNequiRepository;

  MyPaymentsUseCases(this.pagosNequiRepository);

  Future<List<MyPaymentsModel>> consultarPagosNequi() async =>
      await pagosNequiRepository.consultarPagosNequi();
}
