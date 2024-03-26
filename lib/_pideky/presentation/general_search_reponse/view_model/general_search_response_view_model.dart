import 'package:emart/_pideky/domain/brand/use_cases/brand_use_cases.dart';
import 'package:emart/_pideky/domain/product/model/product_model.dart';
import 'package:emart/_pideky/domain/product/use_cases/producto_use_cases.dart';
import 'package:emart/_pideky/infrastructure/brand/brand_service.dart';
import 'package:emart/_pideky/infrastructure/product/product_service.dart';
import 'package:emart/_pideky/presentation/general_search/view_model/search_fuzzy_view_model.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GeneralSearchResponseViewModel extends GetxController {
  final TextEditingController controllerUser = TextEditingController();
  final searchFuzzyViewModel = Get.find<SearchFuzzyViewModel>();
  final RxBool isPromo = false.obs;
  final catalogSearchViewModel = Get.find<ControllerProductos>();

  ProductoService productService = ProductoService(ProductoRepositorySqlite());
  BrandUseCases marcaService = BrandUseCases(MarcaRepositorySqlite());

  RxString searchInput = "".obs;

  RxList<Product> listaProductos = <Product>[].obs;

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
