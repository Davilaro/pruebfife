import 'package:emart/shared/widgets/barra_monto_minimo.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';




class BarraFaltanteMontoMin extends StatelessWidget {
  final double minimumAmount;
  final double currentAmount;
  final Widget? punteroBarra;
  

  BarraFaltanteMontoMin(
      {required this.minimumAmount, required this.currentAmount, this.punteroBarra});

  @override
  Widget build(BuildContext context) {
    double percentage = (currentAmount / minimumAmount).clamp(0.0, 1.0);

    return Container(
      //color: Colors.amber,        
      padding: EdgeInsets.only(right: Get.width * 0.060, left: Get.width * 0.090),
      width: Get.width * 0.900,
      height: Get.height * 0.060,
      child: LinearPercentIndicator(
       // padding: EdgeInsets.only(),
        animation: true,        
        animationDuration: 1250,
        // width: 300.0,
        lineHeight: Get.height * 0.0190,
        percent: percentage,
        barRadius: Radius.circular(10),
        backgroundColor: Colors.transparent,
        linearGradient: LinearGradient(colors: <Color>[
          HexColor("#FFE24B"),
          HexColor("EA7244"),
        ]),
        widgetIndicator: punteroBarra,
      ),
    );
  }
}
