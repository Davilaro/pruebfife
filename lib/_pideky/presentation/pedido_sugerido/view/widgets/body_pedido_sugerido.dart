// ignore_for_file: unnecessary_null_comparison

import 'package:emart/_pideky/presentation/pedido_sugerido/view/widgets/acordion_pedido_sugerido.dart';
import 'package:emart/_pideky/presentation/pedido_sugerido/view/widgets/top_text.dart';
import 'package:emart/_pideky/presentation/pedido_sugerido/view_model/pedido_sugerido_controller.dart';
import 'package:emart/src/pages/pedido_rapido/pedido_rapido.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';

class BodyPedidoSugerido extends StatelessWidget {
  const BodyPedidoSugerido({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final PedidoSugeridoController controller;

  @override
  Widget build(BuildContext context) {
    //Se define el nombre de la pantalla para UXCAM
    FlutterUxcam.tagScreenName('SuggestedOrderPage');
    return WillPopScope(
      onWillPop: () async => false,
      child: Expanded(
          child: TabBarView(controller: controller.controller, children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  // ignore: unrelated_type_equality_checks
                  child: Obx(() => PedidoSugeridoController.userLog.value != -1
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [TopText(), ...acordionDinamico(context)],
                        )
                      : Container(
                          child: TopText(),
                        ))),
            ],
          ),
        ),
        PedidoRapido()
      ])),
    );
  }
}
