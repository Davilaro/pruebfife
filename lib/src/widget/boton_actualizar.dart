import 'dart:async';
import 'dart:io';
import 'package:emart/src/pages/login/widgets/lista_sucursales.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/crear_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BotonActualizar extends StatefulWidget {
  @override
  State<BotonActualizar> createState() => _BotonActualizarState();
}

class _BotonActualizarState extends State<BotonActualizar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 0),
      child: IconButton(
          onPressed: () async {
            var cargo = await AppUtil.appUtil.downloadZip(
                usuariLogin!,
                prefs.codCliente,
                prefs.codigonutresa,
                prefs.codigozenu,
                prefs.codigomeals,
                false);
            await AppUtil.appUtil.abrirBases();
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                String plataforma = Platform.isAndroid ? 'Android' : 'Ios';
                //para mostrar el circular de ios o de andropid

                return Dialog(
                  child: Container(
                    margin: EdgeInsets.only(top: 15, bottom: 15),
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        plataforma == 'Android'
                            ? CircularProgressIndicator()
                            : CupertinoActivityIndicator(),
                        Text("Actualizando..."),
                      ],
                    ),
                  ),
                );
              },
            );
            new Future.delayed(new Duration(seconds: 5), () {
              Navigator.pop(context); //pop dialog
            });
          },
          icon: Icon(
            Icons.replay_circle_filled_sharp,
            color: ConstantesColores.azul_precio,
            size: Get.height * 0.05,
          )),
    );
  }
}
