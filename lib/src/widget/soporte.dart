import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
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
    var colorLetter = HexColor('#4f4f4f');

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
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "¿Necesitas ayuda?",
                                  style: TextStyle(
                                      color: colorLetter,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Text(
                                  "Si requiere ayuda con tu proceso de compra, de soporte técnico o necesitas eliminar tu cuenta, puedes comunicarte a estos canales presionando cualquiera de estas opciones.",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: colorLetter,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                // Contacto Whatsapp
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: size.width * 0.42,
                                        child: Text(
                                          "Contáctanos en WhatsApp",
                                          textAlign: TextAlign.left,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: colorLetter,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: GestureDetector(
                                            onTap: () => lanzarWhatssap(
                                                '$contactoWhatsap'),
                                            child: Column(
                                              children: [
                                                Container(
                                                  child: Image.asset(
                                                    'assets/icon/botones_soporte/whatsapp_img.png',
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                Text(
                                                  "Empezar el chat",
                                                  style: TextStyle(
                                                      color: ConstantesColores
                                                          .gris_textos,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                // Contacto Telefono
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: size.width * 0.42,
                                        child: Text(
                                          "Llámanos a nuestra línea",
                                          textAlign: TextAlign.left,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: colorLetter,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: GestureDetector(
                                            onTap: () =>
                                                lanzarLlamada("$contactoCel"),
                                            child: Column(
                                              children: [
                                                Container(
                                                  child: Image.asset(
                                                    'assets/icon/botones_soporte/telefono_img.png',
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Llamar ",
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                            color:
                                                                ConstantesColores
                                                                    .gris_textos,
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Expanded(
                                                        child: AutoSizeText(
                                                          "$contactoCel",
                                                          maxLines: 3,
                                                          style: TextStyle(
                                                              color: ConstantesColores
                                                                  .gris_textos,
                                                              fontSize: 11),
                                                        ),
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
                                // Contacto Correo
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: size.width * 0.42,
                                        child: Text(
                                          "Escríbenos al correo",
                                          textAlign: TextAlign.left,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: colorLetter,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: GestureDetector(
                                            onTap: () => {
                                                  //UXCam: Llamamos el evento selectSoport
                                                  UxcamTagueo().selectSoport(
                                                      'Correo Soporte'),
                                                  launch(
                                                      "mailto:$soportEmail?subject=&body="),
                                                },
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: Image.asset(
                                                    'assets/icon/botones_soporte/correo.png',
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                Text(
                                                  "Escribir ahora",
                                                  maxLines: 3,
                                                  style: TextStyle(
                                                      color: ConstantesColores
                                                          .gris_textos,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "$soportEmail",
                                                  maxLines: 3,
                                                  style: TextStyle(
                                                      color:
                                                          HexColor('#5cbb96'),
                                                      fontSize: 11,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                SizedBox(
                                  height: 50,
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

  Future<void> lanzarLlamada(String command) async {
    //UXCam: Llamamos el evento selectSoport
    UxcamTagueo().selectSoport('Llámar línea soporte');
    command = command.replaceAll(' ', '');
    String url = Platform.isIOS ? 'tel://$command' : 'tel://$command';

    try {
      if (Platform.isIOS) {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: new Text("No se puede llamar ahora")));
          throw 'Could not launch $url';
        }
      } else {
        await launch("tel://$command");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> lanzarWhatssap(String command) async {
    var whatappURL_ios = "https://wa.me/+57$command?text=${Uri.parse("Hola")}";

    //UXCam: Llamamos el evento selectSoport
    UxcamTagueo().selectSoport('Soporte Whatssap');
    try {
      if (Platform.isIOS) {
        // for iOS phone only
        if (await canLaunch(whatappURL_ios)) {
          await launch(whatappURL_ios, forceSafariVC: false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: new Text("whatsapp no instalado")));
        }
      } else {
        // android , web
        await launch('https://api.whatsapp.com/send?phone=+57$command');
      }
    } catch (e) {
      print(e);
    }
  }
}
