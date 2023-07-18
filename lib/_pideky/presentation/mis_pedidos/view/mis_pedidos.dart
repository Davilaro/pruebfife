import 'package:emart/_pideky/presentation/mis_pedidos/view/widgets/body_mis_pedidos.dart';
import 'package:emart/_pideky/presentation/mis_pedidos/view_model/mis_pedidos_view_model.dart';
import 'package:emart/shared/widgets/top_buttons.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../src/preferences/cont_colores.dart';

final prefs = new Preferencias();

class MisPedidosPage extends StatefulWidget {
  @override
  State<MisPedidosPage> createState() => _MisPedidosPageState();
}

class _MisPedidosPageState extends State<MisPedidosPage> {
  @override
  void initState() {
    if (prefs.usurioLogin == -1) {
      Future.delayed(Duration(seconds: 0)).then((value) {
        alertCustom(context);
      });
    }
    super.initState();
  }

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
                    //UXCam: Llamamos el evento selectSectionMisPedidos
                    UxcamTagueo().selectSectionMisPedidos(
                        misPedidosViewModel.titulosSeccion[index]);
                    misPedidosViewModel.cambiarTab(index);
                  },
                ),
                BodyMisPedidos(misPedidosViewModel: misPedidosViewModel)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
