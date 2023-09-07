import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:emart/_pideky/domain/marca/model/marca.dart';
import 'package:emart/_pideky/domain/marca/service/marca_service.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/_pideky/domain/producto/service/producto_service.dart';
import 'package:emart/_pideky/infrastructure/marcas/marca_repository_sqlite.dart';
import 'package:emart/_pideky/infrastructure/productos/producto_repository_sqlite.dart';
import 'package:emart/_pideky/presentation/buscador_general/view_model/search_fuzzy_view_model.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/src/modelos/categorias.dart';
import 'package:emart/src/modelos/fabricantes.dart';
import 'package:emart/src/pages/principal_page/widgets/custom_buscador_fuzzy.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultadoBuscadorGeneralVm extends GetxController {
  final prefs = new Preferencias();
  final TextEditingController controllerUser = TextEditingController();
  final searchFuzzyViewModel = Get.put(SearchFuzzyViewModel());
  final RxBool isPromo = false.obs;
  final catalogSearchViewModel = Get.find<ControllerProductos>();

  ProductoService productService = ProductoService(ProductoRepositorySqlite());
  MarcaService marcaService = MarcaService(MarcaRepositorySqlite());

  RxString searchInput = "".obs;

  RxList<Producto> listaProductos = <Producto>[].obs;

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
}
