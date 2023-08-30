import 'package:emart/_pideky/presentation/mis_pedidos/view/widgets/body_mis_pedidos.dart';

import 'package:emart/_pideky/presentation/mis_pedidos/view_model/mis_pedidos_view_model.dart';

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
    misPedidosViewModel.tabActual.value = 0;
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
    final selectedColor = Colors.yellow;
    return Obx(() => DefaultTabController(
          length: misPedidosViewModel.titulosSeccion.length,
          child: Scaffold(
            backgroundColor: ConstantesColores.color_fondo_gris,
            body: Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  children: [
                    TabBar(
                        controller: misPedidosViewModel.tabController,
                        labelPadding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 15),
                        indicatorColor: Colors.transparent,
                        unselectedLabelColor: Colors.black,
                        splashFactory: NoSplash.splashFactory,
                        onTap: (index) {
                          //     //UXCam: Llamamos el evento selectSectionMisPedidos
                          UxcamTagueo().selectSectionMisPedidos(
                              misPedidosViewModel.titulosSeccion[index]);
                          misPedidosViewModel.cambiarTab(index);
                        },
                        tabs: List<Widget>.generate(
                            misPedidosViewModel.titulosSeccion.length, (index) {
                          return Tab(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              height: 50,
                              decoration: BoxDecoration(
                                color:
                                    misPedidosViewModel.tabActual.value == index
                                        ? selectedColor
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  misPedidosViewModel.titulosSeccion[index],
                                  style: TextStyle(
                                      color: ConstantesColores.azul_precio,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        })),
                    BodyMisPedidos(misPedidosViewModel: misPedidosViewModel)
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
