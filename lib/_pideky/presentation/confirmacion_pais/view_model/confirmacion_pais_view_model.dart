import 'package:auto_size_text/auto_size_text.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/src/pages/principal_page/tab_opciones.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:flutter/material.dart';
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

  confirmarPais(String pais) async {
    prefs.paisUsuario = pais;
    S.load(Locale('es', pais));
    Get.off(() => TabOpciones());
  }
}
