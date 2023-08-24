import 'package:emart/_pideky/presentation/authentication/view/restore_password_page.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../shared/widgets/text_button_with_underline.dart';
import '../../../../src/preferences/cont_colores.dart';
import 'confirm_identity_page_two.dart';

class ConfirmIdentityPageOne extends StatelessWidget {
  ConfirmIdentityPageOne({Key? key}) : super(key: key);

  final TextEditingController _controllerCellPhoneNumber =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      backgroundColor: HexColor('#eeeeee'),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                
                child: Image(
                  image: AssetImage('assets/image/Icon_confirmar_identidad.png'),
                  
                )),
            SizedBox(height: 25),
            Text("Confirmar identidad",
                style: TextStyle(
                    color: ConstantesColores.azul_precio,
                    fontSize: 20,
                    fontWeight: FontWeight.w900)),
            SizedBox(height: 15.0),
            Text(
                "Enviaremos un mensaje de texto para \n confirmar tu identidad al número *****4912",
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
                  // TODO consumo servicio envio sms
                  Get.to(ConfirmIdentityPageTwo());
                },
                text: "Enviar SMS"),
                
            TextButtonWithUnderline(
              text: "Probar otro método",
              onPressed: () {
               Get.to(RestorePasswordPage());
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
