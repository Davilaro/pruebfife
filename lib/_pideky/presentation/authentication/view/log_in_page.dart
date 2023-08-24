import 'package:emart/_pideky/presentation/authentication/view/register_page.dart';
import 'package:emart/_pideky/presentation/authentication/view/update_password_page.dart';
import 'package:emart/_pideky/presentation/authentication/view/update_password_send_sms.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/shared/widgets/checkBox_remember_credentials.dart';
import 'package:emart/shared/widgets/popups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../shared/widgets/custom_textFormField.dart';
import '../../../../shared/widgets/text_button_with_underline.dart';
import '../../../../src/preferences/cont_colores.dart';

class LogInPage extends StatelessWidget {
  LogInPage({Key? key}) : super(key: key);

  //final TextEditingController _controllerUserName = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String username = '';
  String password = '';

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
            key: _formkey,
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
                  prefixIcon: Image.asset('assets/icon/Icon_usuario.png'),
                  onChanged: (value) => username = value,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Campo requerido';
                    if (value.trim().isEmpty) return 'Campo requerido';
                    if (value.length < 6)
                      return 'Usuario debe tener más de 6 caracteres';
                  },
                ),

                SizedBox(height: 15.0),

                CustomTextFormField(
                  controller: _controllerPassword,
                  obscureText: true,
                  hintText: 'Ingresa la contraseña que te asignamos',
                  hintStyle: TextStyle(color: ConstantesColores.gris_sku),
                  backgroundColor: HexColor("#E4E3EC"),
                  textColor: HexColor("#41398D"),
                  borderRadius: 35,
                  icon: Icons.key,
                  prefixIcon: Image.asset('assets/icon/Icon_contraseña.png'),
                  onChanged: (value) => password = value,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Campo requerido';
                    if (value.trim().isEmpty) return 'Campo requerido';
                    final passwordRegExp = RegExp(
                        //r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[A-Z])(?!.*[\W_]).{8,}$'
                        //r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'
                        r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[A-Z])[a-zA-Z\d]{8,}$');
                    if (!passwordRegExp.hasMatch(value))
                      return 'No es una contraseña válida';

                    return null;
                  },
                ),

                Container(
                  alignment: Alignment.centerRight,
                  width: double.infinity,
                  child: TextButtonWithUnderline(
                    text: "¿Olvidaste tu contraseña?",
                    onPressed: () {
                      Get.to(UpdatePasswordSendSMS());
                    },
                    textColor: HexColor("#41398D"),
                    textSize: 15.0,
                  ),
                ),

                CheckBoxRememberCredentials(),

                BotonAgregarCarrito(
                    borderRadio: 35,
                    height: Get.height * 0.06,
                    color: ConstantesColores.empodio_verde,
                    onTap: () {
                      final isValid = _formkey.currentState!.validate();
                      if (!isValid)
                        showPopup(
                            context,
                            'Usuario y/o contraseña incorrecto',
                            SvgPicture.asset(
                              'assets/image/Icon_incorrecto.svg',
                            ));
                      else
                        Get.to(UpdatePasswordPage());
                        showPopup(context, 'Ingreso correcto',
                          SvgPicture.asset('assets/image/Icon_correcto.svg'));
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
                SizedBox(height: 10,),
                  Container(
                   height: 70,
                    child: Image(
                      image: AssetImage('assets/image/Icon_touch_ID.png'),
                      fit: BoxFit.contain,
                    )),

                    SizedBox(height: 10,),
                    Text('Ingresar con Touch ID',
                        style: TextStyle(
                        color: ConstantesColores.gris_sku,
                        fontSize: 15,
                        fontWeight: FontWeight.w400))

                //===========Prueba con la hu de notificaciones Slide up =======

                // Card(
                //   color: Colors.grey.shade400,
                //   margin: EdgeInsets.symmetric(
                //     horizontal: 0.01,
                //   ),
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.all(Radius.circular(15)),
                //   ),
                //   child: SizedBox(
                //     width: MediaQuery.of(context).size.width * 3.8,
                //     height: MediaQuery.of(context).size.height * 0.12,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         ClipRRect(
                //           borderRadius: BorderRadius.only(
                //             topLeft: Radius.circular(12.0),
                //             bottomLeft: Radius.circular(12.0),
                //           ),
                //           child: Image.asset(
                //             'assets/image/slide_up_tosh_prueba.png',
                //             // height: MediaQuery.of(context).size.height * 0.1,
                //             fit: BoxFit.cover,
                //           ),
                //         ),
                //         Flexible(
                //           child: Padding(
                //             padding: EdgeInsets.only(top: 15, left: 20, bottom: 20),
                //             child: Text(
                //               '¡Lleva tu negocio al siguiente nivel! pide galletas Tosh con 15% de descuento, Pide aquí ...',
                //               style: TextStyle(fontSize: 12, color: Colors.black),
                //               maxLines: 3,
                //               overflow: TextOverflow.ellipsis,
                //             ),
                //           ),
                //         ),
                //         IconButton(
                //           icon: Icon(
                //             Icons.arrow_forward_ios,
                //             color: Colors.white,
                //           ),
                //           onPressed: () {
                //             // Get.showSnackbar(GetSnackBar(
                //             //   duration: Duration(seconds: 10),
                //             //   snackPosition: SnackPosition.BOTTOM,
                //             //   backgroundColor: Colors.grey.shade400,
                //             //   borderRadius: 15,
                //             //   //  maxWidth: MediaQuery.of(context).size.width - 40,
                //             //   messageText: Row(
                //             //     children: [
                //             //       ClipRRect(
                //             //         borderRadius: BorderRadius.only(
                //             //           topLeft: Radius.circular(12.0),
                //             //           bottomLeft: Radius.circular(12.0),
                //             //         ),
                //             //         child: Image.asset(
                //             //           'assets/image/slide_up_tosh_prueba.png',
                //             //           height:
                //             //               MediaQuery.of(context).size.height * 0.1,
                //             //           fit: BoxFit.cover,
                //             //         ),
                //             //       ),
                //             //       SizedBox(width: 10),
                //             //       Flexible(
                //             //         child: Text(
                //             //           '¡Lleva tu negocio al siguiente nivel  ! pide galletas Tosh con 15% de descuento, Pide aquí ...',
                //             //           style: TextStyle(
                //             //               color: Colors.black, fontSize: 12),
                //             //           maxLines: 3,
                //             //           overflow: TextOverflow.ellipsis,
                //             //         ),
                //             //       ),
                //             //       Icon(Icons.arrow_forward_ios,
                //             //           color: Colors.white),
                //             //     ],
                //             //   ),

                //             //   margin: EdgeInsets.symmetric(horizontal: 24),
                //             //   padding: EdgeInsets.all(1),
                //             //   // colorText: Colors.transparent,
                //             //   forwardAnimationCurve: Curves.easeOutBack,
                //             //   reverseAnimationCurve: Curves.ease,
                //             // ));
                //           },
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
