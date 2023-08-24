import 'package:emart/_pideky/presentation/authentication/view/confirm_identity_page_one.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../shared/widgets/custom_textFormField.dart';
import '../../../../src/preferences/cont_colores.dart';

class CellPhoneNumberUpdatePageOne extends StatelessWidget {
  CellPhoneNumberUpdatePageOne({Key? key}) : super(key: key);

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
                  image: AssetImage('assets/image/Icon_actualizar_Celular.png'),
                  fit: BoxFit.contain,
                )),
            SizedBox(height: 25),
            Text("Actualizar número de celular",
                style: TextStyle(
                    color: ConstantesColores.azul_precio,
                    fontSize: 20,
                    fontWeight: FontWeight.w900)),
            SizedBox(height: 15.0),
            Text(
                "Introduce un número de celular actual \n donde sea fácil para ti recibir información",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ConstantesColores.gris_sku,
                  fontSize: 15,
                )),
            SizedBox(height: 35.0),
            CustomTextFormField(
              controller: _controllerCellPhoneNumber,
              keyboardType: TextInputType.number,
              hintText: 'Ingrese su número de celular actual ',
              hintStyle: TextStyle(color: HexColor("#41398D")),
              backgroundColor: HexColor("#E4E3EC"),
              textColor: HexColor("#41398D"),
              borderRadius: 35,
              onChanged: (value) {},
            ),
            SizedBox(height: 1.0),
            BotonAgregarCarrito(
                borderRadio: 35,
                height: Get.height * 0.06,
                color: ConstantesColores.empodio_verde,
                onTap: () {
                 // Get.to( () => ConfirmIdentityPage());
                },
                text: "Enviar SMS"),
          ],
        ),
      ),
    );
  }
}
