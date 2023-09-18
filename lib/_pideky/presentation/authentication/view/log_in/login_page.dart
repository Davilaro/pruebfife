import 'dart:io';
import 'package:emart/_pideky/presentation/authentication/view/entry_as_collaboratol.dart';
import 'package:emart/_pideky/presentation/authentication/view/register/register_page.dart';
import 'package:emart/_pideky/presentation/authentication/view/confirm_identity_select_method_page.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/shared/widgets/custom_checkBox.dart';
import 'package:emart/shared/widgets/popups.dart';
import 'package:emart/src/controllers/validations_forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../shared/widgets/custom_textFormField.dart';
import '../../../../../shared/widgets/text_button_with_underline.dart';
import '../../../../../src/preferences/cont_colores.dart';

class LogInPage extends StatelessWidget {
  LogInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValidationForms _validationForms = Get.find<ValidationForms>();

    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    //UXCAM: Se define el nombre de la interfaz
    FlutterUxcam.tagScreenName('LoginPage');
    String plataforma = Platform.isAndroid ? 'Android' : 'Ios';

    double screenWidth = MediaQuery.of(context).size.width;
    double scaleFactor = 0.6;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        backgroundColor: HexColor('#eeeeee'),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: screenWidth * scaleFactor,
                    child: Image(
                      image: AssetImage('assets/image/logo_login.png'),
                      fit: BoxFit.contain,
                    )),
                SizedBox(
                  height: 100,
                ),
                Text("Inicia sesión",
                    style: TextStyle(
                        color: ConstantesColores.azul_precio,
                        fontSize: 25,
                        fontWeight: FontWeight.w900)),
                SizedBox(height: 35.0),
                Form(
                  child: Column(
                    children: [
                      CustomTextFormField(
                          // controller: _controllerUserName,
                          hintText: 'Ingresa el usuario que te asignamos',
                          hintStyle:
                              TextStyle(color: ConstantesColores.gris_sku),
                          backgroundColor: HexColor("#E4E3EC"),
                          textColor: HexColor("#41398D"),
                          borderRadius: 35,
                          icon: Icons.perm_identity,
                          prefixIcon: SvgPicture.asset(
                            'assets/icon/cliente.svg',
                            fit: BoxFit.scaleDown,
                          ),
                          onChanged: (value) {
                            _validationForms.userName.value = value;
                            _validationForms.userInteracted2.value =
                                true; // Marca como interactuado
                          },
                          validator:
                              _validationForms.validateTextFieldNullorEmpty),
                      SizedBox(height: 15.0),
                      CustomTextFormField(
                          // controller: _controllerPassword,
                          obscureText: true,
                          hintText: 'Ingresa la contraseña que te asignamos',
                          hintStyle:
                              TextStyle(color: ConstantesColores.gris_sku),
                          backgroundColor: HexColor("#E4E3EC"),
                          textColor: HexColor("#41398D"),
                          borderRadius: 35,
                          icon: Icons.key,
                          prefixIcon: SvgPicture.asset(
                              'assets/icon/contraseña.svg',
                              fit: BoxFit.scaleDown),
                          onChanged: (value) {
                            _validationForms.password.value = value;
                            _validationForms.userInteracted.value =
                                true; // Marca como interactuado
                          },
                          validator: _validationForms.validatePassword),
                    ],
                  ),
                ),
                Visibility(
                  visible: prefs.isFirstTime != true ? true : false,
                  child: Container(
                    alignment: Alignment.centerRight,
                    width: double.infinity,
                    child: TextButtonWithUnderline(
                      text: "¿Olvidaste tu contraseña?",
                      onPressed: () {
                        Get.to(() => ConfirmIdentitySelectMethodPage());
                      },
                      textColor: HexColor("#41398D"),
                      textSize: 15.0,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Recuérdame la próxima vez',
                      style: TextStyle(
                        color: ConstantesColores.gris_sku,
                      ),
                    ),
                    CustomCheckBox(),
                  ],
                ),
                BotonAgregarCarrito(
                    borderRadio: 35,
                    height: Get.height * 0.06,
                    color: ConstantesColores.empodio_verde,
                    onTap: () async {
                      await _validationForms.validationLoginNewUser(context);
                    },
                    text: "Ingresar"),
                TextButtonWithUnderline(
                  text: "Quiero ser cliente Pideky",
                  onPressed: () {
                    Get.to(() => RegisterPage());
                  },
                  textColor: HexColor("#41398D"),
                  textSize: 18.0,
                ),
                TextButtonWithUnderline(
                  text: "Ingreso como colaborador",
                  onPressed: () {
                    Get.to(() => EntryAsCollaboratorPage());
                  },
                  textColor: ConstantesColores.gris_sku,
                  textSize: 15.0,
                ),
                SizedBox(
                  height: 10,
                ),
                prefs.isDataBiometricActive != true
                    ? SizedBox.shrink()
                    : plataforma == "Ios"
                        ? _validationForms.supportState.value == true
                            ? Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await _validationForms
                                          .loginWithBiometricData(context);
                                    },
                                    child: Container(
                                        height: 70,
                                        child: Image(
                                          image: AssetImage(
                                              'assets/image/Image_face_ID.png'),
                                          fit: BoxFit.contain,
                                        )),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Ingresar con Face ID',
                                      style: TextStyle(
                                          color: ConstantesColores.gris_sku,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400))
                                ],
                              )
                            : SizedBox.shrink()
                        : _validationForms.supportState.value == true
                            ? Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await _validationForms
                                          .loginWithBiometricData(context);
                                    },
                                    child: Container(
                                        height: 70,
                                        child: Image(
                                          image: AssetImage(
                                              'assets/image/Icon_touch_ID.png'),
                                          fit: BoxFit.contain,
                                        )),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Ingresar con Touch ID',
                                      style: TextStyle(
                                          color: ConstantesColores.gris_sku,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400))
                                ],
                              )
                            : SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
