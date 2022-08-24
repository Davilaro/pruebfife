import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class IconoLimpiarFiltro {
  Widget iconLimpiarFiltro(Function()? onpressed) {
    return OutlineButton(
      borderSide: BorderSide(style: BorderStyle.none),
      onPressed: onpressed,
      child: Row(
        children: [
          Image.asset(
            'assets/limpiar_filtro_img.png',
            width: Get.width * 0.07,
          ),
          SizedBox(
            width: 2,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Limpiar',
                style: TextStyle(
                  color: HexColor("#43398E"),
                ),
              ),
              Text(
                'Filtro',
                style: TextStyle(
                  color: HexColor("#43398E"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
