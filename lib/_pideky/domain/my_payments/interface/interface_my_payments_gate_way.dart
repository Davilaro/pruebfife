import 'package:emart/_pideky/domain/my_payments/model/pagos_nequi_model.dart';

abstract class InterfaceMyPaymentsGateWay {
  Future<List<MyPaymentsModel>> consultarPagosNequi();
}
