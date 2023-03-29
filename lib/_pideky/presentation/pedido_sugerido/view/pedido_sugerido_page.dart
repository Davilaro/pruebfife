import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';

import 'package:get/get.dart';

import 'package:emart/_pideky/presentation/pedido_sugerido/view/widgets/top_buttons.dart';
import 'package:emart/_pideky/presentation/pedido_sugerido/view_model/pedido_sugerido_view_model.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import '../../../../src/utils/util.dart';
import 'widgets/body_pedido_sugerido.dart';

class PedidoSugeridoPage extends StatefulWidget {
  const PedidoSugeridoPage({Key? key}) : super(key: key);

  @override
  State<PedidoSugeridoPage> createState() => _PedidoSugeridoPageState();
}

class _PedidoSugeridoPageState extends State<PedidoSugeridoPage> {
  final controller = Get.find<PedidoSugeridoViewModel>();
  final prefs = Preferencias();
  @override
  void initState() {
    validarVersionActual(context);
    //Se define el nombre de la pantalla para UXCAM
    FlutterUxcam.tagScreenName('SuggestedOrderPage');
    //UXCam: Llamamos el evento selectFooter
    UxcamTagueo().selectFooter('Pedido Sugerido');
    if (prefs.usurioLogin == -1) {
      controller.initController();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ConstantesColores.color_fondo_gris,
        body: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
              children: [
                TopButtons(),
                BodyPedidoSugerido(controller: controller)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
