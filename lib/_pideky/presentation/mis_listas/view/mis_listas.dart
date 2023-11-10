import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';

class MisListas extends StatelessWidget {
  const MisListas({key});

  @override
  Widget build(BuildContext context) {
    //UXCAM: Se define el nombre de la interfaz
    FlutterUxcam.tagScreenName('RepeatOrder');
    //FIREBASE: Llamamos el evento select_content
    TagueoFirebase().sendAnalityticSelectContent(
        "Footer", "MisListas", "", "", "MisListas", 'MainActivity');
    //Se define el nombre de la pantalla para UXCAM
    FlutterUxcam.tagScreenName('RepeatOrderPage');
    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Tus listas de compras favoritas listas para que hagas un pedido más rápido y sencillo.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: ConstantesColores.gris_oscuro,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.document_scanner_rounded,
                      size: 35,
                      color: ConstantesColores.azul_precio,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Crear nueva lista',
                      style: TextStyle(
                          fontSize: 16,
                          color: ConstantesColores.azul_precio,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
