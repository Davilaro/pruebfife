import 'package:emart/_pideky/presentation/authentication/view/restore_password_page.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';

import 'package:emart/src/controllers/state_controller_radio_buttons.dart';
import 'package:emart/src/controllers/validations_forms.dart';
import 'package:emart/src/widget/soporte.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../shared/widgets/text_button_with_underline.dart';
import '../../../../src/preferences/cont_colores.dart';
import 'confirm_identity_enter_code_page.dart';

class ConfirmIdentitySendSMSPage extends StatelessWidget {
  ConfirmIdentitySendSMSPage({Key? key, required this.isChangePassword})
      : super(key: key);
  final bool isChangePassword;

  @override
  Widget build(BuildContext context) {
    //UXCAM: Se define el nombre de la interfaz
    FlutterUxcam.tagScreenName('ConfirmIdentitySendSMSPage');
    FocusManager.instance.primaryFocus?.unfocus();
    final controller = Get.put(StateControllerRadioButtonsAndChecks());
    final ValidationForms _validationForms = Get.find<ValidationForms>();

    return Scaffold(
      backgroundColor: HexColor('#eeeeee'),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Image(
                  image:
                      AssetImage('assets/image/Icon_confirmar_identidad.png'),
                ),
              ),
              SizedBox(height: 25),
              Text(
                "Confirmar identidad",
                style: TextStyle(
                  color: ConstantesColores.azul_precio,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 15.0),
              Text(
                "Enviaremos un mensaje de texto para \nconfirmar tu identidad al número:",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: ConstantesColores.gris_sku,
                  fontSize: 17,
                  // fontWeight: FontWeight.w800
                ),
              ),
              PhoneNumberSelection(controller: controller),
              Obx(
                () => BotonAgregarCarrito(
                  borderRadio: 35,
                  height: Get.height * 0.06,
                  color: controller.isPhoneNumberSelected
                      ? ConstantesColores.empodio_verde
                      : Colors.grey,
                  onTap: controller.isPhoneNumberSelected
                      ? () async {
                          if (await controller.sendMsg() == false) {
                            return;
                          }

                          Get.to(() => ConfirmIdentityEnterCodePage(
                                isChangePassword: isChangePassword,
                              ));
                        }
                      : null,
                  text: "Enviar SMS",
                ),
              ),
              TextButtonWithUnderline(
                text: "Probar otro método",
                onPressed: () async {
                  await _validationForms.getDataSecurityQuestion();
                  Get.to(() =>
                      RestorePasswordPage(isChangePassword: isChangePassword));
                },
                textColor: HexColor("#41398D"),
                textSize: 18.0,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 40, bottom: 40),
          child: Container(
            height: 32,
            width: 130,
            child: FloatingActionButton.extended(
              onPressed: () {
                Get.to(() => Soporte(numEmpresa: 1));
              },
              label: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/image/image_boton_ayuda.png', // Ruta de la imagen
                      width: 23, // Ajusta el ancho de la imagen
                      height: 23, // Ajusta la altura de la imagen
                    ),
                    SizedBox(width: 2), // Espacio entre la imagen y el texto
                    Text(
                      'Solicitar ayuda',
                      style: TextStyle(fontSize: 9, color: Colors.white),
                    ),
                  ],
                ),
              ),
              backgroundColor: ConstantesColores.azul_precio,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25), // Borde circular
              ),
            ),
          ),
        ),
      ),
    );
  }
}
