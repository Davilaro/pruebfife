import 'dart:async';
import 'package:emart/src/pages/login/widgets/lista_sucursales.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/crear_file.dart';
import 'package:emart/src/widget/alerta_actualizar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class BotonActualizar extends StatefulWidget {
  @override
  State<BotonActualizar> createState() => _BotonActualizarState();
}

class _BotonActualizarState extends State<BotonActualizar> {
  RxBool isActualizando = false.obs;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 0),
      child: IconButton(
          onPressed: () async {
            isActualizando.value = true;
            if (isActualizando.value) {
              AlertaActualizar().mostrarAlertaActualizar(context, true);
            }
            var cargo = await AppUtil.appUtil.downloadZip(
                prefs.usurioLoginCedula,
                prefs.codCliente,
                prefs.codigonutresa,
                prefs.codigozenu,
                prefs.codigomeals,
                false);
            await AppUtil.appUtil.abrirBases();
            isActualizando.value = false;
            if (isActualizando.value == false) {
              Navigator.pop(context);
              AlertaActualizar().mostrarAlertaActualizar(context, false);
              await new Future.delayed(new Duration(seconds: 1), () {
                Navigator.pop(context);
                //pop dialog
              });
              //setState(() {});

              Navigator.pushReplacementNamed(
                context,
                'tab_opciones',
              );
              // Add Your Code here.

            }
          },
          icon: Icon(
            Icons.refresh_sharp,
            color: ConstantesColores.azul_precio,
            size: Get.height * 0.04,
          )),
    );
  }
}
