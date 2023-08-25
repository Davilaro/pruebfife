import 'package:emart/_pideky/presentation/authentication/view/confirm_identity_select_method_page.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../shared/widgets/custom_textFormField.dart';
import '../../../../shared/widgets/popups.dart';
import '../../../../shared/widgets/text_button_with_underline.dart';
import '../../../../src/preferences/cont_colores.dart';
import 'create_password_page.dart';


class ConfirmIdentityEnterCodePage extends StatelessWidget {
  ConfirmIdentityEnterCodePage({Key? key}) : super(key: key);

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
              onChanged: (value) {},
            ),

            SizedBox(height: 10.0),

            Text(
                "El código caduca en {2min} ",
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
                 
                  Get.to(() => CreatePasswordPage());

                   showPopup(
                          context,
                          'Confirmación de \n identidad correcto',
                          SvgPicture.asset('assets/image/Icon_correcto.svg'));
                 
                },
                text: "Aceptar"),

                TextButtonWithUnderline(
              text: "Enviar otro código",
              onPressed: () {
                Get.to(() => ConfirmIdentitySelectMethodPage());
                
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