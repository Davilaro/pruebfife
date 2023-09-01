import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/domain/marca/model/marca.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/_pideky/presentation/buscador_general/view_model/search_fuzzy_view_model.dart';
import 'package:emart/src/modelos/categorias.dart';
import 'package:emart/src/modelos/fabricantes.dart';
import 'package:emart/src/pages/catalogo/widgets/tab_categorias_opciones.dart';
import 'package:emart/src/pages/principal_page/widgets/custom_buscador_fuzzy.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/widget/input_valores_catalogo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ResultadoBuscadorGeneralVm extends GetxController {
  final prefs = new Preferencias();
  final TextEditingController controllerUser = TextEditingController();
  final searchFuzzyViewModel = Get.put(SearchFuzzyViewModel());

  RxString searchInput = "".obs;

  RxList<Producto> listaProductos = <Producto>[].obs;

  void initState() {
    searchInput.value = searchFuzzyViewModel.searchInput.value;
    listaProductos.value = [];
  }

  void runFilter(String enteredKeyword) {
    searchFuzzyViewModel.runFilter(enteredKeyword);
  }

  void selecionarSoloProductos(List allResultados) {
    for (var i = 0; i < allResultados.length; i++) {
      if (allResultados[i] is Producto) {
        listaProductos.add(allResultados[i]);
      }
    }
  }

  cargarResultadosCard(BuildContext context) {

    
    final List<Widget> opciones = [];
    dynamic widgetTemp;

    for (var i = 0; i < searchFuzzyViewModel.allResultados.length; i++) {
      
      if (searchFuzzyViewModel.allResultados[i] is Producto) {
        widgetTemp = InputValoresCatalogo(
          element: (searchFuzzyViewModel.allResultados[i] as Producto),
          numEmpresa: 'nutresa',
          isCategoriaPromos: false,
          index: i,
        );
      }

      if (searchFuzzyViewModel.allResultados[i] is Categorias) {
        widgetTemp = GestureDetector(
          onTap: () async {
            final List<dynamic> listaSubCategorias = await DBProvider.db
                .consultarCategoriasSubCategorias(searchFuzzyViewModel.allResultados[i].codigo);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TabOpcionesCategorias(
                          listaCategorias: listaSubCategorias,
                          nombreCategoria: searchFuzzyViewModel.allResultados[i].descripcion,
                        )));
          },
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Get.height * 0.05, horizontal: Get.width * 0.02
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Obx(() => Image.network(
                          searchFuzzyViewModel.allResultados[i].ico,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset('assets/image/logo_login.png'),
                          fit: BoxFit.fill,
                        )),
                  ),
                  Spacer(),
                  Expanded(
                    child: AutoSizeText(
                      'Categoría',
                      maxFontSize: 15,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: HexColor('#0061cc')),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }

      if (searchFuzzyViewModel.allResultados[i] is Marca) {
        widgetTemp = GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomBuscardorFuzzy(
                          codCategoria: searchFuzzyViewModel.allResultados[i].codigo,
                          numEmpresa: 'nutresa',
                          tipoCategoria: 3,
                          nombreCategoria: searchFuzzyViewModel.allResultados[i].nombre,
                          isActiveBanner: false,
                          locacionFiltro: "marca",
                          codigoProveedor: "",
                        )));
          },
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Get.height * 0.05, horizontal: Get.width * 0.02
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Obx(() => Image.network(
                          searchFuzzyViewModel.allResultados[i].ico,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset('assets/image/logo_login.png'),
                          fit: BoxFit.fill,
                        )),
                  ),
                  Expanded(
                    child: AutoSizeText(
                      'Marca',
                      maxFontSize: 15,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: HexColor('#0061cc')),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }

      if (searchFuzzyViewModel.allResultados[i] is Fabricantes) {
        widgetTemp = GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomBuscardorFuzzy(
                          codCategoria: searchFuzzyViewModel.allResultados[i].empresa,
                          numEmpresa: 'nutresa',
                          tipoCategoria: 4,
                          nombreCategoria: searchFuzzyViewModel.allResultados[i].nombrecomercial,
                          img: searchFuzzyViewModel.allResultados[i].icono,
                          locacionFiltro: "proveedor",
                          codigoProveedor: searchFuzzyViewModel.allResultados[i].empresa.toString(),
                        )));
          },
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                      imageUrl: '${searchFuzzyViewModel.allResultados[i].icono}',
                      placeholder: (context, url) =>
                          Image.asset('assets/image/jar-loading.gif'),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/image/logo_login.png'),
                      fit: BoxFit.fill),
                ),
                Expanded(
                  child: AutoSizeText(
                    'Proveedor',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: HexColor('#0061cc')),
                  ),
                )
              ])),
        );
      }

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
