import 'package:emart/_pideky/presentation/suggested_order/view/widgets/acordion_pedido_sugerido.dart';
import 'package:emart/_pideky/presentation/suggested_order/view/widgets/top_text.dart';
import 'package:emart/_pideky/presentation/suggested_order/view_model/suggested_order_view_model.dart';
import 'package:emart/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';

class BodyPedidoSugerido extends StatelessWidget {
  const BodyPedidoSugerido({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SuggestedOrderViewModel controller;

  @override
  Widget build(BuildContext context) {
    //Se define el nombre de la pantalla para UXCAM
    FlutterUxcam.tagScreenName('SuggestedOrderPage');
    return 
      SingleChildScrollView(
    child: Column(
      children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            // ignore: unrelated_type_equality_checks
            child: Obx(() => SuggestedOrderViewModel.userLog.value == 1
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TopText(message: S.current.we_have_a_suggested),
                      ...acordionDinamico(context)
                    ],
                  )
                : Container(
                    child:
                        TopText(message: S.current.we_have_a_suggested),
                  ))),
      ],
    ),
      );
      
    
  }
}
