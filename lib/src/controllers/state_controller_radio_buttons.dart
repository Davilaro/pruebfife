import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StateControllerRadioButtonsAndChecks extends GetxController {
  RxInt selectedPhoneNumberIndex = RxInt(-1);
  RxInt selectedClientCodeIndex = RxInt(-1);
   

 // RxBool acceptTerms = false.obs;
 // RxBool authorizeDataTreatment = false.obs;

   bool get isPhoneNumberSelected => selectedPhoneNumberIndex.value != -1;

  void selectPhoneNumber(int index) {
    selectedPhoneNumberIndex.value = index;
  }

  bool get isClientCodeSelected => selectedClientCodeIndex.value != -1;

  void selectClientCode(int index) {
    selectedClientCodeIndex.value = index;
  }

//  bool get isButtonEnabled => acceptTerms.value && authorizeDataTreatment.value;

//   void toggleAcceptTerms() {
//     acceptTerms.value = !acceptTerms.value;
//   }

//   void toggleAuthorizeDataTreatment() {
//     authorizeDataTreatment.value = !authorizeDataTreatment.value;
//   }


}

class PhoneNumberSelection extends StatelessWidget {
  final StateControllerRadioButtonsAndChecks controller;

  PhoneNumberSelection({required this.controller});

  final List<String> phoneNumbers = [
    '3254856547',
    '3004569874',
    '3698745214',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StateControllerRadioButtonsAndChecks());

    return Column(
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
              controller.selectPhoneNumber(value!);
            },
          ),
        );
      }).toList(),
    );
  }
}

class ClientCodeSelection extends StatelessWidget {
  final StateControllerRadioButtonsAndChecks controller;

  ClientCodeSelection({required this.controller});

  final List<String> clientCodes = [
    '9636284585',
    '8544895632',
    '2354787891',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StateControllerRadioButtonsAndChecks());

    return Column(
      children: clientCodes.asMap().entries.map((entry) {
        final index = entry.key;
        final phoneNumber = entry.value;
        final maskedPhoneNumber = phoneNumber;
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
              controller.selectClientCode(value!);
            },
          ),
        );
      }).toList(),
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