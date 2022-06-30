import 'package:emart/src/modelos/notificaciones.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/servicios.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class NotificacionesPage extends StatefulWidget {
  NotificacionesPage({Key? key}) : super(key: key);

  @override
  State<NotificacionesPage> createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  @override
  Widget build(BuildContext context) {
    //Se define el nombre de la pantalla para UXCAM
    FlutterUxcam.tagScreenName('NotificationsPage');
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "Notificaciones",
            style: TextStyle(
                color: HexColor(
                  "#41398D",
                ),
                fontWeight: FontWeight.bold),
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: Get.height * 0.74,
              width: Get.width * 1.0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: FutureBuilder(
                          future: Servicies()
                              .getListaNotificaciones(prefs.usurioLoginCedula),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData) {
                              var datos = snapshot.data;
                              return Column(
                                children: [
                                  for (int i = datos.length - 1; i >= 0; i--)
                                    _cartaNotificacion(datos[i]),
                                ],
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          }),
                    ),
                  ],
                ),
              )),
          Container(
            width: Get.width * 0.8,
            child: FlatButton(
                child: new Text(
                  "Cerrar",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: ConstantesColores.agua_marina,
                textColor: Colors.white,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0))),
          )
        ],
      ),
    );
    ;
  }

  Widget _cartaNotificacion(Notificaciones notification) {
    Widget notificacion = Html(data: """${notification.descripcion!}""");
    Widget titleNotificate = Html(data: """${notification.titulo!}""");
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            width: Get.width * 0.9,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SizedBox(
                  width: 14,
                ),
                Icon(
                  Icons.circle_notifications_outlined,
                  size: 40,
                  color: HexColor(
                    "#41398D",
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: Get.width * 0.6,
                          alignment: Alignment.bottomLeft,
                          child: titleNotificate,
                          // child: Text(
                          //   notification.titulo!,
                          //   textAlign: TextAlign.left,
                          //   style: TextStyle(
                          //       color: ConstantesColores.gris_oscuro,
                          //       fontWeight: FontWeight.bold),
                          // ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: Get.width * 0.6,
                          alignment: Alignment.bottomLeft,
                          child: notificacion,
                          // child: Text(
                          //   notification.descripcion!,
                          //   textAlign: TextAlign.left,
                          //   style: TextStyle(
                          //     color: ConstantesColores.gris_oscuro,
                          //   ),
                          // ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: Get.width * 0.6,
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            notification.fecha!.substring(0, 10),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: HexColor(
                                  "#41398D",
                                ),
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
