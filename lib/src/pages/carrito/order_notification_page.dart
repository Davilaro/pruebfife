import 'package:emart/_pideky/presentation/club_ganadores/view_mdel/club_ganadores_view_model.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/src/controllers/state_controller_radio_buttons.dart';
import 'package:emart/src/pages/principal_page/tab_opciones.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import '../../../../src/preferences/cont_colores.dart';

class OrderNotificationPage extends StatelessWidget {
  OrderNotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clubGanadoresViewModel = Get.find<ClubGanadoresViewModel>();
    final controller = Get.put(StateControllerRadioButtons());

    return Scaffold(
      backgroundColor: HexColor('#eeeeee'),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding:
                  EdgeInsets.only(top: 15, bottom: 25, left: 20, right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), 
                  color: Colors.white),
              child: Column(
                children: [
                  Container(
                      child: Image(
                    width: 50,
                    height: 50,
                    image: AssetImage(
                        'assets/image/Icon_confirmar_identidad_2.png'),
                  )),
                  SizedBox(height: 25),
                  Text("¡Hemos generado tu orden Pideky!",
                      style: TextStyle(
                          color: ConstantesColores.azul_precio,
                          fontSize: 17,
                          fontWeight: FontWeight.w800)),
                  SizedBox(height: 15.0),
                  Text(
                      "Da click en el botón ir al portal de pagos\ny no olvides mostrar el comprobante\na tu entregador! ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: ConstantesColores.azul_precio,
                          fontSize: 15,
                          fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            SizedBox(height: 25),
            BotonAgregarCarrito(
              borderRadio: 35,
              height: Get.height * 0.06,
              color: ConstantesColores.empodio_verde,
              onTap: () async {
                if (controller.isPayOnLine.value) {
                 await clubGanadoresViewModel.launchUrl();
                 Provider.of<OpcionesBard>(context,listen: false).selectOptionMenu = 0;
                 Get.offAll(() => TabOpciones());
                 } 

              },
              text: 'Ir al portal de pagos',

              // showPopup(
              //     context,
              //     'Confirmación de \n identidad correcto',
              //     SvgPicture.asset('assets/image/Icon_correcto.svg'));
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
