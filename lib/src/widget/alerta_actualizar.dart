import 'dart:io';

import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlertaActualizar {
  void mostrarAlertaActualizar(BuildContext context, bool isActualizando) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String plataforma = Platform.isAndroid ? 'Android' : 'Ios';
        //para mostrar el indicador de progreso de ios o de andropid
        return Dialog(
          child: Container(
            margin: EdgeInsets.only(top: 15, bottom: 15),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isActualizando
                    ? plataforma == 'Android'
                        ? CircularProgressIndicator(
                            color: ConstantesColores.azul_precio,
                            backgroundColor: ConstantesColores.agua_marina,
                          )
                        : CupertinoActivityIndicator(
                            color: ConstantesColores.azul_precio,
                          )
                    : Icon(
                        Icons.check_circle,
                        color: ConstantesColores.azul_precio,
                        size: Get.height * 0.06,
                      ),
                SizedBox(
                  height: 10,
                ),
                Text("Sincronizando información...",
                    style: TextStyle(
                        color: ConstantesColores.azul_precio,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }
}
