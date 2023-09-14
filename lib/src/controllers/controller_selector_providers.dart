
import 'package:emart/src/modelos/fabricantes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControllerSelectorProviders extends GetxController {
  final selectedProviders = <String>[].obs;
  final selectedFabricantes = <Fabricantes>[].obs;
  RxMap<String, TextEditingController> nitControllers =
      RxMap<String, TextEditingController>();

  void toggleProvider(String providerName) {
    if (selectedProviders.contains(providerName)) {
      // Si el proveedor ya está seleccionado, lo quitamos
      selectedProviders.remove(providerName);

      //  También eliminamos el controlador de texto asociado
      nitControllers.remove(providerName);
    } else {
      // Si el proveedor no está seleccionado, lo agregamos
      selectedProviders.add(providerName);

      // También creamos un nuevo controlador de texto
      nitControllers[providerName] = TextEditingController();
    }

    // Actualiza el estado de GetX
    update();
  }

  void toggleFabricantes(Fabricantes providerName) {
    if (selectedFabricantes.contains(providerName)) {
      // Si el proveedor ya está seleccionado, lo quitamos
      selectedFabricantes.remove(providerName);

      //  También eliminamos el controlador de texto asociado
      selectedFabricantes.remove(providerName);
    } else {
      // Si el proveedor no está seleccionado, lo agregamos
      selectedFabricantes.add(providerName);
    }

    // Actualiza el estado de GetX
    update();
  }

  TextEditingController? getNitController(String providerName) {
    return nitControllers[providerName];
  }

  @override
  void onClose() {
    // Cierra y elimina todos los controladores de texto al destruir el controlador
    nitControllers.values.forEach((controller) {
      controller.dispose();
    });
    super.onClose();
  }
}
