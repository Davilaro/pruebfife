import 'package:emart/src/controllers/validations_forms.dart';
import 'package:emart/src/modelos/estado.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/servicios.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StateControllerRadioButtonsAndChecks extends GetxController {
  RxInt selectedPhoneNumberIndex = RxInt(-1);
  RxInt selectedClientCodeIndex = RxInt(-1);
  RxString selectedNumber = "".obs;

  bool get isPhoneNumberSelected => selectedPhoneNumberIndex.value != -1;

  void selectPhoneNumber(int index) {
    selectedPhoneNumberIndex.value = index;
  }

  bool get isClientCodeSelected => selectedClientCodeIndex.value != -1;

  void selectClientCode(int index) {
    selectedClientCodeIndex.value = index;
  }

  Future<bool> sendMsg() async {
    final Estado answer = await Servicies().enviarMS(selectedNumber.value);
    if (answer.estado == "OK") {
      return true;
    } else {
      return false;
    }
  }
}

class PhoneNumberSelection extends StatelessWidget {
  final StateControllerRadioButtonsAndChecks controller;
  final ValidationForms _validationForms = Get.find();

  PhoneNumberSelection({required this.controller});

  @override
  Widget build(BuildContext context) {
    _validationForms.getPhoneNumbers();
    final controller = Get.put(StateControllerRadioButtonsAndChecks());
    final List phoneNumbers = _validationForms.phoneNumbers;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      height: Get.height * 0.3,
      child: SingleChildScrollView(
        child: Column(
          children: phoneNumbers.asMap().entries.map((entry) {
            final index = entry.key;
            final phoneNumber = entry.value;
            final maskedPhoneNumber = '******${phoneNumber.substring(6)}';
            // final isSelected = controller.selectedPhoneNumberIndex.value == index;

            return Obx(
              () => RadioListTile<int>(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                dense: false,
                activeColor: ConstantesColores.azul_precio,
                title: Text(maskedPhoneNumber),
                value: index,
                groupValue: controller.selectedPhoneNumberIndex.value,
                onChanged: (value) {
                  controller.selectedNumber.value = phoneNumber;
                  controller.selectPhoneNumber(value!);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ClientCodeSelection extends StatelessWidget {
  final StateControllerRadioButtonsAndChecks controller;

  ClientCodeSelection({required this.controller});

  @override
  Widget build(BuildContext context) {
    final validationForm = Get.find<ValidationForms>();
    final controller = Get.put(StateControllerRadioButtonsAndChecks());

    return Container(
      height: Get.height * 0.25,
      child: SingleChildScrollView(
        child: Column(
          children: validationForm.incorrectCodes.asMap().entries.map((entry) {
            final index = entry.key;
            final selectedCode = entry.value;
            final maskedPhoneNumber = selectedCode;

            // final isSelected = controller.selectedPhoneNumberIndex.value == index;

            return Obx(
              () => RadioListTile<int>(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                dense: false,
                activeColor: ConstantesColores.azul_precio,
                title: Text(maskedPhoneNumber),
                value: index,
                groupValue: controller.selectedClientCodeIndex.value,
                onChanged: (value) {
                  validationForm.selectedCode.value = selectedCode;
                  controller.selectClientCode(value!);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class StateControllerRadioButtons extends GetxController {
  RxInt selectedPhoneNumberIndex = RxInt(-1);

  RxBool acceptTerms = false.obs;
  RxBool authorizeDataTreatment = false.obs;

  bool get isButtonEnabled => acceptTerms.value && authorizeDataTreatment.value;

  void toggleAcceptTerms() {
    acceptTerms.value = !acceptTerms.value;
  }

  void toggleAuthorizeDataTreatment() {
    authorizeDataTreatment.value = !authorizeDataTreatment.value;
  }
}
