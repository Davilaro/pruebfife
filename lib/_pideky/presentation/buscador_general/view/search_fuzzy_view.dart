import 'package:auto_size_text/auto_size_text.dart';
import 'package:emart/_pideky/domain/marca/model/marca.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/_pideky/presentation/buscador_general/view_model/search_fuzzy_view_model.dart';
import 'package:emart/_pideky/presentation/buscador_general/widgets/busquedas_recientes.dart';
import 'package:emart/_pideky/presentation/buscador_general/widgets/campo_texto.dart';
import 'package:emart/shared/widgets/drawer_sucursales.dart';
import 'package:emart/shared/widgets/new_app_bar.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/modelos/categorias.dart';
import 'package:emart/src/modelos/fabricantes.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SearchFuzzyView extends StatelessWidget {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  SearchFuzzyViewModel searchFuzzyViewModel = Get.put(SearchFuzzyViewModel());
  final cargoConfirmar = Get.find<CambioEstadoProductos>();

  @override
  Widget build(BuildContext context) {
    searchFuzzyViewModel.initState();
    final cartProvider = Provider.of<CarroModelo>(context);

    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      key: drawerKey,
      drawerEnableOpenDragGesture:
          searchFuzzyViewModel.prefs.usurioLogin == 1 ? true : false,
      drawer: DrawerSucursales(drawerKey),
      appBar: PreferredSize(
        preferredSize: searchFuzzyViewModel.prefs.usurioLogin == 1
            ? const Size.fromHeight(118)
            : const Size.fromHeight(70),
        child: SafeArea(child: NewAppBar(drawerKey)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FittedBox(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: ConstantesColores.agua_marina,
                          size: 30,
                        ),
                      ),
                      CampoTexto(),
                    ],
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Obx(() => Text(
                  searchFuzzyViewModel.searchInput.isEmpty
                      ? 'Estás buscando en todas las secciones'
                      : 'Estás buscando "${searchFuzzyViewModel.searchInput}" en todas las secciones',
                  style: TextStyle(
                      color: Colors.black.withOpacity(.5),
                      fontSize: 13,
                      fontWeight: FontWeight.bold))),
            ),
            SingleChildScrollView(
                child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Obx(
                    () => searchFuzzyViewModel.allResultados.isNotEmpty
                        ? Container(
                            height: 300,
                            child: ListView.builder(
                              itemCount:
                                  searchFuzzyViewModel.allResultados.length,
                              itemBuilder:
                                  (BuildContext context, int position) {
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        searchFuzzyViewModel.logicaSeleccion(
                                            searchFuzzyViewModel
                                                .allResultados[position],
                                            cargoConfirmar,
                                            cartProvider,
                                            context);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: Get.width * 0.15,
                                                  height: Get.height * 0.1,
                                                  child: Image.network(
                                                    searchFuzzyViewModel
                                                                    .allResultados[
                                                                position]
                                                            is Producto
                                                        ? Constantes()
                                                                .urlImgProductos +
                                                            '${searchFuzzyViewModel
                                                                    .allResultados[
                                                                position].codigo}.png'
                                                        : searchFuzzyViewModel
                                                                        .allResultados[
                                                                    position]
                                                                is Marca
                                                            ? searchFuzzyViewModel
                                                                .allResultados[
                                                                    position]
                                                                .ico
                                                            : searchFuzzyViewModel
                                                                            .allResultados[
                                                                        position]
                                                                    is Categorias
                                                                ? searchFuzzyViewModel
                                                                    .allResultados[
                                                                        position]
                                                                    .ico
                                                                : searchFuzzyViewModel
                                                                            .allResultados[
                                                                        position]
                                                                    is Fabricantes
                                                                    ? searchFuzzyViewModel
                                                                        .allResultados[
                                                                            position]
                                                                        .icono
                                                                    : 'Error',
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: Get.width * 0.05,
                                                ),
                                                SizedBox(
                                                  width: Get.width * 0.5,
                                                  child: AutoSizeText(
                                                    searchFuzzyViewModel
                                                                    .allResultados[
                                                                position]
                                                            is Producto
                                                        ? searchFuzzyViewModel
                                                            .allResultados[
                                                                position]
                                                            .nombre
                                                        : searchFuzzyViewModel
                                                                        .allResultados[
                                                                    position]
                                                                is Marca
                                                            ? searchFuzzyViewModel
                                                                .allResultados[
                                                                    position]
                                                                .nombre
                                                            : searchFuzzyViewModel
                                                                            .allResultados[
                                                                        position]
                                                                    is Categorias
                                                                ? searchFuzzyViewModel
                                                                    .allResultados[
                                                                        position]
                                                                    .descripcion
                                                                : searchFuzzyViewModel
                                                                            .allResultados[
                                                                        position]
                                                                    is Fabricantes
                                                                    ? searchFuzzyViewModel
                                                                        .allResultados[
                                                                            position]
                                                                        .nombrecomercial
                                                                    : 'Error',
                                                    minFontSize: 12,
                                                    style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(.4),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Get.width * 0.05,
                                                vertical: Get.height * 0.05
                                                ),
                                            child: Icon(
                                              Icons.search,
                                              color:
                                                  Colors.black.withOpacity(.4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider()
                                  ],
                                );
                              },
                            ))
                        : SizedBox.shrink(),
                  ),
                  Divider(),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Busquedas recientes",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Divider(),
                  BusquedasRecientes(),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
