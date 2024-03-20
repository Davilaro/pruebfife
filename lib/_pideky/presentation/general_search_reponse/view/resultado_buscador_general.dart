import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/domain/brand/model/brand.dart';
import 'package:emart/_pideky/domain/product/model/product_model.dart';
import 'package:emart/_pideky/presentation/general_search/view_model/search_fuzzy_view_model.dart';
import 'package:emart/_pideky/presentation/general_search_filters/view/general_search_filters_page.dart';
import 'package:emart/_pideky/presentation/general_search_reponse/view_model/general_search_response_view_model.dart';
import 'package:emart/_pideky/presentation/general_search_reponse/widgets/campo_texto_resultado.dart';
import 'package:emart/shared/widgets/drawer_sucursales.dart';
import 'package:emart/shared/widgets/new_app_bar.dart';
import 'package:emart/src/controllers/bannnersController.dart';
import 'package:emart/src/modelos/categorias.dart';
import 'package:emart/src/modelos/fabricante.dart';
import 'package:emart/src/pages/catalogo/widgets/tab_categorias_opciones.dart';
import 'package:emart/src/pages/principal_page/widgets/custom_buscador_fuzzy.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/widget/custom_button.dart';
import 'package:emart/src/widget/input_valores_catalogo.dart';
import 'package:flutter/material.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

final prefs = new Preferencias();

class GeneralSearchResponse extends StatelessWidget {
  final List<dynamic> allresultados;

  GeneralSearchResponse({Key? key, required this.allresultados})
      : super(key: key);

  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  final controllerBanner = Get.find<BannnerControllers>();
  final resultadoBuscadorGeneralVm = Get.put(GeneralSearchResponseViewModel());
  final searchFuzzyViewModel = Get.find<SearchFuzzyViewModel>();

