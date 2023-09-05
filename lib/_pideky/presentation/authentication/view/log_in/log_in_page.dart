import 'package:emart/_pideky/presentation/authentication/view/register_page.dart';
import 'package:emart/_pideky/presentation/authentication/view/create_password_page.dart';
import 'package:emart/_pideky/presentation/authentication/view/confirm_identity_select_method_page.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/shared/widgets/custom_checkBox.dart';
import 'package:emart/shared/widgets/popups.dart';
import 'package:emart/src/controllers/validations_forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../../shared/widgets/custom_textFormField.dart';
import '../../../../../shared/widgets/text_button_with_underline.dart';
import '../../../../../src/preferences/cont_colores.dart';
import '../biometric_id/touch_id_page.dart';

class LogInPage extends StatelessWidget {
  LogInPage({Key? key}) : super(key: key);

  //final TextEditingController _controllerUserName = TextEditingController();
  //final TextEditingController _controllerPassword = TextEditingController();
  final ValidationForms _validationForms = Get.put(ValidationForms());
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

 // String username = '';
 // String password = '';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double scaleFactor = 0.6;

    return Scaffold(
      backgroundColor: HexColor('#eeeeee'),
      body: ListView(children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 80),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formkey,
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

                CustomTextFormField(
                    // controller: _controllerUserName,
                    hintText: 'Ingresa el usuario que te asignamos',
                    hintStyle: TextStyle(color: ConstantesColores.gris_sku),
                    backgroundColor: HexColor("#E4E3EC"),
                    textColor: HexColor("#41398D"),
                    borderRadius: 35,
                    icon: Icons.perm_identity,
                    prefixIcon: SvgPicture.asset('assets/icon/cliente.svg',
                        fit: BoxFit.scaleDown,
                      ),
                    onChanged: (value) {
                      _validationForms.userName.value = value;
                      _validationForms.userInteracted2.value = true; // Marca como interactuado
                    },
                    validator:  _validationForms.validateTextFieldNullorEmpty
                    //(value) {
                    //   if (value == null || value.isEmpty)
                    //     return 'Campo requerido';
                    //   if (value.trim().isEmpty) return 'Campo requerido';
                    //   if (value.length < 6)
                    //     return 'Usuario debe tener más de 6 caracteres';
                    // },
                    ),

                SizedBox(height: 15.0),

                CustomTextFormField(
                  // controller: _controllerPassword,
                  obscureText: true,
                  hintText: 'Ingresa la contraseña que te asignamos',
                  hintStyle: TextStyle(color: ConstantesColores.gris_sku),
                  backgroundColor: HexColor("#E4E3EC"),
                  textColor: HexColor("#41398D"),
                  borderRadius: 35,
                  icon: Icons.key,
                  prefixIcon: SvgPicture.asset('assets/icon/contraseña.svg',
                        fit: BoxFit.scaleDown),
                  onChanged: (value) {
                      _validationForms.password.value = value;
                      _validationForms.userInteracted.value = true; // Marca como interactuado
                    },
                 // onChanged: (value) => password = value,

                 validator: _validationForms.validatePassword
                  // validator: (value) {
                  //   if (value == null || value.isEmpty)
                  //     return 'Campo requerido';
                  //   if (value.trim().isEmpty) return 'Campo requerido';
                  //   final passwordRegExp = RegExp(
                  //       //r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[A-Z])(?!.*[\W_]).{8,}$'
                  //       //r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'
                  //       r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[A-Z])[a-zA-Z\d]{8,}$');
                  //   if (!passwordRegExp.hasMatch(value))
                  //     return 'No es una contraseña válida';

                  //   return null;
                  // },
                ),

                Container(
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
                    onTap: () {
                      final isValid = formkey.currentState!.validate();
                      if (isValid) {
                        
                        Get.to(() => CreatePasswordPage());
                        showPopup(
                          context,
                          'Ingreso correcto',
                          SvgPicture.asset('assets/image/Icon_correcto.svg'),
                        );
                      } else {
                        
                        showPopup(
                          context,
                          'Usuario y/o contraseña incorrecto',
                          SvgPicture.asset('assets/image/Icon_incorrecto.svg'),
                        );
                      }
                      // },

                      // final isValid = formkey.currentState!.validate();
                      // if (!isValid)
                      //   showPopup(
                      //       context,
                      //       'Usuario y/o contraseña incorrecto',
                      //       SvgPicture.asset(
                      //         'assets/image/Icon_incorrecto.svg',
                      //       ));
                      // else
                      //   Get.to(() => CreatePasswordPage());
                      // showPopup(context, 'Ingreso correcto',
                      //     SvgPicture.asset('assets/image/Icon_correcto.svg'));
                    },
                    text: "Ingresar"),

                // print('$username , $password');
                // showPopupFindClientCode(
                //     context, Image.asset('assets/image/factura_imagen.png'));

                // showPopup(context, 'Ingreso correcto',
                //     SvgPicture.asset('assets/image/Icon_correcto.svg'));

                // showPopup(
                //     context,
                //     'Has aceptado los términos y condiciones',
                //     SvgPicture.asset('assets/image/Icon_correcto.svg'));

                // showPopup(context, 'Touch ID activado',
                //     SvgPicture.asset('assets/image/Icon_correcto.svg'));

                // showPopup(context, 'Número de celular actualizado.',
                //     SvgPicture.asset('assets/image/Icon_correcto.svg'));

                // showPopup(
                //     context,
                //     'Confirmación de \n identidad correcto',
                //     SvgPicture.asset('assets/image/Icon_correcto.svg'));

                // showPopupTouchId(context,
                //     Image.asset('assets/image/Icon_touch_ID.png'));

                // showPopup(
                //     context,
                //     'Confirmación de identidad incorrecto',
                //     SvgPicture.asset(
                //       'assets/image/Icon_incorrecto.svg',
                //     ));

                // showPopup(
                //     context,
                //     'Usuario y/o contraseña incorrecto',
                //     SvgPicture.asset(
                //       'assets/image/Icon_incorrecto.svg',
                //     ));

                // showPopup(
                //     context,
                //     'Contraseña actualizada',
                //     SvgPicture.asset(
                //       'assets/image/Icon_correcto.svg',
                //     ));

                TextButtonWithUnderline(
                  text: "Quiero ser cliente Pideky",
                  onPressed: () {
                    Get.to(() => RegisterPage());
                  },
                  textColor: HexColor("#41398D"),
                  textSize: 18.0,
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => TouchIdPage());
                  },
                  child: Container(
                      height: 70,
                      child: Image(
                        image: AssetImage('assets/image/Icon_touch_ID.png'),
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
            ),
          ),
        ),
      ]),
    );
  }
}
