import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/shared/widgets/drawer_sucursales.dart';
import 'package:emart/src/modelos/categorias.dart';
import 'package:emart/src/modelos/fabricante.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/pages/catalogo/widgets/tab_categorias_opciones.dart';
import 'package:emart/src/provider/logica_actualizar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

final prefs = new Preferencias();

class CategoriasGrilla extends StatefulWidget {
  const CategoriasGrilla({
    Key? key,
  }) : super(key: key);

  @override
  State<CategoriasGrilla> createState() => _CategoriasGrillaState();
}

class _CategoriasGrillaState extends State<CategoriasGrilla> {
  RxList<dynamic> listaCategoria = <dynamic>[].obs;
  List<dynamic> listaAllCategorias = [];
  final TextEditingController controllerSearch = TextEditingController();

  RxString proveedor = "".obs;
  RxString proveedor2 = "".obs;

  RxList<Fabricante> listaFabricante = <Fabricante>[].obs;

  RxBool esBuscadoTodos = false.obs;

  RxInt contadorSeleccionados = 0.obs;
  // ControllerProductos constrollerProductos = Get.find();

  RxList<bool> seleccionados = [false, false, false].obs;

  @override
  void initState() {
    //UXCAM: Se define el nombre de la pantalla
    FlutterUxcam.tagScreenName('CategoriesPage');
    // listaCategoria.value = [];
    cargarLista();
    cargarListaProovedor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CarroModelo>(context);
    return Scaffold(
        backgroundColor: ConstantesColores.color_fondo_gris,
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(children: [
            Obx(() => listaCategoria.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                      color: ConstantesColores.azul_precio,
                    ),
                  )
                : botonesProveedores()),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Expanded(
                flex: 2,
                child: Obx(() => Container(
                    height: Get.height * 1,
                    width: Get.width * 1,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                    child: RefreshIndicator(
                      color: ConstantesColores.azul_precio,
                      backgroundColor:
                          ConstantesColores.agua_marina.withOpacity(0.6),
                      onRefresh: () async {
                        await LogicaActualizar().actualizarDB();
                        setState(() {
                          cargarLista();
                        });
                        return Future<void>.delayed(const Duration(seconds: 3));
                      },
                      child: GridView.count(
                          crossAxisCount: 3,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 9.0,
                          mainAxisSpacing: 9.0,
                          children: _cargarCategorias(
                                  listaCategoria, context, provider)
                              .toList()),
                    ))))
          ]),
        ));
  }

  Widget botonesProveedores() {
    return listaFabricante.isEmpty
        ? Center(
            child: CircularProgressIndicator(
              color: ConstantesColores.azul_precio,
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
            child: SizedBox(
                height: Get.height * 0.08,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          // Si el botón no está seleccionado, se verifica si hay menos de dos botones seleccionados
                          if (!seleccionados[0]) {
                            if (seleccionados
                                    .where((element) => element)
                                    .length <
                                2) {
                              // Se cambia el estado del botón a seleccionado
                              seleccionados[0] = true;
                              esBuscadoTodos.value = false;
                              // Se asigna el valor del botón a la variable correspondiente
                              if (proveedor.isEmpty) {
                                proveedor.value = 'NUTRESA';
                              } else {
                                proveedor2.value = 'NUTRESA';
                              }
                            }
                          } else {
                            // Si el botón está seleccionado, se cambia el estado a no seleccionado
                            seleccionados[0] = false;
                            // Se elimina el valor del botón de la variable correspondiente
                            if (proveedor.value == 'NUTRESA') {
                              proveedor.value = proveedor2.value;
                              proveedor2.value = '';
                            } else if (proveedor2.value == 'NUTRESA') {
                              proveedor2.value = '';
                            }
                          }
                          cargarLista();
                        });
                      },
                      child: Container(
                        width: Get.width * 0.2,
                        margin: EdgeInsets.fromLTRB(5, 2, 5, 5),
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: seleccionados[0]
                                ? ConstantesColores.azul_precio
                                : Colors.transparent,
                            width: 2,
                          ),
                          color: Colors.white,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: listaFabricante[0].icono!,
                          alignment: Alignment.bottomCenter,
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/icon/cerrar_ventana.png',
                            height: Get.height * 0.05,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (!seleccionados[1]) {
                            if (seleccionados
                                    .where((element) => element)
                                    .length <
                                2) {
                              // Se cambia el estado del botón a seleccionado
                              seleccionados[1] = true;
                              esBuscadoTodos.value = false;
                              // Se asigna el valor del botón a la variable correspondiente
                              if (proveedor.isEmpty) {
                                proveedor.value = 'ZENU';
                              } else {
                                proveedor2.value = 'ZENU';
                              }
                            }
                          } else {
                            // Si el botón está seleccionado, se cambia el estado a no seleccionado
                            seleccionados[1] = false;
                            // Se elimina el valor del botón de la variable correspondiente
                            if (proveedor.value == 'ZENU') {
                              proveedor.value = proveedor2.value;
                              proveedor2.value = '';
                            } else if (proveedor2.value == 'ZENU') {
                              proveedor2.value = '';
                            }
                          }
                          cargarLista();
                        });
                      },
                      child: Container(
                        width: Get.width * 0.2,
                        margin: EdgeInsets.fromLTRB(5, 2, 5, 5),
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: seleccionados[1]
                                ? ConstantesColores.azul_precio
                                : Colors.transparent,
                            width: 2,
                          ),
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: CachedNetworkImage(
                          imageUrl: listaFabricante[1].icono!,
                          alignment: Alignment.bottomCenter,
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/icon/cerrar_ventana.png',
                            height: Get.height * 0.05,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (!seleccionados[2]) {
                            if (seleccionados
                                    .where((element) => element)
                                    .length <
                                2) {
                              // Se cambia el estado del botón a seleccionado
                              seleccionados[2] = true;
                              esBuscadoTodos.value = false;
                              // Se asigna el valor del botón a la variable correspondiente
                              if (proveedor.isEmpty) {
                                proveedor.value = 'MEALS';
                              } else {
                                proveedor2.value = 'MEALS';
                              }
                            }
                          } else {
                            // Si el botón está seleccionado, se cambia el estado a no seleccionado
                            seleccionados[2] = false;
                            // Se elimina el valor del botón de la variable correspondiente
                            if (proveedor.value == 'MEALS') {
                              proveedor.value = proveedor2.value;
                              proveedor2.value = '';
                            } else if (proveedor2.value == 'MEALS') {
                              proveedor2.value = '';
                            }
                          }
                          cargarLista();
                        });
                      },
                      child: Container(
                        width: Get.width * 0.2,
                        margin: EdgeInsets.fromLTRB(5, 2, 5, 5),
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: seleccionados[2]
                                ? ConstantesColores.azul_precio
                                : Colors.transparent,
                            width: 2,
                          ),
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: CachedNetworkImage(
                          imageUrl: listaFabricante[2].icono!,
                          alignment: Alignment.bottomCenter,
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/icon/cerrar_ventana.png',
                            height: Get.height * 0.05,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          proveedor.value = listaFabricante[3].empresa!;
                          esBuscadoTodos.value = !esBuscadoTodos.value;
                          proveedor2 = "".obs;

                          seleccionados[0] = false;
                          seleccionados[1] = false;
                          seleccionados[2] = false;

                          cargarLista();
                        });
                      },
                      child: Container(
                        width: Get.width * 0.2,
                        margin: EdgeInsets.fromLTRB(5, 2, 5, 5),
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: esBuscadoTodos.value
                                ? ConstantesColores.azul_precio
                                : Colors.transparent,
                            width: 2,
                          ),
                          color: Colors.white,
                        ),
                        child: Container(
                          padding: EdgeInsets.only(
                            top: Get.height * 0.005,
                          ),
                          child: Column(
                            children: [
                              Container(
                                child: SvgPicture.asset(
                                  'assets/icon/Icono_Todos.svg',
                                  height: Get.height * 0.03,
                                  alignment: Alignment.center,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              AutoSizeText('Todos',
                                  maxFontSize: 10,
                                  style: TextStyle(
                                      color: ConstantesColores.azul_precio),
                                  minFontSize: 6,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          );
  }

  List<Widget> _cargarCategorias(
      List<dynamic> result, BuildContext context, CarroModelo provider) {
    final List<Widget> opciones = [];
    final size = MediaQuery.of(context).size;

    for (var element in result) {
      final widgetTemp = GestureDetector(
        onTap: () {
          //FIREBASE: Llamamos el evento select_content
          TagueoFirebase().sendAnalityticSelectContent(
              "Categorías",
              element.descripcion,
              '',
              element.descripcion,
              element.codigo,
              'ViewCategoris');
          //UXCam: Llamamos el evento seeCategory
          UxcamTagueo().seeCategory(element.descripcion);
          _onClickCatalogo(
              element.codigo, context, provider, element.descripcion);
        },
        child: Container(
          height: Get.height * 0.1,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Wrap(
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  Container(
                    height: size.height * 0.090,
                    margin: EdgeInsets.fromLTRB(5, 2, 5, 0),
                    alignment: Alignment.center,
                    child: CachedNetworkImage(
                      imageUrl: element.ico,
                      alignment: Alignment.bottomCenter,
                      placeholder: (context, url) => Image.asset(
                        'assets/image/jar-loading.gif',
                        alignment: Alignment.center,
                        height: 50,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/image/logo_login.png',
                        height: 50,
                        alignment: Alignment.center,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                child: AutoSizeText('${element.descripcion}',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: HexColor('#0061cc')),
                    textAlign: TextAlign.center,
                    minFontSize: 8,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      );

      opciones.add(widgetTemp);
    }

    return opciones;
  }

  _onClickCatalogo(String codigo, BuildContext context, CarroModelo provider,
      String nombre) async {
    final List<dynamic> listaSubCategorias =
        await DBProvider.db.consultarCategoriasSubCategorias(codigo);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TabOpcionesCategorias(
                  listaCategorias: listaSubCategorias,
                  nombreCategoria: nombre,
                )));
  }

  void cargarLista() async {
    listaAllCategorias = await DBProvider.db
        .consultarCategoriasPorFabricante(proveedor.value, proveedor2.value);

    listaCategoria.value = listaAllCategorias;
  }

  void cargarListaProovedor() async {
    listaFabricante.value = await DBProvider.db.consultarFricante("");

    listaFabricante.forEach((element) {
      if (element.empresa == "NUTRESA") {
        listaFabricante.remove(element);
        listaFabricante.insert(0, element);
      }
      if (element.empresa == "ZENU") {
        listaFabricante.remove(element);
        listaFabricante.insert(1, element);
      }
    });

    listaFabricante.add(Fabricante(
        diasEntrega: 0, empresa: "", icono: "assets/image/logo_login.png"));
  }

  @override
  void dispose() {
    controllerSearch.dispose();
    super.dispose();
  }
}
