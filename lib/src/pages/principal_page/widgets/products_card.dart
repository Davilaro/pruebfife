import 'package:emart/_pideky/domain/producto/service/producto_service.dart';
import 'package:emart/_pideky/infrastructure/productos/producto_repository_sqlite.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/src/pages/productos/detalle_producto_compra.dart';
import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/card_product_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    ProductoService productService =
        ProductoService(ProductoRepositorySqlite());
    return FutureBuilder(
        future: productService.cargarProductosInterno(
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
    for (var i = 0; i < listaProductos.length; i++) {
      var dateNow = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      bool isProductoEnOferta = false;
      bool isAgotadoLabel =
          constrollerProductos.validarAgotado(listaProductos[i]);
      bool isNewProduct = listaProductos[i].activoprodnuevo == 1 &&
          ((DateTime.parse(listaProductos[i].fechafinnuevo_1!))
                  .compareTo(dateNow) >=
              0);
      bool isPromoProduct = (listaProductos[i].activopromocion == 1 &&
              ((DateTime.parse(listaProductos[i].fechafinpromocion_1!))
                      .compareTo(dateNow) >=
                  0)) ||
          isProductoEnOferta ||
          widget.tipoCategoria == 1;
      final template = Container(
          child: FittedBox(
        fit: BoxFit.scaleDown,
        child: FutureBuilder(
            future: DBProvider.db
                .consultarProductoEnOfertaPorCodigo(listaProductos[i].codigo),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.data == listaProductos[i].codigo) {
                isProductoEnOferta = true;
              } else {
                isProductoEnOferta = false;
              }
              return CardProductCustom(
                producto: listaProductos[i],
                cartProvider: cartProvider,
                isProductoEnOferta: isProductoEnOferta,
                onTapCard: () {
                  if (prefs.usurioLogin != -1) {
                    //FIREBASE: Llamamos el evento select_item
                    TagueoFirebase()
                        .sendAnalityticSelectItem(listaProductos[i], 1);
                    //UXCam: Llamamos el evento seeDetailProduct
                    UxcamTagueo().seeDetailProduct(
                        listaProductos[i],
                        i,
                        nameCategory,
                        isAgotadoLabel,
                        isNewProduct,
                        isPromoProduct);
                  }
                  detalleProducto(listaProductos[i], cartProvider);
                },
                isAgotadoLabel: isAgotadoLabel,
                isVisibleLabelNuevo: isNewProduct,
                isVisibleLabelPromo: isPromoProduct,
              );
            }),
      ));

      opciones.add(template);
    }

    if (listaProductos.length > 0 && contador < 1) {
      //FIREBASE: Llamamos el evento view_item_list
      TagueoFirebase().sendAnalityticViewItemList(
          listaProductos, widget.tipoCategoria == 1 ? 'Promos' : 'Imperdibles');
      contador++;
    }

    return opciones;
  }

  detalleProducto(Producto element, final CarroModelo cartProvider) {
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
