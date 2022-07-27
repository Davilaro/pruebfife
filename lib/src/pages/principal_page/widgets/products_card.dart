import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/src/modelos/productos.dart';
import 'package:emart/src/pages/productos/detalle_producto_compra.dart';
import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

final prefs = new Preferencias();

class ProductsCard extends StatefulWidget {
  final int tipoCategoria;

  const ProductsCard(this.tipoCategoria);

  @override
  State<ProductsCard> createState() => _ProductsCardState();
}

class _ProductsCardState extends State<ProductsCard> {
  RxString codigo = "".obs;

  final cargoConfirmar = Get.find<CambioEstadoProductos>();
  NumberFormat formatNumber = new NumberFormat("#,##0.00", "es_AR");
  bool isAgotado = false;
  var contador = 0;
  final constrollerProductos = Get.find<ControllerProductos>();
  late final String nameCategory =
      widget.tipoCategoria == 1 ? 'Promos' : 'Imperdibles';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CarroModelo>(context);
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: locale.toString());

    return FutureBuilder(
        future: DBProvider.db.cargarProductosInterno(
            widget.tipoCategoria, '', 0, 1000000, 8, "", ""),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              scrollDirection: Axis.horizontal,
              children:
                  _cargarDatos(context, snapshot.data, cartProvider, format),
            );
          }
        });
  }

  List<Widget> _cargarDatos(BuildContext context, List<dynamic> listaProductos,
      cartProvider, format) {
    final List<Widget> opciones = [];
    if (listaProductos.length == 0) {
      return opciones..add(Text('No hay informacion para mostrar'));
    }
    listaProductos.forEach((element) {
      final template = Container(
          child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Card(
            shape: RoundedRectangleBorder(
                side: new BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(8.0)),
            child: _cargarDisenoInterno(
              element,
              context,
              cartProvider,
              format,
            )),
      ));

      opciones.add(template);
    });

    if (listaProductos.length > 0 && contador < 1) {
      //FIREBASE: Llamamos el evento view_item_list
      TagueoFirebase().sendAnalityticViewItemList(
          listaProductos, widget.tipoCategoria == 1 ? 'Promos' : 'Imperdibles');
      contador++;
    }

    return opciones;
  }

  _cargarDisenoInterno(Productos element, BuildContext context,
      CarroModelo cartProvider, NumberFormat format) {
    isAgotado = constrollerProductos.validarAgotado(element);
    return GestureDetector(
        onTap: () {
          //FIREBASE: Llamamos el evento select_item
          TagueoFirebase().sendAnalityticSelectItem(element, 1);
          detalleProducto(element, cartProvider);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //mensaje de precio especial y imagen producto
            Container(
              width: Get.width * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  (element.fechafinpromocion_1!.contains(RegExp(r'[0-9]')))
                      ? Container(
                          padding: EdgeInsets.only(top: 5, right: 10),
                          child: Visibility(
                            visible: element.activopromocion == 1 &&
                                ((DateTime.parse(element.fechafinpromocion_1!))
                                        .compareTo(DateTime.now()) >=
                                    0),
                            child: Image.asset(
                              'assets/promo_abel.png',
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(),
                  (element.fechafinnuevo_1!.contains(RegExp(r'[0-9]')))
                      ? Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(top: 5, right: 10),
                          child: Visibility(
                            visible: element.activoprodnuevo == 1 &&
                                ((DateTime.parse(element.fechafinnuevo_1!))
                                        .compareTo(DateTime.now()) >=
                                    0),
                            child: Image.asset(
                              'assets/nuevos_label.png',
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5.0),
              margin: (element.activopromocion == 1 &&
                          ((DateTime.parse(element.fechafinpromocion_1!))
                                  .compareTo(DateTime.now()) >=
                              0)) ==
                      false
                  ? EdgeInsets.only(top: 15)
                  : EdgeInsets.zero,
              // height: element.descuento == 0 ? 120 : 100,
              height: 100,
              width: Get.width * 0.22,
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: CachedNetworkImage(
                  imageUrl:
                      Constantes().urlImgProductos + '${element.codigo}.png',
                  placeholder: (context, url) =>
                      Image.asset('assets/jar-loading.gif'),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/logo_login.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),

            //cuerpo de la targeta
            Container(
              width: Get.width * 0.4,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 8),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${element.nombre}',
                              maxLines: 2,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ConstantesColores.verde),
                            ),
                            Text(
                              'SKU: ${element.codigo}',
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: HexColor("#a2a2a2")),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Visibility(
                              visible: element.activopromocion == 1 &&
                                  ((DateTime.parse(
                                              element.fechafinpromocion_1!))
                                          .compareTo(DateTime.now()) >=
                                      0),
                              child: Container(
                                height: 25,
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  '${format.currencySymbol}' +
                                      formatNumber
                                          .format(element.precio)
                                          .replaceAll(',00', ''),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.red),
                                ),
                              )),
                          Container(
                            height: element.activopromocion == 1 &&
                                    ((DateTime.parse(
                                                element.fechafinpromocion_1!))
                                            .compareTo(DateTime.now()) >=
                                        0)
                                ? Get.width * 0.05
                                : Get.width * 0.07,
                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            alignment: Alignment.topLeft,
                            child: Text(
                              '${format.currencySymbol}' +
                                  formatNumber
                                      .format(element.activopromocion == 1 &&
                                              ((DateTime.parse(element
                                                          .fechafinpromocion_1!))
                                                      .compareTo(
                                                          DateTime.now()) >=
                                                  0)
                                          ? element.precioinicial
                                          : element.precio)
                                      .replaceAll(',00', ''),
                              textAlign: TextAlign.left,
                              style: element.activopromocion == 1 &&
                                      ((DateTime.parse(
                                                  element.fechafinpromocion_1!))
                                              .compareTo(DateTime.now()) >=
                                          0)
                                  ? TextStyle(
                                      color: ConstantesColores.azul_precio,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      decoration: TextDecoration.lineThrough)
                                  : TextStyle(
                                      color: ConstantesColores.azul_precio,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                        visible: isAgotado,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.red[100],
                            ),
                            height: Get.width * 0.06,
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Text(
                              'Agotado',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.red),
                            ),
                          ),
                        )),
                  ]),
            ),
            Visibility(
              visible: !isAgotado,
              child: Container(
                  margin: EdgeInsets.only(bottom: 5),
                  height: Get.width * 0.1,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    child: Container(
                      width: 140,
                      height: 30,
                      child: Image.asset(
                        "assets/agregar_btn.png",
                      ),
                    ),
                    onTap: () {
                      //FIREBASE: Llamamos el evento select_item
                      TagueoFirebase().sendAnalityticSelectItem(element, 1);
                      detalleProducto(element, cartProvider);
                    },
                  )),
            ),
          ],
        ));
  }

  detalleProducto(Productos element, final CarroModelo cartProvider) {
    if (prefs.usurioLogin == -1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      PedidoEmart.inicializarValoresFabricante();
      cartProvider.actualizarListaFabricante =
          PedidoEmart.listaPrecioPorFabricante!;
      cargoConfirmar.cambiarValoresEditex(PedidoEmart.obtenerValor(element)!);
      cargoConfirmar.cargarProductoNuevo(
          ProductoCambiante.m(element.nombre, element.codigo), 1);
      cartProvider.guardarCambiodevista = 1;
      PedidoEmart.cambioVista.value = 1;

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CambiarDetalleCompra()));
    }
  }
}
