import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/domain/marca/model/marca.dart';
import 'package:emart/_pideky/domain/marca/service/marca_service.dart';
import 'package:emart/_pideky/infrastructure/marcas/marca_repository_sqlite.dart';
import 'package:emart/src/controllers/notifiactions_controllers.dart';
import 'package:emart/src/modelos/fabricante.dart';
import 'package:emart/src/pages/principal_page/widgets/custom_buscador_fuzzy.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/provider/logica_actualizar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

final prefs = new Preferencias();

class MarcasWidget extends StatefulWidget {
  const MarcasWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<MarcasWidget> createState() => _MarcasWidgetState();
}

class _MarcasWidgetState extends State<MarcasWidget> {
  RxList<dynamic> listaMarca = <dynamic>[].obs;
  List<dynamic> listaAllMarcas = [];
  final TextEditingController controllerSearch = TextEditingController();

  MarcaService marcaService = MarcaService(MarcaRepositorySqlite());

  RxString proveedor = "".obs;
  RxString proveedor2 = "".obs;

  RxList<Fabricante> listaFabricante = <Fabricante>[].obs;

  RxBool esBuscadoNutresa = false.obs;
  RxBool esBuscadoZenu = false.obs;
  RxBool esBuscadoCrem = false.obs;
  RxBool esBuscadoTodos = false.obs;

  RxInt contadorSeleccionados = 0.obs;

  RxList<bool> seleccionados = [false, false, false].obs;

  @override
  void initState() {
    //UXCAM:Se define el nombre de la pantalla
    FlutterUxcam.tagScreenName('BrandsPage');
    controllerSearch.addListener(_runFilter);
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
              Obx(() => listaMarca.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(
                        color: ConstantesColores.azul_precio,
                      ),
                    )
                  : botonesProveedores()),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Flexible(
                  flex: 2,
                  child: Obx(() => Container(
                      height: Get.height * 1,
                      width: Get.width * 1,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                      child: RefreshIndicator(
                        color: ConstantesColores.azul_precio,
                        backgroundColor:
                            ConstantesColores.agua_marina.withOpacity(0.5),
                        onRefresh: () async {
                          await LogicaActualizar().actualizarDB();

                          // cargarLista();

                          setState(() {
                            initState();
                            (context as Element).reassemble();
                          });
                          return Future<void>.delayed(
                              const Duration(seconds: 3));
                        },
                        child: GridView.count(
                            crossAxisCount: 3,
                            childAspectRatio: 1.0,
                            crossAxisSpacing: 1.0,
                            mainAxisSpacing: 3,
                            children:
                                _cargarMarcas(listaMarca, context, provider)
                                    .toList()),
                      ))))
            ])));
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
                        child: Column(
                          children: [
                            Container(
                              child: SvgPicture.asset(
                                'assets/icon/Icono_Todos.svg',
                                height: Get.height * 0.035,
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
                  ],
                )),
          );
  }

  List<Widget> _cargarMarcas(
      List<dynamic> result, BuildContext context, CarroModelo provider) {
    final List<Widget> opciones = [];
    PaintingBinding.instance.imageCache.clear();
    for (var element in result) {
      RxString icon = element.ico.toString().obs;

      final widgetTemp = GestureDetector(
        onTap: () => {
          //Firebase: Llamamos el evento select_content
          TagueoFirebase().sendAnalityticSelectContent(
              "Marcas",
              (element as Marca).nombre,
              element.nombre,
              element.nombre,
              element.codigo,
              'ViewMarcs'),
          //UXCam: Llamamos el evento seeBrand
          UxcamTagueo().seeBrand(element.nombre),
          _onClickCatalogo(element.codigo, context, provider, element.nombre)
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 0,
          child: Container(
            height: Get.height * 4,
            width: Get.width * 1,
            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
            alignment: Alignment.center,
            color: Colors.white,
            child: Obx(() => Image.network(
                  icon.value,
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset('assets/image/logo_login.png'),
                  fit: BoxFit.fill,
                )),
            // child: CachedNetworkImage(
            //   imageUrl: element.ico,
            //   placeholder: (context, url) =>
            //       Image.asset('assets/image/jar-loading.gif'),
            //   errorWidget: (context, url, error) =>
            //       Image.asset('assets/image/logo_login.png'),
            //   fit: BoxFit.fill,
            // ),
          ),
        ),
      );

      opciones.add(widgetTemp);
    }

    return opciones;
  }

  _onClickCatalogo(
    String codigo,
    BuildContext context,
    CarroModelo provider,
    String nombre,
  ) {
    final controllerNotificaciones =
        Get.find<NotificationsSlideUpAndPushInUpControllers>();
    controllerNotificaciones.llenarMapPushInUp(nombre);
    controllerNotificaciones.llenarMapSlideUp(nombre);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomBuscardorFuzzy(
                  codCategoria: codigo,
                  numEmpresa: 'nutresa',
                  tipoCategoria: 3,
                  nombreCategoria: nombre,
                  isActiveBanner: false,
                  locacionFiltro: "marca",
                  codigoProveedor: "",
                )));
  }

  void cargarLista() async {
    listaAllMarcas = await await DBProvider.db
        .consultarMarcasPorFabricante(proveedor.value, proveedor2.value);
    listaMarca.value = listaAllMarcas;
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

  void _runFilter() {
    if (controllerSearch.text.isEmpty) {
      listaMarca.value = listaAllMarcas;
    } else {
      if (controllerSearch.text.length > 2) {
        //FIREBASE: Llamamos el evento search
        TagueoFirebase().sendAnalityticsSearch(controllerSearch.text);
        //UXCam: Llamamos el evento search
        UxcamTagueo().search(controllerSearch.text);
        List listaAux = [];
        listaAllMarcas.forEach((element) {
          listaAux.add(element.titulo);
        });
        final result = extractTop(
          limit: 10,
          query: controllerSearch.text,
          choices: listaAllMarcas.map((element) => element.nombre).toList(),
          cutoff: 10,
        );
        listaMarca.value = [];
        result
            .map((r) => listaMarca.add(listaAllMarcas
                .firstWhere((element) => element.titulo == r.choice)))
            .forEach(print);
      }
    }
  }

  @override
  void dispose() {
    controllerSearch.dispose();
    super.dispose();
  }
}
