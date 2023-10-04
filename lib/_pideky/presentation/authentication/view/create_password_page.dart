// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';

import 'package:emart/_pideky/presentation/authentication/view/accept_terms_and_conditions_page.dart';
import 'package:emart/_pideky/presentation/authentication/view/log_in/login_page.dart';
import 'package:emart/src/controllers/validations_forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../shared/widgets/boton_agregar_carrito.dart';
import '../../../../shared/widgets/custom_textFormField.dart';
import '../../../../shared/widgets/password_requirements_text.dart';
import '../../../../shared/widgets/popups.dart';
import '../../../../src/preferences/cont_colores.dart';

class CreatePasswordPage extends StatelessWidget {
  final bool isChangePassword;
  final ValidationForms _validationForms = Get.put(ValidationForms());
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  CreatePasswordPage({Key? key, required this.isChangePassword})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //UXCAM: Se define el nombre de la interfaz
    FlutterUxcam.tagScreenName('CreateNewPasswordPage');
    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: formkey,
                child: Column(
                  children: [
                    Text('Nueva contraseña',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: HexColor("#41398D"),
                            fontSize: 24.0,
                            fontWeight: FontWeight.w900)),
                    SizedBox(height: 15.0),
                    Text(
                        'Ahora debes crear una \n contraseña que recuerdes fácilmente',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ConstantesColores.gris_sku,
                            fontSize: 17.5,
                            fontWeight: FontWeight.w400)),
                    SizedBox(height: 35.0),
                    Container(
                      padding: EdgeInsets.only(left: 15.0),
                      width: double.infinity,
                      child: Text('Nueva contraseña',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: HexColor("#41398D"),
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700)),
                    ),
                    SizedBox(height: 10.0),
                    CustomTextFormField(
                      hintText: 'Ingresa su nueva contraseña',
                      hintStyle: TextStyle(color: ConstantesColores.gris_sku),
                      backgroundColor: HexColor("#E4E3EC"),
                      textColor: HexColor("#41398D"),
                      borderRadius: 35,
                      obscureText: true,
                      validator: _validationForms.validatePassword,
                      onChanged: (value) {
                        _validationForms.tagCheckPassword(value);
                        _validationForms.createPassword.value = value;
                        _validationForms.userInteracted.value = true;
                      },
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ConstantesColores.azul_precio,
                        ),
                        child: Obx(
                          () => ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: _validationForms.strength.value,
                              backgroundColor: ConstantesColores.azul_precio,
                              color: _validationForms.strength <= 1 / 4
                                  ? Colors.white
                                  : _validationForms.strength.value == 2 / 4
                                      ? Colors.white
                                      : _validationForms.strength.value == 3 / 4
                                          ? Colors.white
                                          : Colors.white,
                              minHeight: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        child: Text(
                          _validationForms.displayText.value,
                          style: TextStyle(
                              fontSize: 18, color: ConstantesColores.gris_sku),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.only(left: 15.0),
                      width: double.infinity,
                      child: Text('Confirmar contraseña',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: HexColor("#41398D"),
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700)),
                    ),
                    SizedBox(height: 10.0),
                    CustomTextFormField(
                        hintText: 'Ingresa su nueva contraseña',
                        hintStyle: TextStyle(color: ConstantesColores.gris_sku),
                        backgroundColor: HexColor("#E4E3EC"),
                        textColor: HexColor("#41398D"),
                        borderRadius: 35,
                        obscureText: true,
                        onChanged: _validationForms.comparePasswords),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      child: Obx(
                        () => Text(
                          _validationForms.passwordsMatch.value
                              ? 'Coincide'
                              : '',
                          style: TextStyle(
                              fontSize: 18, color: ConstantesColores.gris_sku),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.0),
                    PassworRequirementsText(),
                    BotonAgregarCarrito(
                        borderRadio: 35,
                        height: Get.height * 0.06,
                        color: ConstantesColores.empodio_verde,
                        onTap: () async {
                          final isValid = formkey.currentState!.validate();
                          if (isValid == false)
                            return;
                          else {
                            bool response =
                                await _validationForms.changePassword();
                            if (response == true) {
                              if (isChangePassword == true) {
                                int timeIteration = 0;
                                _validationForms.isClosePopup.value = false;
                                showPopup(
                                    context,
                                    'Usuario correcto',
                                    SvgPicture.asset(
                                        'assets/image/Icon_correcto.svg'));
                                Timer.periodic(Duration(milliseconds: 500),
                                    (timer) {
                                  if (timeIteration >= 5) {
                                    timer.cancel();
                                    Get.back();
                                    Get.off(() => LogInPage());
                                  }
                                  if (_validationForms.isClosePopup.value ==
                                      true) {
                                    timer.cancel();
                                    Get.off(() => LogInPage());
                                  }
                                  timeIteration++;
                                });
                              } else {
                                int timeIteration = 0;
                                _validationForms.isClosePopup.value = false;
                                showPopup(
                                    context,
                                    'Usuario correcto',
                                    SvgPicture.asset(
                                        'assets/image/Icon_correcto.svg'));
                                Timer.periodic(Duration(milliseconds: 500),
                                    (timer) {
                                  if (timeIteration >= 5) {
                                    timer.cancel();
                                    Get.back();
                                    Get.off(() => TermsAndConditionsPage());
                                  }
                                  if (_validationForms.isClosePopup.value ==
                                      true) {
                                    timer.cancel();
                                    Get.off(() => TermsAndConditionsPage());
                                  }
                                  timeIteration++;
                                });
                              }
                            } else if (response ==
                                "Por favor validar con otro Nit") {
                              await _validationForms.backClosePopup(context,
                                  texto: 'Por favor validar con otro Nit');
                            }
                          }
                        },
                        text: "Actualizar contraseña"),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
