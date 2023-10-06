import 'package:emart/_pideky/domain/marca/service/marca_service.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/_pideky/domain/producto/service/producto_service.dart';
import 'package:emart/_pideky/infrastructure/marcas/marca_repository_sqlite.dart';
import 'package:emart/_pideky/infrastructure/productos/producto_repository_sqlite.dart';
import 'package:emart/_pideky/presentation/buscador_general/view_model/search_fuzzy_view_model.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultadoBuscadorGeneralVm extends GetxController {
  final TextEditingController controllerUser = TextEditingController();
  final searchFuzzyViewModel = Get.find<SearchFuzzyViewModel>();
  final RxBool isPromo = false.obs;
  final catalogSearchViewModel = Get.find<ControllerProductos>();

  ProductoService productService = ProductoService(ProductoRepositorySqlite());
  MarcaService marcaService = MarcaService(MarcaRepositorySqlite());

  RxString searchInput = "".obs;

  RxList<Producto> listaProductos = <Producto>[].obs;

  var selectedButton = ''.obs;

  void initState() {
    searchInput.value = searchFuzzyViewModel.searchInput.value;
    listaProductos.value = [];
  }

  void runFilter(String enteredKeyword) {
    searchFuzzyViewModel.runFilter(enteredKeyword);
  }

  void cargarProductosPromo() async {
    searchFuzzyViewModel.allResultados.value =
        await productService.cargarProductosInterno(
            1,
            searchFuzzyViewModel.controllerUser.text,
            catalogSearchViewModel.precioMinimo.value,
            catalogSearchViewModel.precioMaximo.value,
            0,
            "",
            "");
  }

  void cargarProductosImperdibles() async {
    searchFuzzyViewModel.allResultados.value =
        await productService.cargarProductosInterno(
      2,
      searchFuzzyViewModel.controllerUser.text,
      catalogSearchViewModel.precioMinimo.value,
      catalogSearchViewModel.precioMaximo.value,
      0,
      "",
      "",
    );
  }

  void setSelectedButton(String buttonName) {
    selectedButton.value = buttonName;
  }
}
