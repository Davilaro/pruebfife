import 'dart:async';

import 'package:emart/_pideky/presentation/customers_prospection/view_model/customers_prospect_view_model.dart';
import 'package:emart/_pideky/presentation/customers_prospection/widgets/check_box_bottom.dart';
import 'package:emart/_pideky/presentation/customers_prospection/widgets/text_form_field_customers_prospect.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/shared/widgets/popups.dart';
import 'package:emart/src/controllers/validations_forms.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BodyCustomersProspection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ValidationForms validationForms = Get.find();
    CustomersProspectionViewModel customersProspectionViewModel =
        Get.isRegistered<CustomersProspectionViewModel>()
            ? Get.find<CustomersProspectionViewModel>()
            : Get.put(CustomersProspectionViewModel());
    return Center(
      child: Container(
        width: Get.width * 0.9,
        height: Get.height * 0.85,
        margin:
            EdgeInsets.only(top: Get.height * 0.12, bottom: Get.height * 0.05),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: EdgeInsets.only(
              top: Get.height * 0.05,
              left: Get.width * 0.04,
              right: Get.width * 0.04),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Text(
                  'Quiero ser cliente\n Cream Helado',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ConstantesColores.azul_precio),
                ),
                SizedBox(height: Get.height * 0.02),
                Text(
                  '¡Gracias por tu interés con este proveedor!\n'
                  'Déjanos tus datos para ponernos en contacto',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: ConstantesColores.gris_textos,
                  ),
                ),
                SizedBox(height: Get.height * 0.02),
                TextFormFieldCustomerProspection(
                    customersProspectionViewModel:
                        customersProspectionViewModel),
                CheckBoxBottom(
                    customersProspectionViewModel:
                        customersProspectionViewModel),
                SizedBox(height: Get.height * 0.06),
                BotonAgregarCarrito(
                    color: ConstantesColores.azul_aguamarina_botones,
                    onTap: () async {
                      if (customersProspectionViewModel.formkey.currentState!
                          .validate()) {
                        await customersProspectionViewModel
                            .sendProspectionRequest();
                      } else {
                        int timeIteration = 0;
                        validationForms.isClosePopup.value = false;
                        showPopup(
                            context,
                            'Por favor completa el formulario',
                            SvgPicture.asset('assets/image/Icon_incorrecto.svg'));
                        Timer.periodic(Duration(milliseconds: 500), (timer) {
                          if (timeIteration >= 5) {
                            timer.cancel();
                            Get.back();
                          }
                          if (validationForms.isClosePopup.value == true) {
                            timer.cancel();
                          }
                          timeIteration++;
                        });
                      }
                    },
                    borderRadio: 30,
                    text: 'Enviar')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
