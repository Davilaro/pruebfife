import 'package:emart/_pideky/domain/customers_prospection/use_cases/customers_prospection_use_cases.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomersProspectionViewModel extends GetxController {
  final customerProspectionServices = CustomerProspectionsUseCases();

  RxString _nameController = "".obs;
  RxString _idController = "".obs;
  RxString _phoneController = "".obs;
  RxBool checkBoxYesController = false.obs;
  RxBool checkBoxNoController = true.obs;

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  get nameController => _nameController.value;
  get idController => _idController.value;
  get phoneController => _phoneController.value;

  set nameController(value) => _nameController.value = value;
  set idController(value) => _idController.value = value;
  set phoneController(value) => _phoneController.value = value;

  Future sendProspectionRequest() async {
    final response = await customerProspectionServices.sendProspectionRequest(
        nombreCliente: nameController,
        cedula: idController,
        celular: phoneController,
        nevera: checkBoxYesController.value);
    if (response) {
      Get.back();
      Get.showSnackbar(GetSnackBar(
        backgroundColor: Colors.white,
        borderRadius: 20,
        margin: EdgeInsets.all(10),
        messageText: Row(
          children: [
            Image(
              image: AssetImage('assets/image/logo_login.png'),
              width: Get.width * 0.25,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text('¡Gracias por tu interés! Estamos procesando tu solicitud y te contactaremos pronto',
                  style: TextStyle(
                      color: ConstantesColores.azul_precio,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
        duration: Duration(seconds: 5),
        snackPosition: SnackPosition.BOTTOM,
      ));
    } else {
      Get.showSnackbar(GetSnackBar(
        backgroundColor: Colors.white,
        borderRadius: 20,
        margin: EdgeInsets.all(10),
        messageText: Row(
          children: [
            Image(
              image: AssetImage('assets/image/logo_login.png'),
              width: Get.width * 0.25,
            ),
            SizedBox(width: 10),
            Text('Algo salió mal, Reinténtalo mas tarde',
                style: TextStyle(
                    color: ConstantesColores.azul_precio,
                    fontWeight: FontWeight.bold))
          ],
        ),
        duration: Duration(seconds: 5),
        snackPosition: SnackPosition.BOTTOM,
      ));
    }
  }

  String? validateFields(String value) {
    if (value.isEmpty) {
      return 'Campo requerido';
    }
    return null;
  }
}
