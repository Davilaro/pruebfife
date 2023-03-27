import 'package:emart/_pideky/presentation/mis_pedidos/view_model/mis_pedidos_view_model.dart';
import 'package:emart/shared/widgets/top_buttons.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../src/preferences/cont_colores.dart';

class MisPedidosPage extends StatefulWidget {
  @override
  State<MisPedidosPage> createState() => _MisPedidosPageState();
}

class _MisPedidosPageState extends State<MisPedidosPage> {
  final misPedidosViewModel = Get.find<MisPedidosViewModel>();
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
                TopButtons(
                  controllerViewModel: misPedidosViewModel,
                  onTap: (index) {
                    UxcamTagueo().selectSectionPedidoSugerido(
                        misPedidosViewModel.titulosSeccion[index]);
                    misPedidosViewModel.cambiarTab(index);
                  },
                ),
                // BodyPedidoSugerido(controller: controller)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
