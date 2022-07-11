import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

final prefs = new Preferencias();
NumberFormat formatNumber = new NumberFormat("#,##0.00", "es_AR");

class Soporte extends StatefulWidget {
  final int numEmpresa;
  const Soporte({Key? key, required this.numEmpresa}) : super(key: key);

  @override
  _SoporteState createState() => _SoporteState();
}

class _SoporteState extends State<Soporte> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Se define el nombre de la pantalla para UXCAM
    FlutterUxcam.tagScreenName('HelpPage');

    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: ConstantesColores.color_fondo_gris,
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
        body: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              FutureBuilder(
                future: DBProviderHelper.db.cargarTelefotosSoporte(3),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    var contactoWhatsap = snapshot.data![1].telefono;
                    var contactoCel = snapshot.data![0].telefono;
                    var soportEmail = snapshot.data![1].correo;
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ConstantesColores.color_fondo_gris,
                      ),
                      margin: EdgeInsets.only(top: 14),
                      child: Center(
                        child: Container(
                            width: size.width * 0.9,
                            child: Column(
                              children: [
                                Text(
                                  "¿Necesitas ayuda?",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "Si requiere ayuda con tu proceso de compra o soporte técnico, puedes comunicarte a estos canales presionando cualquiera de estas opciones.",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: size.width * 0.45,
                                        margin: EdgeInsets.only(right: 10),
                                        child: Text(
                                          "Contáctanos en WhatsApp",
                                          textAlign: TextAlign.left,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () => launch(
                                              'https://api.whatsapp.com/send?phone=+57$contactoWhatsap'),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 50,
                                                margin:
                                                    EdgeInsets.only(left: 15),
                                                child: Image.asset(
                                                  'assets/icon/whatsapp_logo.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                child: Text(
                                                  "Empezar el chat",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: ConstantesColores
                                                          .gris_textos,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: size.width * 0.45,
                                        child: Text(
                                          "Llámanos a nuestra línea",
                                          textAlign: TextAlign.left,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            launch("tel://$contactoCel"),
                                        child: Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 50,
                                                  margin:
                                                      EdgeInsets.only(left: 30),
                                                  child: Image.asset(
                                                    'assets/icon/cell_logo.png',
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 10),
                                                  width: size.width * 0.4,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "Llamar ",
                                                        maxLines: 3,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            color:
                                                                ConstantesColores
                                                                    .gris_textos,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        "$contactoCel",
                                                        maxLines: 3,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            color:
                                                                ConstantesColores
                                                                    .gris_textos,
                                                            fontSize: 13),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: size.width * 0.45,
                                        margin: EdgeInsets.only(right: 10),
                                        child: Text(
                                          "Escríbenos al correo",
                                          textAlign: TextAlign.left,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () => launch(
                                              "mailto:$soportEmail?subject=&body="),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 70,
                                                margin:
                                                    EdgeInsets.only(left: 15),
                                                child: Image.asset(
                                                  'assets/icon/email_logo.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  "Escribir ahora",
                                                  textAlign: TextAlign.left,
                                                  maxLines: 3,
                                                  style: TextStyle(
                                                      color: ConstantesColores
                                                          .gris_textos,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                width: size.width * 0.4,
                                                child: Text(
                                                  "$soportEmail",
                                                  textAlign: TextAlign.left,
                                                  maxLines: 3,
                                                  style: TextStyle(
                                                      color:
                                                          HexColor('#5cbb96'),
                                                      fontSize: 13,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                              ],
                            )),
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )
            ]),
          ),
        ));
  }
}
