import 'package:emart/_pideky/presentation/authentication/view/create_password_page.dart';
import 'package:emart/src/controllers/state_controller_radio_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../shared/widgets/boton_agregar_carrito.dart';
import '../../../../shared/widgets/popups.dart';
import '../../../../shared/widgets/radio_button.dart';
import '../../../../shared/widgets/text_button_with_underline.dart';
import '../../../../src/preferences/cont_colores.dart';


class RestorePasswordPage extends StatelessWidget {
  const RestorePasswordPage();

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(StateControllerRadioButtonsAndChecks());
    
    return Scaffold(
        backgroundColor: ConstantesColores.color_fondo_gris,
        appBar: AppBar(
          title: Text('Restablecer contraseña',
              style: TextStyle(color: HexColor("#41398D"))),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
              onPressed: () => {Navigator.of(context).pop()}),
          elevation: 0,
        ),
        body: Container(
            padding: EdgeInsets.only(top: 80, left: 30, right: 30),
            child: Column(children: [
              Container(
                  // width: screenWidth * scaleFactor,
                  child: Image(
                image: AssetImage('assets/image/Icon_pregunta_seguridad.png'),
                fit: BoxFit.contain,
              )),
              SizedBox(height: 50),
              Text('Pregunta de seguridad',
                  style: TextStyle(
                      color: HexColor("#41398D"),
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 15.0),
              Text(
                  "¿Cuál de los siguientes es tu código \n de cliente con Comercial Nutresa?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ConstantesColores.gris_sku,
                    fontSize: 15,
                  )),
              SizedBox(height: 25.0),
            ClientCodeSelection(controller: controller),
              Obx(
                () =>  BotonAgregarCarrito(
                    borderRadio: 35,
                    height: Get.height * 0.06,
                    color: controller.isClientCodeSelected
                      ? ConstantesColores.empodio_verde
                      : Colors.grey,
                    onTap: controller.isClientCodeSelected
                    ?() {
                      Get.to(() => CreatePasswordPage());
              
                      showPopup(
                            context,
                            'Confirmación de \n identidad correcto',
                            SvgPicture.asset('assets/image/Icon_correcto.svg'));
                    }
                    :null,
                    text: "Aceptar"),
              ),
              TextButtonWithUnderline(
                text: "¿Dónde encontrar tu código de cliente?",
                onPressed: () {
                  showPopupFindClientCode(
                    context, Image.asset('assets/image/factura_imagen.png'));
                },
                textColor: HexColor("#41398D"),
                textSize: 16.0,
              ),
            ])));
  }
}
