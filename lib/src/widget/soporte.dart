import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:emart/src/utils/util.dart';
import 'package:emart/src/widget/simple_card_call.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

final prefs = new Preferencias();
NumberFormat formatNumber = new NumberFormat("#,##0.00", "es_AR");

class Soporte extends StatefulWidget {
  final int numEmpresa;
  const Soporte({Key? key, required this.numEmpresa}) : super(key: key);

  @override
  _SoporteState createState() => _SoporteState();
}

class _SoporteState extends State<Soporte> {
  String version = '1.2.4';

  @override
  void initState() {
    super.initState();
    _validarVersion();
  }

  void _validarVersion() async {
    version = await cargarVersion();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //Se define el nombre de la pantalla para UXCAM
    FlutterUxcam.tagScreenName('HelpPage');
    final provider = Provider.of<OpcionesBard>(context);
    final size = MediaQuery.of(context).size;
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: locale.toString());
    return Scaffold(
        appBar: AppBar(
          title: Text('Soporte',
              style: TextStyle(
                  color: HexColor("#43398E"), fontWeight: FontWeight.bold)),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
        ),
        body: Center(
          child: Column(children: [
            Container(
              padding: const EdgeInsets.all(14.0),
              width: size.width * 0.9,
              height: size.height * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              margin: EdgeInsets.only(top: 14),
              child: Center(
                child: Container(
                  width: size.width * 0.9,
                  child: ListView(
                    children: [
                      FutureBuilder(
                        future: DBProviderHelper.db.consultarDatosCliente(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<dynamic>> snapshot) {
                          if (snapshot.hasData) {
                            var data = snapshot.data;
                            return Column(
                              children: [
                                for (int i = 0; i < data!.length; i++)
                                  Column(
                                    children: [
                                      Text(
                                        "Soporte aplicativo",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      FutureBuilder(
                                          future: DBProviderHelper.db
                                              .cargarTelefotosSoporte(1),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<List<dynamic>>
                                                  snapshot) {
                                            if (snapshot.hasData) {
                                              var datos = snapshot.data;
                                              return Column(children: [
                                                for (int i = 0;
                                                    i < datos!.length;
                                                    i++)
                                                  SimpleCardCall(
                                                    texto: datos[i].descripcion,
                                                    telefono: datos[i].telefono,
                                                  ),
                                              ]);
                                            } else {
                                              return CircularProgressIndicator();
                                            }
                                          }),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Soporte de pedidos de fabricantes",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      FutureBuilder(
                                          future: DBProviderHelper.db
                                              .cargarTelefotosSoporte(2),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<List<dynamic>>
                                                  snapshot) {
                                            if (snapshot.hasData) {
                                              var datos = snapshot.data;
                                              return Column(children: [
                                                for (int i = 0;
                                                    i < datos!.length;
                                                    i++)
                                                  SimpleCardCall(
                                                    texto: datos[i].descripcion,
                                                    telefono: datos[i].telefono,
                                                  ),
                                              ]);
                                            } else {
                                              return CircularProgressIndicator();
                                            }
                                          }),
                                      SizedBox(
                                        height: Get.height * 0.08,
                                      ),
                                    ],
                                  )
                              ],
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ));
  }

  showLoaderDialog(BuildContext context, size, Widget widget, double altura) {
    AlertDialog alert = AlertDialog(
        content: Container(
            height: altura,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
            ),
            child: widget));
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
