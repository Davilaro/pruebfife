import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/_pideky/presentation/buscador_general/view_model/search_fuzzy_view_model.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/widget/input_valores_catalogo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultadoBuscadorGeneralVm extends GetxController {
  final prefs = new Preferencias();
  final TextEditingController controllerUser = TextEditingController();
  final searchFuzzyViewModel = Get.put(SearchFuzzyViewModel());

  RxString searchInput = "".obs;

  RxList<Producto> listaProductos = <Producto>[].obs;

  void initState() {
    searchInput.value = searchFuzzyViewModel.searchInput.value;
  }

  void runFilter(String enteredKeyword) {
    searchFuzzyViewModel.runFilter(enteredKeyword);
  }

  void selecionarSoloProductos (List allResultados) {
    
    for (var i = 0; i < allResultados.length; i++) {
      if (allResultados[i] is Producto) {
        listaProductos.add(allResultados[i]);
      }
    }
  }

  cargarProductosLista(List<dynamic> data, BuildContext context) {
    final List<Widget> opciones = [];

    for (var i = 0; i < data.length; i++) {
      Producto productos = data[i];
      final widgetTemp = InputValoresCatalogo(
        element: productos,
        numEmpresa: 'nutresa',
        isCategoriaPromos: false,
        index: i,
      );

      opciones.add(widgetTemp);
    }
  
    return opciones;
  }




  irFiltro() async {
    // if (widget.locacionFiltro == "proveedor") {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => FiltroProveedor(
    //               codCategoria: widget.codCategoria!,
    //               nombreCategoria: widget.nombreCategoria!,
    //               urlImagen: widget.img,
    //               codigoProveedor: widget.codigoProveedor,
    //             )),
    //   );
    // }
    // if (widget.locacionFiltro == "marca") {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => FiltroPrecios(
    //               codMarca: widget.codigoMarca,
    //               nombreMarca: widget.nombreCategoria,
    //               urlImagen: widget.img,
    //             )),
    //   );
    // }
    // if (widget.locacionFiltro == "categoria") {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => FiltroCategoria(
    //               codCategoria: widget.codCategoria,
    //               nombreCategoria: widget.nombreCategoria,
    //               urlImagen: widget.img,
    //               codSubCategoria: widget.codCategoria,
    //             )),
    //   );
    // }

  }
}