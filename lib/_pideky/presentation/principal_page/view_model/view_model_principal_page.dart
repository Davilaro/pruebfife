import 'package:emart/_pideky/domain/customers_school/use_cases/customers_school_use_cases.dart';
import 'package:get/get.dart';

class ViewModelPrincipalPage extends GetxController {
  final CustomersSchoolUseCases customersSchool = CustomersSchoolUseCases();
  Object video = Object;

  Future getVideo() async {
    video = await customersSchool.getVideo();
  }
}
