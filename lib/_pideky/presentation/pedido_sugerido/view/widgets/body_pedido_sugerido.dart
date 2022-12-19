// ignore_for_file: unnecessary_null_comparison

import 'package:emart/_pideky/presentation/pedido_sugerido/view/widgets/acordion_pedido_sugerido.dart';
import 'package:emart/_pideky/presentation/pedido_sugerido/view/widgets/top_text.dart';
import 'package:emart/_pideky/presentation/pedido_sugerido/view_model/pedido_sugerido_controller.dart';
import 'package:emart/src/pages/pedido_rapido/pedido_rapido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BodyPedidoSugerido extends StatelessWidget {
  const BodyPedidoSugerido({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final PedidoSugeridoController controller;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Expanded(
          child: TabBarView(controller: controller.controller, children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Obx(() => controller.usuarioLogueado.value != ""
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [TopText(), ...acordionDinamico(context)],
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Text("Inicia sesión para habilitar esta vista",
                            style: TextStyle(
                              color: ConstantesColores.gris_oscuro,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center),
                      )),
              ),
            ],
          ),
        ),
        PedidoRapido()
      ])),
    );
  }
}
