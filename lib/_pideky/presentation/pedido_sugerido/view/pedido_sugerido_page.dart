import 'package:emart/_pideky/domain/pedido_sugerdio/service/pedido_sugerido.dart';
import 'package:emart/_pideky/infrastructure/pedido_sugerdio/pedido_sugerido_query.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:emart/_pideky/presentation/pedido_sugerido/view/widgets/top_buttons.dart';
import 'package:emart/_pideky/presentation/pedido_sugerido/view_model/pedido_sugerido_controller.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import '../../../../src/utils/util.dart';
import 'widgets/appbarr_pedido_sugerido.dart';
import 'widgets/body_pedido_sugerido.dart';

class PedidoSugeridoPage extends StatefulWidget {
  const PedidoSugeridoPage({Key? key}) : super(key: key);

  @override
  State<PedidoSugeridoPage> createState() => _PedidoSugeridoPageState();
}

class _PedidoSugeridoPageState extends State<PedidoSugeridoPage> {
  @override
  void initState() {
    super.initState();
    validarVersionActual(context);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PedidoSugeridoController>();
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ConstantesColores.color_fondo_gris,
        appBar: PreferredSize(
            preferredSize: Size(double.infinity, kToolbarHeight),
            child: AppBarPedidoSugerido(size: size)),
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
