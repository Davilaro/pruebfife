import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/modelos/seccion.dart';
import 'package:emart/src/pages/catalogo/widgets/catalogo_interno.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/pages/catalogo/widgets/categorias_grillas.dart';
import 'package:emart/src/pages/catalogo/widgets/fabricantes.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:emart/src/widget/imagen_notification.dart';
import 'package:emart/src/pages/catalogo/widgets/marcas.dart';
import 'package:emart/src/widget/soporte.dart';
import 'package:emart/src/widget/titulo_pideky.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

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

  RxInt contador = 5.obs;

  final cargoConfirmar = Get.find<ControlBaseDatos>();

  @override
  void initState() {
    super.initState();
    // cargarData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final selectedColor = Colors.yellow;

    return Obx(() => DefaultTabController(
        length: cargoConfirmar.seccionesDinamicas.length,
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Scaffold(
            backgroundColor: ConstantesColores.color_fondo_gris,
            appBar: AppBar(
              title: TituloPideky(size: size),
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(10, 2.0, 0, 0),
                child: new IconButton(
                  icon: SvgPicture.asset('assets/boton_soporte.svg'),
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Soporte(
                                numEmpresa: 1,
                              )),
                    ),
                  },
                ),
              ),
              elevation: 0,
              actions: <Widget>[
                BotonActualizar(),
                AccionNotificacion(),
                AccionesBartCarrito(esCarrito: false),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                children: [
                  Padding(
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
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              height: 50,
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
}
