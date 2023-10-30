import 'dart:async';
import 'dart:io';

import 'package:emart/_pideky/presentation/authentication/view/biometric_id/face_id_page.dart';
import 'package:emart/_pideky/presentation/authentication/view/biometric_id/touch_id_page.dart';
import 'package:emart/_pideky/presentation/authentication/view/create_password_page.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/src/controllers/state_controller_radio_buttons.dart';
import 'package:emart/src/controllers/validations_forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../shared/widgets/custom_textFormField.dart';
import '../../../../shared/widgets/popups.dart';
import '../../../../shared/widgets/text_button_with_underline.dart';
import '../../../../src/preferences/cont_colores.dart';

class ConfirmIdentityEnterCodePage extends StatelessWidget {
  ConfirmIdentityEnterCodePage({Key? key, required this.isChangePassword})
      : super(key: key);
  final bool isChangePassword;
  final TextEditingController _controllerCellPhoneNumber =
      TextEditingController();
  final controller = Get.put(StateControllerRadioButtonsAndChecks());

  final ValidationForms _validationForms = Get.find();

  @override
  Widget build(BuildContext context) {
    //UXCAM: Se define el nombre de la interfaz
    FlutterUxcam.tagScreenName('ConfirmIdentityByCodePage');
    String plataforma = Platform.isAndroid ? 'Android' : 'Ios';
    return Scaffold(
      appBar: AppBar(
        title: Text('Restablecer contraseña',
            style: TextStyle(color: HexColor("#41398D"))),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
            onPressed: () => {Navigator.of(context).pop()}),
        elevation: 0,
      ),
      backgroundColor: HexColor('#eeeeee'),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: Image(
              image: AssetImage('assets/image/Icon_confirmar_identidad_2.png'),
            )),
            SizedBox(height: 25),
            Text("Confirmar identidad",
                style: TextStyle(
                    color: ConstantesColores.azul_precio,
                    fontSize: 23,
                    fontWeight: FontWeight.w900)),
            SizedBox(height: 15.0),
            Text(
                "Escribe cuál es el código que \n recibiste por mensaje de texto",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ConstantesColores.gris_sku,
                  fontSize: 15,
                )),
            SizedBox(height: 35.0),
            CustomTextFormField(
              controller: _controllerCellPhoneNumber,
              keyboardType: TextInputType.number,
              hintText: 'Ingrese su código ',
              hintStyle: TextStyle(color: ConstantesColores.gris_sku),
              backgroundColor: Colors.white,
              textColor: HexColor("#41398D"),
              borderRadius: 35,
              onChanged: (value) {
                _validationForms.confirmationCode.value = value;
              },
              validator: _validationForms.validateTextFieldNullorEmpty,
            ),
            SizedBox(height: 10.0),
            Text("El código caduca en (15min) ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ConstantesColores.gris_sku,
                  fontSize: 15,
                )),
            SizedBox(height: 35.0),
            BotonAgregarCarrito(
                borderRadio: 35,
                height: Get.height * 0.06,
                color: ConstantesColores.empodio_verde,
                onTap: () async {
                  final isValid = _validationForms.confirmationCode.isNotEmpty;

                  if (isValid == false) {
                    return;
                  } else {
                    if (await _validationForms.validationCodePhone(context) ==
                        false) {
                      await _validationForms.backClosePopup(context,
                          texto: 'Confirmación de \n identidad incorrecto');
                    } else {
                      if (isChangePassword == true) {
                        await _validationForms.closePopUp(
                            CreatePasswordPage(
                              isChangePassword: true,
                            ),
                            context,
                            "Confirmación de \n identidad correcto");
                      } else {
                        int timeIteration = 0;
                        _validationForms.isClosePopup.value = false;
                        showPopup(
                            context,
                            'Confirmación de \n identidad correcto',
                            SvgPicture.asset('assets/image/Icon_correcto.svg'));
                        Timer.periodic(Duration(milliseconds: 500), (timer) {
                          if (timeIteration >= 5) {
                            timer.cancel();
                            Get.back();
                            plataforma == 'Android'
                                ? Get.to(() => TouchIdPage())
                                : Get.to(() => FaceIdPage());
                          }
                          if (_validationForms.isClosePopup.value == true) {
                            timer.cancel();
                            plataforma == 'Android'
                                ? Get.to(() => TouchIdPage())
                                : Get.to(() => FaceIdPage());
                          }
                          timeIteration++;
                        });
                      }
                    }
                  }
                },
                text: "Aceptar"),
            TextButtonWithUnderline(
              text: "Enviar otro código",
              onPressed: () async {
                await controller.sendMsg();
              },
              textColor: HexColor("#41398D"),
              textSize: 18.0,
            ),
          ],
        ),
      ),
    );
  }
}
