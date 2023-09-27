// ignore_for_file: unnecessary_statements

import 'package:emart/_pideky/presentation/buscador_general/view/search_fuzzy_view.dart';
import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/src/modelos/seccion.dart';
import 'package:emart/src/pages/catalogo/view_model/botones_proveedores_vm.dart';
import 'package:emart/src/pages/catalogo/widgets/catalogo_interno.dart';
import 'package:emart/src/preferences/cont_colores.dart';
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
  RxString proveedor = "".obs;
  Map listSeccionsRoute = {
    2: Fabricantes(),
    3: CategoriasGrilla(),
    4: MarcasWidget(),
    //estas dos no se usan por el momento pero trato de borrar y se daña todo :C
    1: CatalogoPoductosInterno(tipoCategoria: 1),
    5: CatalogoPoductosInterno(tipoCategoria: 2)
  };
  final cargoConfirmar = Get.find<ControlBaseDatos>();
  ControllerProductos constrollerProductos = Get.find();
  final botonesProveedoresVm = Get.put(BotonesProveedoresVm());
  RxInt contador = 5.obs;

  @override
  void initState() {
    super.initState();
    //UXCAM: Se define el nombre de la interfaz
    FlutterUxcam.tagScreenName('CategoriesTabs');
    botonesProveedoresVm.seleccionados.clear();
    botonesProveedoresVm.esBuscadoTodos = true.obs; 
    // cargarData();
  }

  @override
  void dispose() {
    botonesProveedoresVm.listaProveedores.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    constrollerProductos.getAgotados();

    final selectedColor = Colors.yellow;

    return DefaultTabController(
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
                            child: Obx(
                              () => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Get.width * 0.078),
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
                            ),
                          );
                        })),
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: cargoConfirmar.tabController,
                      children: cargarWidgets(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  List<Widget> cargarWidgets() {
    List<Widget> listWidget = [];
    for (var i = 0; i < cargoConfirmar.seccionesDinamicas.length; i++) {
      Seccion seccion = cargoConfirmar.seccionesDinamicas[i];
      listWidget.add(listSeccionsRoute[seccion.idSeccion]);
    }
    return listWidget;
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
