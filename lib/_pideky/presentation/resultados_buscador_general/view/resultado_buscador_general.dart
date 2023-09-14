import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/domain/marca/model/marca.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/_pideky/presentation/buscador_general/view_model/search_fuzzy_view_model.dart';
import 'package:emart/_pideky/presentation/filtros_resultado_general/view/filtros_resultado_general.dart';
import 'package:emart/_pideky/presentation/resultados_buscador_general/view_model/resultado_buscador_general_view_model.dart';
import 'package:emart/_pideky/presentation/resultados_buscador_general/widgets/campo_texto_resultado.dart';
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

class ResultadoBuscadorGeneral extends StatelessWidget {
  final List<dynamic> allresultados;

  ResultadoBuscadorGeneral({Key? key, required this.allresultados})
      : super(key: key);

  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  final controllerBanner = Get.find<BannnerControllers>();
  final resultadoBuscadorGeneralVm = Get.put(ResultadoBuscadorGeneralVm());
  final searchFuzzyViewModel = Get.put(SearchFuzzyViewModel());

  Widget build(BuildContext context) {
    resultadoBuscadorGeneralVm.listaProductos.refresh();

    return Scaffold(
      key: drawerKey,
      drawerEnableOpenDragGesture:
          resultadoBuscadorGeneralVm.prefs.usurioLogin == 1 ? true : false,
      drawer: DrawerSucursales(drawerKey),
      appBar: PreferredSize(
        preferredSize: resultadoBuscadorGeneralVm.prefs.usurioLogin == 1
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
                              builder: (context) => FiltrosResultadoGeneralView(
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
                          child: SvgPicture.asset('assets/image/filtro_btn.svg',
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
                    child: CustomButton(
                      isFontBold: true,
                      sizeText: 12,
                      onPressed: () {
                        resultadoBuscadorGeneralVm.cargarProductosPromo();
                      },
                      text: 'Promociones',
                      backgroundColor: ConstantesColores.color_fondo_gris,
                      colorContent: ConstantesColores.azul_precio,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.02),
                  Expanded(
                    flex: 3,
                    child: CustomButton(
                      isFontBold: true,
                      sizeText: 12,
                      onPressed: () {
                        resultadoBuscadorGeneralVm.cargarProductosImperdibles();
                      },
                      text: 'Imperdibles',
                      backgroundColor: ConstantesColores.color_fondo_gris,
                      colorContent: ConstantesColores.azul_precio,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.05),
                ],
              ),
            ),
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
    );
  }

  cargarResultadosCard(BuildContext context) {
    final List<Widget> opciones = [];
    dynamic widgetTemp;

    for (var i = 0; i < searchFuzzyViewModel.allResultados.length; i++) {
      if (searchFuzzyViewModel.allResultados[i] is Producto) {
        widgetTemp = InputValoresCatalogo(
          element: (searchFuzzyViewModel.allResultados[i] as Producto),
          numEmpresa: 'nutresa',
          isCategoriaPromos: resultadoBuscadorGeneralVm.isPromo.value,
          index: i,
        );
      }

      if (searchFuzzyViewModel.allResultados[i] is Categorias) {
        widgetTemp = GestureDetector(
          onTap: () async {
            final List<dynamic> listaSubCategorias = await DBProvider.db
                .consultarCategoriasSubCategorias(
                    searchFuzzyViewModel.allResultados[i].codigo);
            if (searchFuzzyViewModel.controllerUser.text != '') {
              searchFuzzyViewModel.listaRecientes
                  .add(searchFuzzyViewModel.allResultados[i]);

              searchFuzzyViewModel.listaRecientes =
                  searchFuzzyViewModel.listaRecientes.reversed.toList().obs;
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

      if (searchFuzzyViewModel.allResultados[i] is Marca) {
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
                          isActiveBanner: false,
                          locacionFiltro: "marca",
                          codigoProveedor: "",
                        )));
            if (searchFuzzyViewModel.controllerUser.text != '') {
              searchFuzzyViewModel.listaRecientes
                  .add(searchFuzzyViewModel.allResultados[i]);

              searchFuzzyViewModel.listaRecientes =
                  searchFuzzyViewModel.listaRecientes.reversed.toList().obs;
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
              searchFuzzyViewModel.listaRecientes
                  .add(searchFuzzyViewModel.allResultados[i]);

              searchFuzzyViewModel.listaRecientes =
                  searchFuzzyViewModel.listaRecientes.reversed.toList().obs;
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
