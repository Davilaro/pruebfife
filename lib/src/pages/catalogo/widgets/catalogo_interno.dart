import 'package:emart/_pideky/domain/producto/service/producto_service.dart';
import 'package:emart/_pideky/infrastructure/productos/producto_repository_sqlite.dart';
import 'package:emart/src/classes/uiUtil.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/dounser.dart';
import 'package:emart/src/widget/input_valores_catalogo.dart';
import 'package:emart/src/provider/logica_actualizar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

final prefs = new Preferencias();
var providerDatos = new DatosListas();

class CatalogoPoductosInterno extends StatefulWidget {
  final int tipoCategoria;

  const CatalogoPoductosInterno({Key? key, required this.tipoCategoria})
      : super(key: key);

  @override
  State<CatalogoPoductosInterno> createState() =>
      _CatalogoPoductosInternoState();
}

class _CatalogoPoductosInternoState extends State<CatalogoPoductosInterno> {
  final TextEditingController _controllerSearch = TextEditingController();
  final catalogSearchViewModel = Get.find<ControllerProductos>();

  RxList<dynamic> listaProducto = <dynamic>[].obs;
  List<dynamic> listaAllProducts = [];
  var contador = 0;

  late final String nameCategory =
      widget.tipoCategoria == 1 ? 'Promo' : 'Imperdibles';

  @override
  void initState() {
    _controllerSearch.addListener(runFilter);
    cargarProductos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //UXCAM: Se define el nombre de la pantalla
    widget.tipoCategoria == 1
        ? FlutterUxcam.tagScreenName('PromotionsPage')
        : FlutterUxcam.tagScreenName('UnmissablePage');

    final Debouncer onSearchDebouncer =
        new Debouncer(delay: new Duration(milliseconds: 500));

    final screeSize = MediaQuery.of(context).size;
    UIUtills()
        .updateScreenDimesion(width: screeSize.width, height: screeSize.height);
    return Scaffold(
        backgroundColor: ConstantesColores.color_fondo_gris,
        body: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(children: [
              _campoTexto(context, onSearchDebouncer),
              Flexible(
                  flex: 2,
                  child: Obx(() => Container(
                      height: Get.height *
                          UIUtills().getProportionalHeight(height: 0.7),
                      width: Get.width * 1,
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: RefreshIndicator(
                        color: ConstantesColores.azul_precio,
                        backgroundColor:
                            ConstantesColores.agua_marina.withOpacity(0.6),
                        onRefresh: () async {
                          await LogicaActualizar().actualizarDB();
                          setState(() {
                            cargarProductos();
                          });

                          return Future<void>.delayed(
                              const Duration(seconds: 3));
                        },
                        child: GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5.0, // Espaciado vertical
                            mainAxisSpacing:
                                4.0, // espaciado entre ejes principales (horizontal)
                            childAspectRatio: 1 / 1.7,
                            children:
                                _cargarProductosLista(listaProducto, context)
                                    .toList()),
                      ))))
            ])));
  }

  _campoTexto(BuildContext context, Debouncer onSearchDebouncer) {
    return Container(
      margin: EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: HexColor("#E4E3EC"),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _controllerSearch,
        style: TextStyle(color: HexColor("#41398D"), fontSize: 13),
        decoration: InputDecoration(
          fillColor: HexColor("#41398D"),
          hintText: 'Encuentra tus productos',
          hintStyle: TextStyle(
            color: HexColor("#41398D"),
          ),
          suffixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.fromLTRB(10.0, 15, 10.0, 0),
        ),
      ),
    );
  }

  List<Widget> _cargarProductosLista(List<dynamic> data, BuildContext context) {
    final List<Widget> opciones = [];
    if (data.length > 0 && contador == 0) {
      contador += 1;
      //FIREBASE: Llamamos el evento view_item_list
      TagueoFirebase().sendAnalityticViewItemList(data, nameCategory);
    }

    for (var element in data) {
      bool isProductoPromo = false;
      if (widget.tipoCategoria != 2) {
        isProductoPromo = true;
      }
      Producto productos = element;
      final widgetTemp = InputValoresCatalogo(
        element: productos,
        numEmpresa: prefs.numEmpresa,
        isCategoriaPromos: isProductoPromo,
        index: data.indexOf(element),
      );

      opciones.add(widgetTemp);
    }

    return opciones;
  }

  void cargarProductos() async {
    ProductoService productService =
        ProductoService(ProductoRepositorySqlite());
    listaAllProducts = await productService.cargarProductosInterno(
        widget.tipoCategoria,
        '',
        catalogSearchViewModel.precioMinimo.value,
        catalogSearchViewModel.precioMaximo.value,
        0,
        "",
        "");
    listaProducto.value = listaAllProducts;
  }

  void runFilter() {
    if (_controllerSearch.text.isEmpty) {
      listaProducto.value = listaAllProducts;
    } else {
      //FIREBASE: Llamamos el evento search
      TagueoFirebase().sendAnalityticsSearch(_controllerSearch.text);
      //UXCam: Llamamos el evento search
      UxcamTagueo().search(_controllerSearch.text);
      List listaAux = [];
      listaProducto.value = [];
      listaAllProducts.forEach((element) {
        if (element.codigo
            .toLowerCase()
            .contains(_controllerSearch.text.toLowerCase())) {
          listaProducto.add(element);
        }
        listaAux.add(element.nombre);
      });
      final fuse = Fuzzy(listaAux);
      final result = fuse.search(_controllerSearch.text);
      result
          .map((r) => listaProducto.add(listaAllProducts
              .firstWhere((element) => element.nombre == r.item)))
          .forEach(print);
    }
  }

  @override
  void dispose() {
    contador = 0;
    _controllerSearch.dispose();
    super.dispose();
  }
}
