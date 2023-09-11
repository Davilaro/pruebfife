import 'package:emart/src/modelos/fabricante.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControlBaseDatos extends GetxController {
  RxInt cambioTab = 0.obs;
  RxInt cambioTab2 = 0.obs;
  var seccionesDinamicas = [].obs;
  RxList<Fabricante> imagenesProveedor = <Fabricante>[].obs;
  RxBool isDisponibleFiltro = true.obs;

  late TabController tabController;
  // late TabController tabController2;

  void cargarSecciones(dynamic value) {
    seccionesDinamicas.value = value;
  }
  void cargoBaseDatos(int estado) {
    this.cambioTab.value = estado;
  }

  void initControllertabController(TabController controller) {
    tabController = controller;
  }
  void initControllertabController2(TabController controller) {
    // tabController2 = controller;
  }

  static ControlBaseDatos get findOrInitialize {
    try {
      return Get.find<ControlBaseDatos>();
    } catch (e) {
      Get.put(ControlBaseDatos());
      return Get.find<ControlBaseDatos>();
    }
  }
}
