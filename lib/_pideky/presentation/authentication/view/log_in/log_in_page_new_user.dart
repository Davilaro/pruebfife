import 'package:emart/_pideky/presentation/authentication/view/register_page.dart';
import 'package:emart/_pideky/presentation/authentication/view/create_password_page.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/shared/widgets/custom_checkBox.dart';
import 'package:emart/shared/widgets/popups.dart';
import 'package:emart/src/controllers/validations_forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import '../../../../../shared/widgets/custom_textFormField.dart';
import '../../../../../shared/widgets/text_button_with_underline.dart';
import '../../../../../src/preferences/cont_colores.dart';

class LogInPageNewUser extends StatefulWidget {
  LogInPageNewUser({Key? key}) : super(key: key);

  @override
  State<LogInPageNewUser> createState() => _LogInPageNewUserState();
}

class _LogInPageNewUserState extends State<LogInPageNewUser> {
  final ValidationForms _validationForms = Get.put(ValidationForms());

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final pr = ProgressDialog(context);
    pr.style(
        message: S.current.logging_in,
        progressWidget: Image(
          image: AssetImage('assets/image/jar-loading.gif'),
          fit: BoxFit.cover,
          height: 20,
        ));
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
                    prefixIcon: SvgPicture.asset(
                      'assets/icon/cliente.svg',
                      fit: BoxFit.scaleDown,
                    ),
                    onChanged: (value) {
                      _validationForms.userName.value = value;
                      _validationForms.userInteracted2.value =
                          true; // Marca como interactuado
                    },
                    validator: _validationForms.validateTextFieldNullorEmpty
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
                      _validationForms.userInteracted.value =
                          true; // Marca como interactuado
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
                      final isValid = formkey.currentState!.validate();
                      if (isValid) {
                        await pr.show();
                        var validation =
                            await _validationForms.sendUserAndPassword(
                                _validationForms.userName.value,
                                _validationForms.password.value);
                        await pr.hide();
                        if (validation) {
                          Get.to(() => CreatePasswordPage());
                          showPopup(
                            context,
                            'Ingreso correcto',
                            SvgPicture.asset('assets/image/Icon_correcto.svg'),
                          );
                        } else {
                          showPopup(
                            context,
                            'El dato que suministraste no coincide.\n\n\nIntenta de nuevo.',
                            SvgPicture.asset(
                                'assets/image/Icon_incorrecto.svg'),
                          );
                        }
                      } else {
                        showPopup(
                          context,
                          'Usuario y/o contraseña incorrecto',
                          SvgPicture.asset('assets/image/Icon_incorrecto.svg'),
                        );
                      }
                    },
                    text: "Ingresar"),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                TextButtonWithUnderline(
                  text: "Quiero ser cliente Pideky",
                  onPressed: () {
                    Get.to(() => RegisterPage());
                  },
                  textColor: HexColor("#41398D"),
                  textSize: 18.0,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
