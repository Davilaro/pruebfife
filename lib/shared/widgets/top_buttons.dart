import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopButtons extends StatelessWidget {
  final controllerViewModel;
  final Function(int)? onTap;
  TopButtons({required this.controllerViewModel, required this.onTap});
  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<PedidoSugeridoViewModel>();
    final selectedColor = Colors.yellow;
    return Obx(() => (Padding(
        padding: const EdgeInsets.fromLTRB(3, 0, 3, 20),
        child: TabBar(
          indicatorColor: Colors.transparent,
          unselectedLabelColor: Colors.black,
          isScrollable: false,
          controller: controllerViewModel.tabController,
          onTap: onTap,
          tabs: List.generate(
              2,
              (index) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    height: 45,
                    decoration: BoxDecoration(
                      color: controllerViewModel.tabActual.value == index
                          ? selectedColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        controllerViewModel.titulosSeccion[index].toString(),
                        style: TextStyle(
                            color: ConstantesColores.azul_precio,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
        ))));
  }
}
