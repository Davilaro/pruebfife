import 'package:emart/src/controllers/bannnersController.dart';
import 'package:emart/src/pages/principal_page/widgets/custom_buscador_fuzzy.dart';
import 'package:emart/src/pages/principal_page/tab_opciones.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:emart/src/widget/titulo_pideky_carrito.dart';
import 'package:flutter/material.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../widget/acciones_carrito_bart.dart';
import '../../../widget/imagen_notification.dart';

final prefs = new Preferencias();

class TabOpcionesCategorias extends StatefulWidget {
  final List<dynamic> listaCategorias;
  final String nombreCategoria;

  const TabOpcionesCategorias(
      {Key? key, required this.listaCategorias, required this.nombreCategoria})
      : super(key: key);

  @override
  State<TabOpcionesCategorias> createState() => _TabOpcionesCategoriasState();
}

class _TabOpcionesCategoriasState extends State<TabOpcionesCategorias>
    with SingleTickerProviderStateMixin {
  final controllerBanner = Get.find<BannnerControllers>();

  RxInt valorSeleccionado = 0.obs;
  TabController? _tabController;

  @override
  void initState() {
    if (controllerBanner.isVisitBanner.value) {
      valorSeleccionado.value =
          controllerBanner.inicialControllerSubCategoria.value;
    }
    _tabController = new TabController(
      length: this.widget.listaCategorias.length,
      vsync: this,
      initialIndex: controllerBanner.inicialControllerSubCategoria.value,
    );
    _tabController?.addListener(() {
      valorSeleccionado.value = _tabController!.index;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final selectedColor = ConstantesColores.azul_precio;

    return DefaultTabController(
      length: this.widget.listaCategorias.length,
      child: Scaffold(
        backgroundColor: ConstantesColores.color_fondo_gris,
        appBar: AppBar(
          title: TituloPidekyCarrito(
            size: size,
            widget: TabOpciones(),
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ConstantesColores.color_fondo_gris,
            statusBarIconBrightness: Brightness.dark,
          ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          actions: <Widget>[
            BotonActualizar(),
            AccionNotificacion(),
            AccionesBartCarrito(esCarrito: false),
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: Get.width * 1,
                    decoration: BoxDecoration(
                      color: HexColor("#E4E3EC"),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Obx(() => TabBar(
                        controller: _tabController,
                        labelPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        labelColor: Colors.black,
                        isScrollable: true,
                        indicatorColor: Colors.transparent,
                        unselectedLabelColor: Colors.black,
                        onTap: (index) {
                          valorSeleccionado.value = index;
                        },
                        tabs: List<Widget>.generate(
                            this.widget.listaCategorias.length, (index) {
                          return new Tab(
                            child: Container(
                              width: size.width *
                                  this
                                      .widget
                                      .listaCategorias[index]
                                      .descripcion
                                      .toString()
                                      .length /
                                  35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: valorSeleccionado.value == index
                                    ? selectedColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: valorSeleccionado.value == index
                                      ? selectedColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    this
                                        .widget
                                        .listaCategorias[index]
                                        .descripcion,
                                    style: TextStyle(
                                        color: valorSeleccionado.value == index
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }))),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: List<Widget>.generate(
                        this.widget.listaCategorias.length, (index) {
                      return Container(
                        child: CustomBuscardorFuzzy(
                          codCategoria: widget.listaCategorias[index].codigo,
                          numEmpresa: 'nutresa',
                          tipoCategoria: 2,
                          nombreCategoria: widget.nombreCategoria,
                          isActiveBanner: false,
                          isVisibilityAppBar: false,
                          locacionFiltro: "categoria",
                          codigoProveedor: "",
                        ),
                      );
                    }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controllerBanner.setIsVisitBanner(false);
    controllerBanner.inicialControllerSubCategoria(0);
    super.dispose();
  }
}
