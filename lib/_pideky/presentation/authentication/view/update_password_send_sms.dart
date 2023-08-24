import 'package:emart/_pideky/presentation/authentication/view/confirm_identity_page_one.dart';
import 'package:emart/_pideky/presentation/authentication/view/restore_password_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../shared/widgets/boton_agregar_carrito.dart';
import '../../../../shared/widgets/text_button_with_underline.dart';
import '../../../../src/preferences/cont_colores.dart';

class UpdatePasswordSendSMS extends StatelessWidget {
  const UpdatePasswordSendSMS();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ConstantesColores.color_fondo_gris,
        appBar: AppBar(
          title: Text('Inicio de  sesión',
              style: TextStyle(color: HexColor("#41398D"))),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
              onPressed: () => {Navigator.of(context).pop()}),
          elevation: 0,
        ),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(children: [
              SizedBox(height: 15.0),
              Text(
                  "Te ayudaremos a configurar una \n nueva contraseña, pero primero \n debemos verificar tu identidad",
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
                  onTap: () {
                    Get.to(ConfirmIdentityPageOne());
                  },
                  text: "Enviar mensaje de texto"),
              TextButtonWithUnderline(
                text: "Probar otro metodo",
                onPressed: () {
                  Get.to(RestorePasswordPage());
                },
                textColor: HexColor("#41398D"),
                textSize: 18.0,
              ),
            ])));
  }
}
