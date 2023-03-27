import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MisPedidosViewModel extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  RxMap listaProductosPorFabricante = {}.obs;
  RxInt tabActual = 0.obs;
  final List titulosSeccion = ["Histórico", "En tránsito"];

  void cambiarTab(int estado) {
    this.tabActual.value = estado;
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    // clearList();
    // initController();
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
  }

  // static MisPedidosViewModel get findOrInitialize {
  //   try {
  //     return Get.find<MisPedidosViewModel>();
  //   } catch (e) {
  //     Get.put(MisPedidosViewModel(
  //         PedidoSugeridoServicio(MisPedidosQuery())));
  //     return Get.find<MisPedidosViewModel>();
  //   }
  // }
}
