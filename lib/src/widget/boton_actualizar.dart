import 'dart:async';
import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/pages/login/widgets/lista_sucursales.dart';
import 'package:emart/src/pages/principal_page/tab_opciones.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/crear_file.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:emart/src/widget/alerta_actualizar.dart';
import 'package:emart/src/widget/logica_actualizar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class BotonActualizar extends StatefulWidget {
  @override
  State<BotonActualizar> createState() => _BotonActualizarState();
}

RxBool isActualizando = false.obs;

class _BotonActualizarState extends State<BotonActualizar> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OpcionesBard>(context, listen: false);
    final cargoConfirmar = Get.find<ControlBaseDatos>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 0),
      child: IconButton(
          onPressed: () async {
            await actualizarPagina(provider, context, cargoConfirmar);
          },
          icon: Icon(
            Icons.refresh_sharp,
            color: ConstantesColores.azul_precio,
            size: Get.height * 0.04,
          )),
    );
  }
}

Future<void> actualizarPagina(
    dynamic provider, BuildContext context, dynamic cargoConfirmar) async {
  isActualizando.value = true;
  if (isActualizando.value) {
    AlertaActualizar().mostrarAlertaActualizar(context, true);
  }
  await LogicaActualizar().actualizarDB();
  isActualizando.value = false;
  if (isActualizando.value == false) {
    Navigator.pop(context);
    AlertaActualizar().mostrarAlertaActualizar(context, false);
    await new Future.delayed(new Duration(seconds: 1), () {
      Navigator.pop(context);
      //pop dialog
    });
    if (provider.selectOptionMenu == 1) {
      print("entro");
      cargoConfirmar.tabController.index = cargoConfirmar.cambioTab.value;
      cargoConfirmar.cargoBaseDatos(cargoConfirmar.cambioTab.value);
      provider.selectOptionMenu = 1;
      provider.setIsLocal = 0;
    }
    Navigator.pushReplacementNamed(
      context,
      'tab_opciones',
    ).timeout(Duration(seconds: 3));
  }
}
