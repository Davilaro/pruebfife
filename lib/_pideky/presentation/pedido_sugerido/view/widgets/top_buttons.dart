import 'package:emart/_pideky/presentation/pedido_sugerido/view_model/pedido_sugerido_controller.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PedidoSugeridoController>();
    final selectedColor = Colors.yellow;
    return Obx(() => (Padding(
        padding: const EdgeInsets.fromLTRB(3, 0, 3, 20),
        child: TabBar(
          indicatorColor: Colors.transparent,
          unselectedLabelColor: Colors.black,
          isScrollable: false,
          controller: controller.controller,
          onTap: (index) {
            controller.cambiarTab(index);
            print('tap$index');
          },
          tabs: List.generate(
              2,
              (index) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
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
                        controller.titulosSeccion[index].toString(),
                        style: TextStyle(
                            color: ConstantesColores.azul_precio,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
        ))));
  }
}
