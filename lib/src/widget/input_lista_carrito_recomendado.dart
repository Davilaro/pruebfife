import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/presentation/product/view/detalle_producto_compra.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/shared/widgets/image_button.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/_pideky/domain/product/model/product_model.dart';
import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/metodo_ingresados.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:intl/intl.dart";
import 'package:provider/provider.dart';

class CarritoDisenoListaR extends StatefulWidget {
  final int numTienda;
  final Product productos;
  final String tipoVenta;

  const CarritoDisenoListaR(this.numTienda, this.productos, this.tipoVenta);

  @override
  State<CarritoDisenoListaR> createState() => _CarritoDisenoListaRState();
}

class _CarritoDisenoListaRState extends State<CarritoDisenoListaR> {
  final prefs = new Preferencias();
  final cargoConfirmar = Get.find<CambioEstadoProductos>();
  ProductViewModel productoViewModel = Get.find();

  RxBool isProductoEnOferta = false.obs;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      dynamic responseOferta = await DBProvider.db
          .consultarProductoEnOfertaPorCodigo(widget.productos.codigo);
      if (responseOferta == widget.productos.codigo) {
        isProductoEnOferta.value = true;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartViewModel>(context);
    // Locale locale = Localizations.localeOf(context);
    // var format = NumberFormat.simpleCurrency(locale: locale.toString());
    var locale = Intl().locale;

    var format = locale.toString() != 'es_CO'
        ? locale.toString() == 'es_CR'
            ? NumberFormat.currency(locale: locale.toString(), symbol: '\₡')
            : NumberFormat.simpleCurrency(locale: locale.toString())
        : NumberFormat.currency(locale: locale.toString(), symbol: '\$');

    return Container(
      width: 180,
      height: 250,
      child: Card(
        shape: RoundedRectangleBorder(
            side: new BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8.0)),
        child: _cargarDisenoInterno(
            widget.productos, context, cartProvider, format),
      ),
    );
  }

  _cargarDisenoInterno(Product element, BuildContext context,
      CartViewModel cartProvider, NumberFormat format) {
    var dateNow =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return GestureDetector(
      onTap: () => detalleProducto(element, cartProvider),
      child: Column(
        children: [
          Column(
            children: [
              Visibility(
                visible: element.activopromocion == 1 &&
                    ((DateTime.parse(element.fechafinpromocion_1!))
                            .compareTo(dateNow) >=
                        0),
                child: Container(
                  height: 30,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Image.asset(
                    'assets/image/promo_abel.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Visibility(
                visible: element.activoprodnuevo == 1 &&
                    ((DateTime.parse(element.fechafinnuevo_1!))
                            .compareTo(dateNow) >=
                        0),
                child: Container(
                  height: 30,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Image.asset(
                    'assets/image/nuevos_label.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0),
                height: (element.activopromocion == 1 &&
                            ((DateTime.parse(element.fechafinpromocion_1!))
                                    .compareTo(dateNow) >=
                                0)) ==
                        false
                    ? 140
                    : 100,
                width: Get.width * 0.3,
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    imageUrl:
                        Constantes().urlImgProductos + '${element.codigo}.png',
                    placeholder: (context, url) =>
                        Image.asset('assets/image/jar-loading.gif'),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/image/logo_login.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 80,
            width: Get.width * 0.5,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Text(
                      '${element.nombre}',
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ConstantesColores.verde),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    productoViewModel.getCurrency(element.precio),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: ConstantesColores.azul_precio,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ]),
          ),
          Container(
              height: Get.width * 0.1,
              alignment: Alignment.center,
              child: ImageButton(
                children: <Widget>[],
                width: 140,
                height: 30,
                paddingTop: 5,
                pressedImage: Image.asset(
                  "assets/image/iniciar_sesion_btn.png",
                ),
                unpressedImage: Image.asset("assets/image/agregar_btn.png"),
                onTap: () => detalleProducto(element, cartProvider),
              )),
        ],
      ),
    );
  }

  detalleProducto(Product element, final CartViewModel cartProvider) {
    Product productos = element;

    if (prefs.usurioLogin == -1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      PedidoEmart.inicializarValoresFabricante();
      cartProvider.actualizarListaFabricante =
          PedidoEmart.listaPrecioPorFabricante!;
      cargoConfirmar.cambiarValoresEditex(PedidoEmart.obtenerValor(productos)!);
      cargoConfirmar.cargarProductoNuevo(
          ProductoCambiante.m(productos.nombre, productos.codigo), 2);
      cartProvider.guardarCambiodevista = 1;
      PedidoEmart.cambioVista.value = 1;

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CambiarDetalleCompra(cambioVista: 1, isByBuySellEarn: false,)));
    }
  }

  mas(Product producto, CartViewModel cartProvider) {
    String valorInicial = PedidoEmart.obtenerValor(producto)!;

    if (valorInicial == "") {
      PedidoEmart.listaControllersPedido![producto.codigo]!.text = "1";
      PedidoEmart.registrarValoresPedido(producto, '1', true);
    } else {
      int valoSuma = int.parse(valorInicial) + 1;
      setState(() {
        PedidoEmart.listaControllersPedido![producto.codigo]!.text =
            "$valoSuma";
        PedidoEmart.registrarValoresPedido(producto, '$valoSuma', true);
      });
    }

    MetodosLLenarValores().calcularValorTotal(cartProvider);
  }

  menos(Product producto, CartViewModel cartProvider) {
    String valorInicial = PedidoEmart.obtenerValor(producto)!;

    if (valorInicial != "") {
      int valorResta = int.parse(valorInicial) - 1;
      if (valorResta <= 0) {
        setState(() {
          PedidoEmart.listaControllersPedido![producto.codigo]!.text = "0";
          PedidoEmart.registrarValoresPedido(producto, '0', false);
        });
      } else {
        setState(() {
          PedidoEmart.listaControllersPedido![producto.codigo]!.text =
              "$valorResta";
          PedidoEmart.registrarValoresPedido(producto, '$valorResta', true);
        });
      }
    }

    MetodosLLenarValores().calcularValorTotal(cartProvider);
  }
}