  Widget build(BuildContext context) {
    resultadoBuscadorGeneralVm.listaProductos.refresh();

    return WillPopScope(
      onWillPop: () async {
        searchFuzzyViewModel.controllerUser.text = '';
        searchFuzzyViewModel.productosMasBuscado.value = '';
        searchFuzzyViewModel.searchInput.value = '';
        return true;
      },
      child: Scaffold(
        key: drawerKey,
        drawerEnableOpenDragGesture: prefs.usurioLogin == 1 ? true : false,
        drawer: DrawerSucursales(drawerKey),
        appBar: PreferredSize(
          preferredSize: prefs.usurioLogin == 1
              ? const Size.fromHeight(118)
              : const Size.fromHeight(70),
          child: SafeArea(child: NewAppBar(drawerKey)),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FittedBox(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          resultadoBuscadorGeneralVm.selectedButton.value = '';
                          searchFuzzyViewModel.allResultados.clear();
                          searchFuzzyViewModel.controllerUser.text = '';
                          searchFuzzyViewModel.productosMasBuscado.value = '';
                          searchFuzzyViewModel.searchInput.value = '';
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: ConstantesColores.agua_marina,
                          size: 30,
                        ),
                      ),
                      CampoTextoResultado(),
                      GestureDetector(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    GeneralSearchFiltersPage(
                                      codCategoria: '',
                                      codigoProveedor: '',
                                      nombreCategoria: '',
                                      urlImagen: '',
                                    )),
                          )
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: Get.height * 0.01,
                              horizontal: Get.width * 0.02),
                          child: GestureDetector(
                            child: SvgPicture.asset(
                                'assets/image/filtro_btn.svg',
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Obx(() => Text(
                  searchFuzzyViewModel.searchInput.isEmpty
                      ? 'Estás buscando en todas las secciones'
                      : 'Estás buscando "${searchFuzzyViewModel.searchInput.value}" en todas las secciones',
                  style: TextStyle(
                      color: Colors.black.withOpacity(.5),
                      fontSize: 13,
                      fontWeight: FontWeight.bold))),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
              child: SizedBox(
                height: Get.height * 0.03,
                child: Row(
                  children: [
                    SizedBox(width: Get.width * 0.05),
                    Expanded(
                      flex: 3,
                      child: Obx(() {
                        return CustomButton(
                          isFontBold: true,
                          sizeText: 12,
                          onPressed: () {
                            resultadoBuscadorGeneralVm.cargarProductosPromo();
                            resultadoBuscadorGeneralVm
                                .setSelectedButton('Promociones');
                          },
                          text: 'Promociones',
                          backgroundColor:
                              resultadoBuscadorGeneralVm.selectedButton.value ==
                                      'Promociones'
                                  ? ConstantesColores.azul_precio
                                  : ConstantesColores.color_fondo_gris,
                          colorContent:
                              resultadoBuscadorGeneralVm.selectedButton.value ==
                                      'Promociones'
                                  ? Colors.white
                                  : ConstantesColores.azul_precio,
                        );
                      }),
                    ),
                    SizedBox(width: Get.width * 0.02),
                    Expanded(
                      flex: 3,
                      child: Obx(
                        () => CustomButton(
                          isFontBold: true,
                          sizeText: 12,
                          onPressed: () {
                            resultadoBuscadorGeneralVm
                                .cargarProductosImperdibles();
                            resultadoBuscadorGeneralVm
                                .setSelectedButton('Imperdibles');
                          },
                          text: 'Imperdibles',
                          backgroundColor:
                              resultadoBuscadorGeneralVm.selectedButton.value ==
                                      'Imperdibles'
                                  ? ConstantesColores.azul_precio
                                  : ConstantesColores.color_fondo_gris,
                          colorContent:
                              resultadoBuscadorGeneralVm.selectedButton.value ==
                                      'Imperdibles'
                                  ? Colors.white
                                  : ConstantesColores.azul_precio,
                        ),
                      ),
                    ),
                    SizedBox(width: Get.width * 0.05),
                  ],
                ),
              ),
            ),
            Obx(
              () => searchFuzzyViewModel.productosMasBuscado.value.isNotEmpty
                  ? Container(
                      padding: EdgeInsets.only(
                          left: Get.width * 0.05, right: Get.width * 0.05),
                      width: Get.width * 4.0,
                      height: Get.height * 0.03,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Ajusta el valor para cambiar el radio de los bordes
                          ),
                        ),
                        onPressed: () {
                          searchFuzzyViewModel.controllerUser.text =
                              searchFuzzyViewModel.productosMasBuscado.value;
                          searchFuzzyViewModel.runFilter(
                              searchFuzzyViewModel.controllerUser.text);
                        },
                        child: Text(
                          searchFuzzyViewModel.productosMasBuscado.value,
                          style: TextStyle(
                              fontSize: 13.7,
                              fontWeight: FontWeight.bold,
                              color: ConstantesColores.azul_precio),
                        ),

                        // backgroundColor: ConstantesColores.color_fondo_gris,
                        // colorContent: ConstantesColores.azul_precio
                        // backgroundColor:
                        //     resultadoBuscadorGeneralVm.selectedButton.value ==
                        //             'Imperdibles'
                        //         ? ConstantesColores.azul_precio
                        //         : ConstantesColores.color_fondo_gris,
                        // colorContent:
                        //     resultadoBuscadorGeneralVm.selectedButton.value ==
                        //             'Imperdibles'
                        //         ? Colors.white
                        //         : ConstantesColores.azul_precio,
                      ),
                    )
                  : Container(),
            ),
            SizedBox(
              height: 15.0,
            ),
            Expanded(
                child: Obx(() => GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 9.0,
                    childAspectRatio: 2 / 3.1,
                    padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.04,
                        vertical: Get.height * 0.01),
                    children: cargarResultadosCard(context).toList())))
          ],
        ),
      ),
    );
  }

  cargarResultadosCard(BuildContext context) {
    final List<Widget> opciones = [];
    dynamic widgetTemp;

    for (var i = 0; i < searchFuzzyViewModel.allResultados.length; i++) {
      if (searchFuzzyViewModel.allResultados[i] is Product) {
        widgetTemp = InputValoresCatalogo(
          element: (searchFuzzyViewModel.allResultados[i] as Product),
          isCategoriaPromos: resultadoBuscadorGeneralVm.isPromo.value,
          index: i,
          // esto significa que estaba en la pantalla de busqueda
          search: true,
        );
      }

      if (searchFuzzyViewModel.allResultados[i] is Categorias) {
        widgetTemp = GestureDetector(
          onTap: () async {
            final List<dynamic> listaSubCategorias = await DBProvider.db
                .consultarCategoriasSubCategorias(
                    searchFuzzyViewModel.allResultados[i].codigo);
            if (searchFuzzyViewModel.controllerUser.text != '') {
              searchFuzzyViewModel.llenarRecientes(
                  searchFuzzyViewModel.allResultados[i], Categorias);
              // searchFuzzyViewModel.listaRecientes.addIf(
              //     searchFuzzyViewModel.listaRecientes
              //         .contains(searchFuzzyViewModel.allResultados[i]) == false,
              //     searchFuzzyViewModel.allResultados[i]);
            }

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TabOpcionesCategorias(
                          listaCategorias: listaSubCategorias,
                          nombreCategoria:
                              searchFuzzyViewModel.allResultados[i].descripcion,
                        )));
          },
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Get.height * 0.05, horizontal: Get.width * 0.02),
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

      if (searchFuzzyViewModel.allResultados[i] is Brand) {
        widgetTemp = GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomBuscardorFuzzy(
                          codCategoria:
                              searchFuzzyViewModel.allResultados[i].codigo,
                          numEmpresa: 'nutresa',
                          tipoCategoria: 3,
                          nombreCategoria:
                              searchFuzzyViewModel.allResultados[i].nombre,
                          locacionFiltro: "marca",
                          codigoProveedor: "",
                        )));
            if (searchFuzzyViewModel.controllerUser.text != '') {
              searchFuzzyViewModel.llenarRecientes(
                  searchFuzzyViewModel.allResultados[i], Brand);
              // searchFuzzyViewModel.listaRecientes.addIf(
              //     searchFuzzyViewModel.listaRecientes
              //             .contains(searchFuzzyViewModel.allResultados[i]) ==
              //         false,
              //     searchFuzzyViewModel.allResultados[i]);
            }
          },
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Get.height * 0.05, horizontal: Get.width * 0.02),
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

      if (searchFuzzyViewModel.allResultados[i] is Fabricante) {
        widgetTemp = GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomBuscardorFuzzy(
                          codCategoria:
                              searchFuzzyViewModel.allResultados[i].empresa,
                          numEmpresa: 'nutresa',
                          tipoCategoria: 4,
                          nombreCategoria: searchFuzzyViewModel
                              .allResultados[i].nombrecomercial,
                          img: searchFuzzyViewModel.allResultados[i].icono,
                          locacionFiltro: "proveedor",
                          codigoProveedor: searchFuzzyViewModel
                              .allResultados[i].empresa
                              .toString(),
                        )));
            if (searchFuzzyViewModel.controllerUser.text != '') {
              searchFuzzyViewModel.llenarRecientes(
                  searchFuzzyViewModel.allResultados[i], Fabricante);
              // searchFuzzyViewModel.listaRecientes.addIf(
              //     searchFuzzyViewModel.listaRecientes
              //             .contains(searchFuzzyViewModel.allResultados[i]) ==
              //         false,
              //     searchFuzzyViewModel.allResultados[i]);
            }
          },
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                      imageUrl:
                          '${searchFuzzyViewModel.allResultados[i].icono}',
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
}
