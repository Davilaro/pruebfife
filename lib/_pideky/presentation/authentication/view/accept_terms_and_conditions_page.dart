import 'package:emart/_pideky/presentation/authentication/view/confirm_identity_send_sms_page.dart';
import 'package:emart/_pideky/presentation/mi_negocio/view_model/mi_negocio_view_model.dart';
import 'package:emart/shared/widgets/popups.dart';
import 'package:emart/shared/widgets/terminos_condiciones.dart';
import 'package:emart/src/controllers/validations_forms.dart';
import 'package:emart/src/provider/servicios.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../shared/widgets/boton_agregar_carrito.dart';
import '../../../../shared/widgets/text_button_with_underline.dart';
import '../../../../src/controllers/state_controller_radio_buttons.dart';
import '../../../../src/preferences/cont_colores.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    final MiNegocioViewModel viewModel = Get.find();
    final controller = Get.put(StateControllerRadioButtons());
    final ValidationForms _validationForms = Get.find();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/image/Icon_Terminos_y_condiciones.png'),
              fit: BoxFit.contain,
            ),
            SizedBox(height: 30),
            Text(
              'Términos y condiciones',
              style: TextStyle(
                color: ConstantesColores.azul_precio,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 25),
            Obx(
              () => buildCheckboxRow(
                text: 'Acepto Términos y condiciones',
                value: controller.acceptTerms.value,
                onChanged: () {
                  controller.toggleAcceptTerms();
                },
                onPressed: () => viewModel.terminosDatosPdf != null
                    ? verTerminosCondiciones(
                        context, viewModel.terminosDatosPdf)
                    : null,
              ),
            ),
            Container(
              height: 70,
              child: Obx(
                () =>
                    //   },
                    Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      checkColor: ConstantesColores.azul_precio,
                      shape: CircleBorder(),
                      activeColor: ConstantesColores.azul_precio,
                      value: controller.authorizeDataTreatment.value,
                      onChanged: (_) {
                        controller.toggleAuthorizeDataTreatment();
                      },
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 12),
                      child: TextButtonWithUnderline(
                        text: 'Autorizo tratamiento de mis \n datos personales',
                        onPressed: () {},
                        textColor: ConstantesColores.gris_sku,
                        textSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Obx(
              () => BotonAgregarCarrito(
                borderRadio: 35,
                height: Get.height * 0.06,
                color: controller.isButtonEnabled
                    ? ConstantesColores.empodio_verde
                    : Colors.grey,
                onTap: controller.isButtonEnabled
                    ? () async {
                        bool loadData =
                            await Servicies().loadDataTermsAndConditions();
                        if (loadData) {
                          await _validationForms.getPhoneNumbers();
                          Get.to(() => ConfirmIdentitySendSMSPage());
                          showPopup(
                            context,
                            'Ingreso correcto',
                            SvgPicture.asset('assets/image/Icon_correcto.svg'),
                          );
                        } else {
                          showPopup(
                            context,
                            'Algo salio mal, por favor intentalo de nuevo',
                            SvgPicture.asset(
                                'assets/image/Icon_incorrecto.svg'),
                          );
                        }

                        // Realizar otras acciones al hacer clic
                      }
                    : null,
                text: "Aceptar",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCheckboxRow({
    required String text,
    required bool value,
    required VoidCallback onChanged,
    required VoidCallback onPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          checkColor: ConstantesColores.azul_precio,
          shape: CircleBorder(),
          activeColor: ConstantesColores.azul_precio,
          value: value,
          onChanged: (_) {
            onChanged();
          },
        ),
        Container(
          alignment: Alignment.center,
          child: TextButtonWithUnderline(
            text: text,
            onPressed: onPressed,
            textColor: ConstantesColores.gris_sku,
            textSize: 15.0,
          ),
        ),
      ],
    );
  }
}
