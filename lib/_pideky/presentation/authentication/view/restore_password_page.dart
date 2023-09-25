import 'dart:io';

import 'package:emart/_pideky/presentation/authentication/view/biometric_id/face_id_page.dart';
import 'package:emart/_pideky/presentation/authentication/view/biometric_id/touch_id_page.dart';
import 'package:emart/_pideky/presentation/authentication/view/create_password_page.dart';
import 'package:emart/src/controllers/state_controller_radio_buttons.dart';
import 'package:emart/src/controllers/validations_forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../shared/widgets/boton_agregar_carrito.dart';
import '../../../../shared/widgets/popups.dart';
import '../../../../shared/widgets/text_button_with_underline.dart';
import '../../../../src/preferences/cont_colores.dart';

class RestorePasswordPage extends StatefulWidget {
  const RestorePasswordPage({required this.isChangePassword});
  final bool isChangePassword;

  @override
  State<RestorePasswordPage> createState() => _RestorePasswordPageState();
}

class _RestorePasswordPageState extends State<RestorePasswordPage> {
  final controller = Get.put(StateControllerRadioButtonsAndChecks());
  final validationForm = Get.find<ValidationForms>();

  @override
  Widget build(BuildContext context) {
    //UXCAM: Se define el nombre de la interfaz
    FlutterUxcam.tagScreenName('RestorePasswordPage');
    String plataforma = Platform.isAndroid ? 'Android' : 'Ios';
    FocusManager.instance.primaryFocus?.unfocus();

    return Scaffold(
        backgroundColor: ConstantesColores.color_fondo_gris,
        appBar: AppBar(
          title: Text('Restablecer contraseña',
              style: TextStyle(color: HexColor("#41398D"))),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
              onPressed: () => {Navigator.of(context).pop()}),
          elevation: 0,
        ),
        body: Container(
            padding: EdgeInsets.only(top: 80, left: 30, right: 30),
            child: Column(children: [
              Container(
                  // width: screenWidth * scaleFactor,
                  child: Image(
                image: AssetImage('assets/image/Icon_pregunta_seguridad.png'),
                fit: BoxFit.contain,
              )),
              SizedBox(height: 50),
              Text('Pregunta de seguridad',
                  style: TextStyle(
                      color: HexColor("#41398D"),
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 15.0),
              Text(
                  "¿Cuál de los siguientes es tu código \n de cliente con ${validationForm.providerQuestion}?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ConstantesColores.gris_sku,
                    fontSize: 15,
                  )),
              SizedBox(height: 25.0),
              ClientCodeSelection(controller: controller),
              Obx(
                () => BotonAgregarCarrito(
                    borderRadio: 35,
                    height: Get.height * 0.06,
                    color: controller.isClientCodeSelected
                        ? ConstantesColores.empodio_verde
                        : Colors.grey,
                    onTap: controller.isClientCodeSelected
                        ? () async {
                            if (validationForm.selectedCode ==
                                validationForm.correctCode) {
                              if (widget.isChangePassword == true) {
                                Get.to(() => CreatePasswordPage(
                                      isChangePassword: true,
                                    ));
                                showPopup(
                                    context,
                                    'Ingreso correcto',
                                    SvgPicture.asset(
                                        'assets/image/Icon_correcto.svg'));
                              } else {
                                plataforma == 'Android'
                                    ? Get.to(() => TouchIdPage())
                                    : Get.to(() => FaceIdPage());
                                await showPopup(
                                    context,
                                    'Confirmación de \n identidad correcto',
                                    SvgPicture.asset(
                                        'assets/image/Icon_correcto.svg'));
                              }
                            } else {
                              showPopup(
                                  context,
                                  'Confirmación de \n identidad incorrecto',
                                  SvgPicture.asset(
                                      'assets/image/Icon_incorrecto.svg'));
                            }
                          }
                        : null,
                    text: "Aceptar"),
              ),
              TextButtonWithUnderline(
                text: "¿Dónde encontrar tu código de cliente?",
                onPressed: () {
                  showPopupFindClientCode(
                      context, Image.asset('assets/image/factura_gif.gif'));
                },
                textColor: HexColor("#41398D"),
                textSize: 16.0,
              ),
            ])));
  }
}
