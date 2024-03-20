import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/widgets/acordion.dart';
import '../../../../../src/preferences/cont_colores.dart';
import '../../view_model/my_payments_view_model.dart';

class CardMicuenta extends StatelessWidget {
  const CardMicuenta({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final MyPaymentsViewModel controller;

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
                "#Cuenta donde te consignan tus Pagos",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: ConstantesColores.gris_oscuro),
              ),
              SizedBox(
                height: 2,
              ),
              Obx(() => Text(
                    "Celular ${controller.numeroCelular.value}",
                    style: TextStyle(color: ConstantesColores.gris_textos),
                  )),
            ],
          ),
        ));
  }
}
