import 'dart:async';

import 'package:emart/_pideky/presentation/customers_prospections_sura/view_model/customer_prospect_sura_view_model.dart';
import 'package:emart/_pideky/presentation/customers_prospections_sura/widgets/text_form_field_customers_sura.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/shared/widgets/popups.dart';
import 'package:emart/src/controllers/validations_forms.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BodyCustomersProspectionSura extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ValidationForms validationForms = Get.find();
    CustomersProspectionSuraViewModel customersProspectionSuraViewModel =
        Get.isRegistered<CustomersProspectionSuraViewModel>()
            ? Get.find<CustomersProspectionSuraViewModel>()
            : Get.put(CustomersProspectionSuraViewModel());
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
                  'Quiero Asegurarme',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ConstantesColores.azul_precio),
                ),
                SizedBox(height: Get.height * 0.02),
                Text(
                  '¡Gracias por tu interés, en asegurarte! \n'
                  'Déjanos tus datos para ponernos en contacto',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: ConstantesColores.gris_textos,
                  ),
                ),
                SizedBox(height: Get.height * 0.02),
                TextFormFieldCustomerProspectionSura(
                    customersProspectionSuraViewModel:
                        customersProspectionSuraViewModel),
                // CheckBoxBottom(
                //     customersProspectionViewModel:
                //         customersProspectionSuraViewModel),
                SizedBox(height: Get.height * 0.06),
                BotonAgregarCarrito(
                    color: ConstantesColores.azul_aguamarina_botones,
                    onTap: () async {
                      if (customersProspectionSuraViewModel.formkey.currentState!
                          .validate()) {
                        await customersProspectionSuraViewModel
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
