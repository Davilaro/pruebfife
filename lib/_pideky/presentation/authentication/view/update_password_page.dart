import 'package:emart/_pideky/presentation/authentication/view/terms_and_conditions_page.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../generated/l10n.dart';
import '../../../../shared/widgets/boton_agregar_carrito.dart';
import '../../../../shared/widgets/custom_textFormField.dart';
import '../../../../shared/widgets/password_requirements_text.dart';
//import '../../../../shared/widgets/password_strength_indicator.dart';
import '../../../../shared/widgets/popups.dart';
import '../../../../src/preferences/cont_colores.dart';
import 'cell_phone_number_update_page.dart';

class UpdatePasswordPage extends StatefulWidget {
  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  // final TextEditingController _controllerNewPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  late String _password;
  String password = '';

  double _strength = 0;

  RegExp passwordRegExp =
      RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[A-Z])[a-zA-Z\d]{8,}$');

  String _displayText = '';

  bool _passwordsMatch = false;

  void _checkPassword(String value) {
    _password = value.trim();

    if (_password.isEmpty) {
      setState(() {
        _strength = 0;
        _displayText = '';
      });
    } else if (_password.length < 6) {
      setState(() {
        _strength = 1 / 4;
        _displayText = 'débil';
      });
    } else if (_password.length < 8) {
      setState(() {
        _strength = 2 / 4;
        _displayText = 'Medio';
      });
    } else {
      if (!passwordRegExp.hasMatch(_password)) {
        setState(() {
          // Password length >= 8
          // But doesn't contain both letter and digit characters
          _strength = 3 / 4;
          _displayText = 'Fuerte';
        });
      } else {
        // Password length >= 8
        // Password contains both letter and digit characters
        setState(() {
          _strength = 1;
          _displayText = 'Fuerte';
        });
      }
    }
  }

  void _comparePasswords(String value) {
    _passwordsMatch = value == password;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _formkey,
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
                      onChanged: (value) {
                        password = value;
                        _checkPassword(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Campo requerido';
                        if (value.trim().isEmpty) return 'Campo requerido';
                        final passwordRegExp = RegExp(
                            r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[A-Z])[a-zA-Z\d]{8,}$');
                        if (!passwordRegExp.hasMatch(value))
                          return 'No es una contraseña válida';
                        return null;
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: _strength,
                            backgroundColor: ConstantesColores.azul_precio,
                            color: _strength <= 1 / 4
                                ? Colors.white
                                : _strength == 2 / 4
                                    ? Colors.white
                                    : _strength == 3 / 4
                                        ? Colors.white
                                        : Colors.white,
                            minHeight: 10,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      child: Text(
                        _displayText,
                        style: const TextStyle(fontSize: 18),
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
                        controller: _controllerConfirmPassword,
                        hintText: 'Ingresa su nueva contraseña',
                        hintStyle:
                            TextStyle(color: ConstantesColores.gris_sku),
                        backgroundColor: HexColor("#E4E3EC"),
                        textColor: HexColor("#41398D"),
                        borderRadius: 35,
                        obscureText: true,
                        onChanged: _comparePasswords),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      child: Text(
                        _passwordsMatch
                            ? 'Coincide'
                            : ' No coinciden',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 40.0),
                    PassworRequirementsText(),
                    BotonAgregarCarrito(
                        borderRadio: 35,
                        height: Get.height * 0.06,
                        color: ConstantesColores.empodio_verde,
                        onTap: () {
                           final isValid = _formkey.currentState!.validate();
                           if (!isValid) return;
                          Get.to(TermsAndConditionsPage());
                          showPopup(
                              context,
                              'Contraseña actualizada',
                              SvgPicture.asset(
                                'assets/image/Icon_correcto.svg',
                              ));

                          // print('$password');
                          // Get.to(HomeScreen());
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
