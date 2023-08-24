import 'package:emart/_pideky/domain/marca/model/marca.dart';
import 'package:emart/_pideky/domain/marca/service/marca_service.dart';
import 'package:emart/_pideky/domain/producto/service/producto_service.dart';
import 'package:emart/_pideky/infrastructure/marcas/marca_repository_sqlite.dart';
import 'package:emart/_pideky/infrastructure/productos/producto_repository_sqlite.dart';
import 'package:emart/_pideky/presentation/productos/view/detalle_producto_search.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/shared/widgets/drawer_sucursales.dart';
import 'package:emart/shared/widgets/new_app_bar.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

final prefs = new Preferencias();
final TextEditingController _controllerUser = TextEditingController();

RxList<Producto> listaProducto = <Producto>[].obs;
RxList<Marca> listaMarcas = <Marca>[].obs;

RxString searchInput = "".obs;

List<Producto> listaAllProducts = [];
List<Marca> listaAllMarcas = [];
RxList<String> listaRecientes = <String>[].obs;

class SearchFuzzy extends StatefulWidget {
  SearchFuzzy({Key? key}) : super(key: key);

  @override
  _SearchFuzzyState createState() => _SearchFuzzyState();
}

class _SearchFuzzyState extends State<SearchFuzzy> {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    cargarProductos();
    super.initState();
  }

  @override
  void dispose() {
    listaAllProducts = [];
    listaProducto.value = [];
    listaMarcas.value = [];
    super.dispose();
  }

  void cargarProductos() async {
    ProductoService productService =
        ProductoService(ProductoRepositorySqlite());

    MarcaService marcaService = MarcaService(MarcaRepositorySqlite());

    listaAllProducts = await productService.cargarProductosFiltro('', "");
    listaAllMarcas = await marcaService.getAllMarcas();
  }

  void runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      listaProducto.value = [];
      listaMarcas.value = [];
    } else {
      List listaAux = [];

      listaProducto.value = [];
      listaMarcas.value = [];

      listaAllProducts.forEach((element) {
        if (element.codigo
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase())) {
          listaProducto.add(element);
        }
        listaAux.add(element.nombre);
      });

      listaAllMarcas.forEach((element) {
        if (element.titulo
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase())) {
          listaMarcas.add(element);
        }
        listaAux.add(element.titulo);
      });

      final fuse = Fuzzy(listaAux);
      final result = fuse.search(enteredKeyword);

      result
          .map((r) => listaProducto.add(listaAllProducts
              .firstWhere((element) => element.nombre == r.item)))
          .forEach(print);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cargoConfirmar = Get.find<CambioEstadoProductos>();
    final cartProvider = Provider.of<CarroModelo>(context);
    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      key: drawerKey,
      drawerEnableOpenDragGesture: prefs.usurioLogin == 1 ? true : false,
      drawer: DrawerSucursales(drawerKey),
      appBar: PreferredSize(
        preferredSize: prefs.usurioLogin == 1
            ? const Size.fromHeight(118)
            : const Size.fromHeight(70),
        child: SafeArea(child: NewAppBar(drawerKey)),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                      _campoTexto(context)
                    ],
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Obx(() => Text(
                  searchInput.isEmpty
                      ? 'Estas buscando en todas las secciones'
                      : 'Estas buscando \'$searchInput\' en todas las secciones',
                  style: TextStyle(
                      color: Colors.black.withOpacity(.5),
                      fontSize: 13,
                      fontWeight: FontWeight.bold))),
            ),
            SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      height: 300,
                      child: Obx(() => ListView.builder(
                            itemCount: listaProducto.length,
                            itemBuilder: (BuildContext context, int position) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      logicaSeleccion(listaProducto[position],
                                          cargoConfirmar, cartProvider);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Text(
                                            listaProducto[position].nombre,
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(.4),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        )),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                              left: 10,
                                              right: 20),
                                          child: Icon(
                                            Icons.search,
                                            color: Colors.black.withOpacity(.4),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider()
                                ],
                              );
                            },
                          )),
                    ),
                    Divider(),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Busquedas recientes",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Divider(),
                    Container(
                      child: Obx(() => Column(
                            children: listaBusquedasRecientes(),
                          )),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> listaBusquedasRecientes() {
    List<Widget> opciones = [];

    if (listaRecientes.length == 0) {
      return opciones
        ..add(
          Text(
            'No hay busquedas recientes',
            style: TextStyle(
                color: Colors.black.withOpacity(.4),
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
        );
    }

    listaRecientes.forEach((element) {
      final template = Column(
        children: [
          InkWell(
            onTap: () {
              searchInput.value = element;
              runFilter(element);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    element,
                    style: TextStyle(
                        color: Colors.black.withOpacity(.4),
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 10, right: 20),
                  child: Icon(
                    Icons.search,
                    color: Colors.black.withOpacity(.4),
                  ),
                ),
              ],
            ),
          ),
          Divider()
        ],
      );

      opciones.add(template);
    });

    return opciones;
  }

  void logicaSeleccion(Producto producto, cargoConfirmar, cartProvider) {
    if (_controllerUser.text != '') {
      listaRecientes.add(_controllerUser.text);
    }
    if (prefs.usurioLogin == -1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      PedidoEmart.inicializarValoresFabricante();
      cartProvider.actualizarListaFabricante =
          PedidoEmart.listaPrecioPorFabricante!;
      cargoConfirmar.cambiarValoresEditex(PedidoEmart.obtenerValor(producto)!);
      cargoConfirmar.cargarProductoNuevo(
          ProductoCambiante.m(producto.nombre, producto.codigo), 1);
      cartProvider.guardarCambiodevista = 1;
      PedidoEmart.cambioVista.value = 1;
      String title = searchInput.value;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetalleProductoSearch(
                    producto: producto,
                    tamano: Get.height * .8,
                    title: title == '' ? S.current.product : title,
                  )));
    }
    _controllerUser.text = "";
    searchInput.value = "";
    listaProducto.value = [];
  }

  _campoTexto(BuildContext context) {
    return Container(
        height: 50,
        width: Get.width * 0.86,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
          color: HexColor("#E4E3EC"),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: _controllerUser,
          style: TextStyle(color: HexColor("#41398D"), fontSize: 13),
          decoration: InputDecoration(
            fillColor: HexColor("#41398D"),
            hintText: 'Encuentra lo que necesitas',
            hintStyle: TextStyle(
              color: HexColor("#41398D"),
            ),
            suffixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: IconButton(
                  onPressed: () {
                    runFilter(_controllerUser.text);
                  },
                  icon: Icon(
                    Icons.search,
                    color: HexColor("#41398D"),
                  ),
                )),
            border: InputBorder.none,
            contentPadding: EdgeInsets.fromLTRB(10.0, 15, 10.0, 0),
          ),
          onChanged: (value) {
            searchInput.value = value;
            //FIREBASE: Llamamos el evento search
            TagueoFirebase().sendAnalityticsSearch(value);
            //UXCam: Llamamos el evento search
            UxcamTagueo().search(value);
            runFilter(value);
          },
        ));
  }
}
