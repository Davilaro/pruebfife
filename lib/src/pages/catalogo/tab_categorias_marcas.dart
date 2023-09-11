import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/presentation/buscador_general/view/search_fuzzy_view.dart';
import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/src/modelos/fabricante.dart';
import 'package:emart/src/modelos/seccion.dart';
import 'package:emart/src/pages/catalogo/widgets/catalogo_interno.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/pages/catalogo/widgets/categorias_grillas.dart';
import 'package:emart/src/pages/catalogo/widgets/fabricantes.dart';
import 'package:emart/src/pages/catalogo/widgets/marcas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class TabCategoriaMarca extends StatefulWidget {
  @override
  State<TabCategoriaMarca> createState() => _TabCategoriaMarcaState();
}

class _TabCategoriaMarcaState extends State<TabCategoriaMarca>
    with SingleTickerProviderStateMixin {
  Map listSeccionsRoute = {
    2: Fabricantes(),
    3: CategoriasGrilla(),
    4: MarcasWidget(),
    1: CatalogoPoductosInterno(tipoCategoria: 1),
    5: CatalogoPoductosInterno(tipoCategoria: 2)
  };
  ControllerProductos constrollerProductos = Get.find();
  RxInt contador = 5.obs;

  final cargoConfirmar = Get.find<ControlBaseDatos>();
  List<Fabricante> imagenesProveedor = [];

  @override
  void initState() {
    print("entre categorias");
    super.initState();
    //UXCAM: Se define el nombre de la interfaz
    FlutterUxcam.tagScreenName('CategoriesTabs');
    // cargarData();
    cargarImagenes();
  }

  @override
  Widget build(BuildContext context) {
    constrollerProductos.getAgotados();

    final selectedColor = Colors.yellow;

    return Obx(() => DefaultTabController(
        length: cargoConfirmar.seccionesDinamicas.length,
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Scaffold(
            backgroundColor: ConstantesColores.color_fondo_gris,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                    child: _buscadorPrincipal(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TabBar(
                        controller: cargoConfirmar.tabController,
                        labelPadding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                        onTap: (index) {
                          //FIREBASE: Llamamos el evento select_content
                          TagueoFirebase().sendAnalityticSelectContent(
                              "Header",
                              "${cargoConfirmar.seccionesDinamicas[index].descripcion}",
                              "",
                              "",
                              "${cargoConfirmar.seccionesDinamicas[index].descripcion}",
                              'CategoryPage');
                          //UXCam: Llamamos el evento selectSeccion
                          UxcamTagueo().selectSeccion(cargoConfirmar
                              .seccionesDinamicas[index].descripcion);
                          cargoConfirmar.cargoBaseDatos(index);
                        },
                        indicatorColor: Colors.transparent,
                        unselectedLabelColor: Colors.black,
                        isScrollable: true,
                        tabs: List<Widget>.generate(
                            cargoConfirmar.seccionesDinamicas.length, (index) {
                          Seccion seccion =
                              cargoConfirmar.seccionesDinamicas[index];
                          return Tab(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Get.width * 0.065),
                              height: Get.height * 0.04,
                              decoration: BoxDecoration(
                                color: cargoConfirmar.cambioTab.value == index
                                    ? selectedColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(seccion.descripcion.toString()),
                              ),
                            ),
                          );
                        })),
                  ),
                  cargoConfirmar.tabController.index == 1
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: TabBar(
                              controller: cargoConfirmar.tabController,
                              labelPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              onTap: (index) {
                                //FIREBASE: Llamamos el evento select_content
                                TagueoFirebase().sendAnalityticSelectContent(
                                    "Header",
                                    "${cargoConfirmar.seccionesDinamicas[index].descripcion}",
                                    "",
                                    "",
                                    "${cargoConfirmar.seccionesDinamicas[index].descripcion}",
                                    'CategoryPage');
                                //UXCam: Llamamos el evento selectSeccion
                                UxcamTagueo().selectSeccion(cargoConfirmar
                                    .seccionesDinamicas[index].descripcion);
                                cargoConfirmar.cargoBaseDatos(index);
                              },
                              indicatorColor: Colors.transparent,
                              unselectedLabelColor: Colors.black,
                              isScrollable: true,
                              tabs: List<Widget>.generate(
                                  imagenesProveedor.length, (index) {
                                var fabricante = imagenesProveedor[index];

                                return Tab(
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: cargoConfirmar.cambioTab.value ==
                                              index
                                          ? selectedColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: CachedNetworkImage(
                                          imageUrl: fabricante.icono!,
                                          alignment: Alignment.bottomCenter,
                                          placeholder: (context, url) =>
                                              Image.asset(
                                            'assets/image/jar-loading.gif',
                                            alignment: Alignment.center,
                                            height: 50,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            'assets/image/logo_login.png',
                                            height: 50,
                                            alignment: Alignment.center,
                                          ),
                                          fit: BoxFit.contain,
                                        )),
                                  ),
                                );
                              })),
                        ),
                  Expanded(
                    child: TabBarView(
                      controller: cargoConfirmar.tabController,
                      children:
                          cargarWidgets(cargoConfirmar.seccionesDinamicas),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )));
  }

  cargarWidgets(List data) {
    List<Widget> listWidget = [];
    for (var i = 0; i < data.length; i++) {
      Seccion seccion = data[i];
      listWidget.add(listSeccionsRoute[seccion.idSeccion]);
    }
    return listWidget;
  }

  cargarImagenes() async {
    imagenesProveedor = await DBProvider.db.consultarFricante('');
    imagenesProveedor.add(Fabricante(
        empresa: 'TODOS',
        icono: 'assets/image/estrella.png', diasEntrega: 0));
    priorizarNutresa(imagenesProveedor);
    setState(() {});
  }

  priorizarNutresa(List<Fabricante> proveedores) {
    proveedores.forEach((element) {
      if (element.empresa == 'NUTRESA') {
        proveedores.remove(element);
        proveedores.insert(0, element);
      }
      if (element.empresa == 'ZENU') {
        proveedores.remove(element);
        proveedores.insert(1, element);
      }
    });
  }

  _buscadorPrincipal(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: HexColor("#E4E3EC"),
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SearchFuzzyView()));
        },
        child: TextField(
          enabled: false,
          style: TextStyle(color: HexColor("#41398D"), fontSize: 13),
          decoration: InputDecoration(
            fillColor: HexColor("#41398D"),
            hintText: 'Encuentra aquí todo lo que necesitas',
            hintStyle: TextStyle(
              color: HexColor("#41398D"),
            ),
            suffixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Icon(
                  Icons.search,
                  color: HexColor("#41398D"),
                )),
            border: InputBorder.none,
            contentPadding: EdgeInsets.fromLTRB(10.0, 15, 10.0, 0),
          ),
        ),
      ),
    );
  }
}
