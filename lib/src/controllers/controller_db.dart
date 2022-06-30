import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControlBaseDatos extends GetxController {
  RxInt cambioTab = 0.obs;
  var seccionesDinamicas = [].obs;

  late TabController tabController;

  void cargarSecciones(dynamic value) {
    seccionesDinamicas.value = value;
  }

  void cargoBaseDatos(int estado) {
    this.cambioTab.value = estado;
  }

  void initControllertabController(TabController controller) {
    tabController = controller;
  }
}
