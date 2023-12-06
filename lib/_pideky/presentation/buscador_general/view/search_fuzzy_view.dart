import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/presentation/buscador_general/view_model/search_fuzzy_view_model.dart';
import 'package:emart/_pideky/presentation/buscador_general/widgets/busquedas_recientes.dart';
import 'package:emart/shared/widgets/buscador_general.dart';
import 'package:emart/shared/widgets/drawer_sucursales.dart';
import 'package:emart/shared/widgets/new_app_bar.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SearchFuzzyView extends StatelessWidget {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  final searchFuzzyViewModel = Get.find<SearchFuzzyViewModel>();

  final cargoConfirmar = Get.find<CambioEstadoProductos>();

  final bool search = true;

  @override
  Widget build(BuildContext context) {
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
                      BuscadorGeneral(),
                    ],
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Obx(() => Text(
                  searchFuzzyViewModel.searchInput.value.isEmpty
                      ? 'Estás buscando en todas las secciones'
                      : 'Estás buscando "${searchFuzzyViewModel.searchInput.value}" en todas las secciones',
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
                            width: Get.width * 0.9,
                            child: ListView.builder(
                              itemCount: 10,
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
                                                CachedNetworkImage(
                                                  height: Get.height * 0.07,
                                                  imageUrl: searchFuzzyViewModel
                                                      .iconoSugeridos(
                                                          palabrabuscada:
                                                              searchFuzzyViewModel
                                                                      .allResultados[
                                                                  position])
                                                      .toString(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image.asset(
                                                    'assets/image/logo_login.png',
                                                    width: Get.width * 0.05,
                                                  ),
                                                  fit: BoxFit.fill,
                                                ),
                                                SizedBox(
                                                  width: Get.width * 0.05,
                                                ),
                                                SizedBox(
                                                  width: Get.width * 0.4,
                                                  child: AutoSizeText(
                                                    searchFuzzyViewModel
                                                        .nombreSugeridos(
                                                            palabrabuscada:
                                                                searchFuzzyViewModel
                                                                        .allResultados[
                                                                    position],
                                                            conDistintivo:
                                                                true)!,
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
                                                vertical: Get.height * 0.05),
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
