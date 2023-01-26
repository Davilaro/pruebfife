import 'package:emart/_pideky/domain/producto/service/producto_service.dart';
import 'package:emart/_pideky/infrastructure/productos/producto_repository_sqlite.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/src/pages/productos/detalle_producto_search.dart';
import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:emart/src/widget/imagen_notification.dart';
import 'package:emart/src/widget/soporte.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

final prefs = new Preferencias();
final TextEditingController _controllerUser = TextEditingController();
RxList<Producto> listaProducto = <Producto>[].obs;
RxString searchInput = "".obs;
List<Producto> listaAllProducts = [];
RxList<String> listaRecientes = <String>[].obs;

class SearchFuzzy extends StatefulWidget {
  SearchFuzzy({Key? key}) : super(key: key);

  @override
  _SearchFuzzyState createState() => _SearchFuzzyState();
}

class _SearchFuzzyState extends State<SearchFuzzy> {
  @override
  void initState() {
    cargarProductos();
    super.initState();
  }

  @override
  void dispose() {
    listaAllProducts = [];
    listaProducto.value = [];
    super.dispose();
  }

  void cargarProductos() async {
    ProductoService productService =
        ProductoService(ProductoRepositorySqlite());
    listaAllProducts = await productService.cargarProductosFiltro('', "");
  }

  void runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      listaProducto.value = [];
    } else {
      List listaAux = [];
      listaProducto.value = [];
      listaAllProducts.forEach((element) {
        if (element.codigo
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase())) {
          listaProducto.add(element);
        }
        listaAux.add(element.nombre);
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
    final size = MediaQuery.of(context).size;
    final cargoConfirmar = Get.find<CambioEstadoProductos>();
    final cartProvider = Provider.of<CarroModelo>(context);
    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      appBar: AppBar(
        title: titulo_pideky(size: size),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(10, 2.0, 0, 0),
          child: Container(
            width: 100,
            child: new IconButton(
              icon: SvgPicture.asset('assets/image/boton_soporte.svg'),
              onPressed: () => {
                //UXCam: Llamamos el evento clickSoport
                UxcamTagueo().clickSoport(),
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
        ),
        elevation: 0,
        actions: <Widget>[
          BotonActualizar(),
          AccionNotificacion(),
          AccionesBartCarrito(esCarrito: false),
        ],
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
                          color: ConstantesColores.verde,
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
                    title: title == '' ? 'Producto' : title,
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

class titulo_pideky extends StatelessWidget {
  const titulo_pideky({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translationValues(-10.0, 3.0, 0.0),
      child: Container(
          height: 30,
          width: size.width * 0.3,
          child: SvgPicture.asset('assets/image/pp_bar.svg', fit: BoxFit.fill)),
    );
  }
}

class titulo_pideky_carrito extends StatelessWidget {
  const titulo_pideky_carrito({
    Key? key,
    required this.widget,
    required this.size,
  }) : super(key: key);

  final Size size;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translationValues(-10.0, 3.0, 0.0),
      child: GestureDetector(
        child: Container(
            height: 30,
            width: size.width * 0.3,
            child:
                SvgPicture.asset('assets/image/app_bar.svg', fit: BoxFit.fill)),
        onTap: () => {
          Navigator.of(context).pushNamedAndRemoveUntil(
              'tab_opciones', (Route<dynamic> route) => false),
        },
      ),
    );
  }
}
