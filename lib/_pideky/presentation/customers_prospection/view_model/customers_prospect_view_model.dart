import 'package:get/get.dart';

class CustomersProspectionViewModel extends GetxController{

RxString _nameController = "".obs;
RxString _idController = "".obs;
RxString _phoneController = "".obs;
RxBool checkBoxYesController = false.obs;
RxBool checkBoxNoController = false.obs;

get nameController => _nameController.value;
get idController => _idController.value;
get phoneController => _phoneController.value;

set nameController(value) => _nameController.value = value;
set idController(value) => _idController.value = value;
set phoneController(value) => _phoneController.value = value;


}