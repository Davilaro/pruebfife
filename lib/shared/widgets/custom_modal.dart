// ignore_for_file: must_be_immutable

import 'package:emart/generated/l10n.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomModal extends StatelessWidget {
  Widget? icon;
  String? titulo;
  String mensaje;
  bool visibilityFirstBtn;
  bool visibilitySecondBtn;
  String? textFirstBtn;
  String? textSecondBtn;
  Function()? onTapFirsBtn;
  Function()? onTapSecodBtn;
  TextStyle? styleMensaje;
  TextStyle? styleTitulo;

  CustomModal(
      {key,
      this.icon,
      this.titulo,
      required this.mensaje,
      this.visibilityFirstBtn = true,
      this.visibilitySecondBtn = true,
      this.onTapFirsBtn,
      this.onTapSecodBtn,
      this.textFirstBtn,
      this.textSecondBtn,
      this.styleMensaje,
      this.styleTitulo});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Column(
                  children: [
                    icon ??
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 70,
                          color: ConstantesColores.agua_marina,
                        ),
                    titulo != null
                        ? Container(
                            margin: EdgeInsets.only(bottom: 12),
                            child: Text(
                              titulo!,
                              style: styleTitulo ??
                                  TextStyle(
                                      color: ConstantesColores.azul_precio,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Container(),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 15),
                      child: Text(
                        mensaje,
                        style: styleMensaje ??
                            TextStyle(
                                color: ConstantesColores.gris_textos,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Visibility(
                        visible: visibilityFirstBtn,
                        child: _customButton(
                            textFirstBtn ?? S.current.accept, onTapFirsBtn)),
                    Visibility(
                        visible: visibilitySecondBtn,
                        child: _customButton(
                            textSecondBtn ?? S.current.cancel, onTapSecodBtn)),
                  ],
                )
              ],
            ))
      ],
    );
  }

  Widget _customButton(String? textBtn, Function()? onTapBtn) {
    return GestureDetector(
      onTap: onTapBtn ?? () => null,
      child: Container(
        width: Get.width * 0.9,
        height: 45,
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: 10,
        ),
        decoration: BoxDecoration(
          color: ConstantesColores.azul_aguamarina_botones,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(textBtn!,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
