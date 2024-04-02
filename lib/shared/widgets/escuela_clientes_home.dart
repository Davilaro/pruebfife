import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class EscuelaClientes extends StatelessWidget {
  EscuelaClientes();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.49,
      width: double.infinity,
      //color: Colors.red,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Text(
                  'Desarrolla tu negocio',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: HexColor("#41398D"),
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                SvgPicture.asset(
                  'assets/image/logo-escuela-clientes-top.svg',
                  width: 90,
                )
              ],
            ),
          ),
          //Card escuela de clientes
          Container(
            height: Get.height * 0.2,
            width: Get.width * 0.95,
            decoration: BoxDecoration(
                color: Colors.black38, borderRadius: BorderRadius.circular(30)),
            child: Image.asset('assets/image/jar-loading.gif'),

          
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Si te apasiona el aprendizaje y quieres ver más contenido como este.',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 16.0,
                  color: HexColor("#41398D"),
                  fontWeight: FontWeight.bold),
            ),
          ),

          BotonAgregarCarrito(
            marginTop: 10,
            width: Get.width * 0.9,
            height: Get.height * 0.07,
            color: ConstantesColores.empodio_verde,
            onTap: () {
              _launchUrl();
            },
            text: 'Visita escuela de clientes',
            borderRadio: 30,
          )
        ],
      ),
    );
  }

  _launchUrl() async {
    const String url = 'https://escueladeclientesnutresa.com';
     final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'No se pudo abrir la URL $url';
    }
  }
}
