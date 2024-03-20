import 'package:emart/_pideky/domain/customers_school/interface/interface_customers_school_gate_way.dart';
import 'package:emart/_pideky/infrastructure/customers_school/customer_school_services.dart';

class CustomersSchoolUseCases {
  final InterfaceCustomersSchoolGateWay _customersSchoolGateWay = CustomersSchoolServices();

  Future getVideo() async => await _customersSchoolGateWay.getVideo();
}