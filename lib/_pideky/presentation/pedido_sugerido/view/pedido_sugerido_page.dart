import 'package:emart/src/pages/pedido_rapido/pedido_rapido.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:emart/_pideky/presentation/pedido_sugerido/view_model/pedido_sugerido_controller.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'widgets/appbarr_pedido_sugerido.dart';

class PedidoSugeridoPage extends StatelessWidget {
  const PedidoSugeridoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PedidoSugeridoController());
    final size = MediaQuery.of(context).size;
    final selectedColor = Colors.yellow;
    return Obx(() => DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: ConstantesColores.color_fondo_gris,
            appBar: PreferredSize(
                preferredSize: Size(double.infinity, kToolbarHeight),
                child: AppBarPedidoSugerido(size: size)),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                      child: TabBar(
                        indicatorColor: Colors.transparent,
                        unselectedLabelColor: Colors.black,
                        isScrollable: false,
                        controller: controller.controller,
                        onTap: (index) {
                          controller.cambiarTab(index);
                          print(index);
                        },
                        tabs: List.generate(
                            2,
                            (index) => Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: controller.tabActual.value == index
                                        ? selectedColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      controller.titulosSeccion[index]
                                          .toString(),
                                      style: TextStyle(
                                          color: ConstantesColores.azul_precio,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                      )),
                  Expanded(
                      child: TabBarView(
                          controller: controller.controller,
                          children: [
                        Container(
                          color: Colors.red,
                        ),
                        PedidoRapido()
                      ]))
                ],
              ),
            ),
          ),
        ));
  }
}
