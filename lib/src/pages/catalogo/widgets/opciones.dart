// ignore_for_file: invalid_use_of_protected_member

import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/modelos/seccion.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BtnOpciones extends StatelessWidget {
  BtnOpciones({
    Key? key,
    required this.size,
    required this.provider,
  }) : super(key: key);

  final Size size;
  final OpcionesBard provider;
  final cargoConfirmar = Get.find<ControlBaseDatos>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => cargoConfirmar.seccionesDinamicas.isEmpty
            ? SizedBox.shrink()
            : Row(
                children: _cargarSecciones(
                    cargoConfirmar.seccionesDinamicas.value, context)),
      ),
    );
  }

  List<Widget> _cargarSecciones(
      List<dynamic> listaSecciones, BuildContext context) {
    final List<Widget> opciones = [];
    for (var i = 0; i < listaSecciones.length; i++) {
      Seccion seccion = listaSecciones[i];
      opciones.add(SizedBox(
          height: 44,
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(10.0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                  onPressed: () => {
                        //FIREBASE: Llamamos el evento select_content
                        TagueoFirebase().sendAnalityticSelectContent(
                            "Header",
                            "${seccion.descripcion}",
                            "",
                            "",
                            "${seccion.descripcion}",
                            "PrincipalPage"),
                        //UXCam: Llamamos el evento selectSeccion
                        UxcamTagueo()
                            .selectSeccion(seccion.descripcion.toString()),
                        provider.selectOptionMenu = 1,
                        provider.setIsLocal = 0,
                        cargoConfirmar.tabController.index = i,
                        cargoConfirmar.cargoBaseDatos(i),
                      },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  child: Text('${seccion.descripcion}')),
            ),
          )));
    }
    return opciones;
  }
}
