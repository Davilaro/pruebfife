import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/src/controllers/controller_web_view.dart';
import 'package:emart/src/controllers/state_controller_radio_buttons.dart';
import 'package:emart/src/pages/principal_page/tab_opciones.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/soporte.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import '../../../../../src/preferences/cont_colores.dart';

class OrderNotificationPage extends StatelessWidget {
  final int numEmpresa;
  final String numdoc;
  OrderNotificationPage(
      {Key? key, required this.numEmpresa, required this.numdoc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controllerWebView = Get.put(ControllerWebView());
    final controller = Get.put(StateControllerRadioButtons());

    return PopScope(
      canPop: false, 
      child: Scaffold(
        backgroundColor: HexColor('#eeeeee'),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                      child: SvgPicture.asset('assets/image/Logo nutresa.svg'),
                      width: 50,
                      height: 50,
                    ),
                    SizedBox(height: 25),
                    Text("¡Hemos generado tu orden Pideky!",
                        style: TextStyle(
                            color: ConstantesColores.azul_precio,
                            fontSize: 16,
                            fontWeight: FontWeight.w800)),
                    SizedBox(height: 15.0),
                    Text(
                        "Da click en el botón ir al portal de pagos\ny no olvides mostrar el comprobante\na tu entregador.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ConstantesColores.azul_precio,
                            fontSize: 14,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    border: Border.all(color: HexColor("#43398E"), width: 1.2)),
                width: Get.width * 0.9,
                child: OutlinedButton(
                  onPressed: () => {_irSoporte(context)},
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: <Widget>[
                      Icon(
                        Icons.headphones_sharp,
                        color: HexColor("#43398E"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Preguntas e Inquietudes',
                            style: TextStyle(
                              color: HexColor("#43398E"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white)),
                ),
              ),
              BotonAgregarCarrito(
                borderRadio: 15,
                height: Get.height * 0.06,
                width: Get.width * 5.0,
                color: ConstantesColores.empodio_verde,
                onTap: () async {
                  if (controller.isPayOnLine.value) {
                    await controllerWebView.launchUrl();
                    Provider.of<OpcionesBard>(context, listen: false)
                        .selectOptionMenu = 0;
                    Get.offAll(() => TabOpciones());
                    controller.isPayOnLine.value = false;
                  }
                },
                text: 'Ir al portal de pagos',

              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  _irSoporte(context) {
    //UXCam: Llamamos el evento clickSoport
    UxcamTagueo().clickSoport();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Soporte(
                numEmpresa: this.numEmpresa,
              )),
    );
  }
}
