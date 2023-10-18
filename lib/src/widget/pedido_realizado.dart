import 'package:emart/src/pages/principal_page/tab_opciones.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/soporte.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class PedidoRealizado extends StatelessWidget {
  final int numEmpresa;
  final String numdoc;
  const PedidoRealizado(
      {Key? key, required this.numEmpresa, required this.numdoc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Material(
        child: Container(
          color: HexColor("#DAD9D9"),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: Get.height * 0.40,
                width: Get.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: Get.width * 0.9,
                            padding: const EdgeInsets.only(top: 36, bottom: 20),
                            child: Icon(
                              Icons.bus_alert,
                              size: 30,
                              color: HexColor("#30C3A3"),
                            ),
                          )
                        ],
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              width: Get.width * 0.8,
                              child: Text(
                                "Tu pedido se ha realizado exitosamente.",
                                style: TextStyle(
                                    color: HexColor("#43398E"),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              width: Get.width * 0.8,
                              child: Text(
                                "El número de orden es: $numdoc",
                                style: TextStyle(
                                    color: HexColor("#43398E"),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              width: Get.width * 0.8,
                              child: Text(
                                "para dudas o reporte de novedades",
                                style: TextStyle(
                                    color: HexColor("#43398E"),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              width: Get.width * 0.8,
                              child: Text(
                                "Ingresa al histórico de pedido. Allí",
                                style: TextStyle(
                                    color: HexColor("#43398E"),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              width: Get.width * 0.8,
                              child: Text(
                                "encontrarás el número de pedido por",
                                style: TextStyle(
                                    color: HexColor("#43398E"),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              width: Get.width * 0.8,
                              child: Text(
                                "proveedor.",
                                style: TextStyle(
                                    color: HexColor("#43398E"),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 36,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    border: Border.all(color: HexColor("#43398E"), width: 1.2)),
                width: Get.width * 0.9,
                child: OutlinedButton(
                  onPressed: () => {irSoporte(context)},
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
                  // highlightedBorderColor: HexColor("#43398E"),
                  // color: HexColor("#43398E"),
                  // borderSide: new BorderSide(
                  //   color: Colors.white,
                  // ),
                  // shape: new RoundedRectangleBorder(
                  //     borderRadius: new BorderRadius.circular(10.0))
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    border: Border.all(color: HexColor("#43398E"), width: 1.2)),
                width: Get.width * 0.9,
                child: OutlinedButton(
                  onPressed: () => {_irMenuPrincipal(context)},
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: <Widget>[
                      Icon(
                        Icons.supervised_user_circle_sharp,
                        color: ConstantesColores.verde,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Aceptar',
                            style: TextStyle(
                              color: ConstantesColores.verde,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.transparent)),
                  // highlightedBorderColor: ConstantesColores.verde,
                  // color: ConstantesColores.verde,
                  // borderSide: new BorderSide(
                  //   color: Colors.white,
                  // ),
                  // shape: new RoundedRectangleBorder(
                  //     borderRadius: new BorderRadius.circular(10.0))
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  irSoporte(context) {
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

  _irMenuPrincipal(context) async {
    final providerCar = Provider.of<OpcionesBard>(context, listen: false);
    providerCar.selectOptionMenu = 0;
    Get.offAll(() => TabOpciones());
  }
}
