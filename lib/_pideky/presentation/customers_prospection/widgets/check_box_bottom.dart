import 'package:emart/_pideky/presentation/customers_prospection/view_model/customers_prospect_view_model.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckBoxBottom extends StatelessWidget {
  const CheckBoxBottom({
    Key? key,
    required this.customersProspectionViewModel,
  }) : super(key: key);

  final CustomersProspectionViewModel customersProspectionViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: Get.height * 0.02),
        Text('¿Tu establecimiento requiere nevera?',
            style: TextStyle(
                color: ConstantesColores.azul_precio,
                fontWeight: FontWeight.bold)),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Checkbox(
                      shape: CircleBorder(),
                      checkColor: ConstantesColores.azul_precio,
                      value: customersProspectionViewModel
                          .checkBoxYesController.value,
                      onChanged: (value) {
                        customersProspectionViewModel
                            .checkBoxYesController.value = value!;
                        if (value) {
                          customersProspectionViewModel
                              .checkBoxNoController.value = false;
                        }
                      }),
                  Text(
                    'Si',
                    style: TextStyle(color: ConstantesColores.gris_textos),
                  )
                ],
              ),
              Row(
                children: [
                  Checkbox(
                      shape: CircleBorder(),
                      checkColor: ConstantesColores.azul_precio,
                      value: customersProspectionViewModel
                          .checkBoxNoController.value,
                      onChanged: (value) {
                        customersProspectionViewModel
                            .checkBoxNoController.value = value!;
                        if (value) {
                          customersProspectionViewModel
                              .checkBoxYesController.value = false;
                        }
                      }),
                  Text('No',
                      style: TextStyle(color: ConstantesColores.gris_textos))
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
