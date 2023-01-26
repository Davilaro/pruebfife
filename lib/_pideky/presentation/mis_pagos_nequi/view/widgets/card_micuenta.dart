import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/widgets/acordion.dart';
import '../../../../../src/preferences/cont_colores.dart';
import '../../view_model/mis_pagos_nequi_controller.dart';

class CardMicuenta extends StatelessWidget {
  const CardMicuenta({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final MisPagosNequiController controller;

  @override
  Widget build(BuildContext context) {
    return Acordion(
        elevation: 0,
        margin: 0,
        title: Text(
          "Mi Cuenta",
          style: TextStyle(
              color: ConstantesColores.gris_oscuro,
              fontWeight: FontWeight.w600,
              fontSize: 18),
        ),
        contenido: Container(
          width: Get.width * 0.99,
          padding: EdgeInsets.only(left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "#Nequi donde te consignan tus Pagos",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: ConstantesColores.gris_oscuro),
              ),
              SizedBox(
                height: 2,
              ),
              Obx(() => Text(
                    "Celular ${controller.numeroCelular.value}",
                    style: TextStyle(
                        color: ConstantesColores.gris_textos),
                  )),
            ],
          ),
        ));
  }
}