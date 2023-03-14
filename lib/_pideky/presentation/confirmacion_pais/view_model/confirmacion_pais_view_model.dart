import 'package:auto_size_text/auto_size_text.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/src/notificaciones/push_notification.dart';
import 'package:emart/src/pages/principal_page/tab_opciones.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';

class ConfirmacionPaisViewModel {
  Map<String, String> listPais = {'CO': 'Colombia', 'CR': 'Costa Rica'};
  List<DropdownMenuItem<String>> listaItems = [];
  List<Widget> selectItem = [];
  final prefs = new Preferencias();

  cargarDropDawn() {
    listPais.forEach((key, value) {
      listaItems.add(
        DropdownMenuItem(
            child: AutoSizeText(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: ConstantesColores.azul_precio,
                  fontSize: 15,
                  fontWeight: FontWeight.normal),
            ),
            value: key),
      );

      selectItem.add(Container(
        alignment: Alignment.centerLeft,
        constraints: const BoxConstraints(minWidth: 100),
        child: Text(
          value,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ));
    });
  }

  confirmarPais(String pais) {
    try {
      FlutterUxConfig config;
      prefs.paisUsuario = pais;
      S.load(Locale('es', pais));
      FlutterUxcam.optIntoSchematicRecordings();
      if (Constantes().titulo == 'PRD' && pais == "CR") {
        config = FlutterUxConfig(
            userAppKey: "in25b6g0mzsiggt",
            enableAutomaticScreenNameTagging: false);
      } else if (Constantes().titulo == 'QA') {
        config = FlutterUxConfig(
            userAppKey: "s7xvg23hmx7ttcv",
            enableAutomaticScreenNameTagging: false);
      } else {
        config = FlutterUxConfig(
            userAppKey: "l0uak7nx63mtp1i",
            enableAutomaticScreenNameTagging: false);
      }
      FlutterUxcam.startWithConfiguration(config);
      PushNotificationServer.initializeApp();
      Get.off(() => TabOpciones());
    } catch (e) {
      print("error uxcam $e");
    }
  }
}
