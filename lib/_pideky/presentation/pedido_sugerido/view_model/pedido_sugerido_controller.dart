import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PedidoSugeridoController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController controller;
  final List titulosSeccion = ["Pedido Sugerido", "Pedido Rápido"];
  RxInt tabActual = 0.obs;

  void cambiarTab(int estado) {
    this.tabActual.value = estado;
  }

  @override
  void onInit() {
    controller = TabController(length: 2, vsync: this, initialIndex: 0);
    super.onInit();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
