import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/modelos/productos.dart';
import 'package:emart/src/pages/productos/detalle_producto_compra.dart';
import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/metodo_ingresados.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imagebutton/imagebutton.dart';
import "package:intl/intl.dart";
import 'package:provider/provider.dart';

NumberFormat formatNumber = new NumberFormat("#,##0.00", "es_AR");

class CarritoDisenoListaR extends StatefulWidget {
  final int numTienda;
  final Productos productos;
  final String tipoVenta;

  const CarritoDisenoListaR(this.numTienda, this.productos, this.tipoVenta);

  @override
  State<CarritoDisenoListaR> createState() => _CarritoDisenoListaRState();
}

class _CarritoDisenoListaRState extends State<CarritoDisenoListaR> {
  final prefs = new Preferencias();
  final cargoConfirmar = Get.find<CambioEstadoProductos>();
  RxBool isProductoEnOferta = false.obs;
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      print(widget.productos.codigo);
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
    final cartProvider = Provider.of<CarroModelo>(context);
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: locale.toString());

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

  _cargarDisenoInterno(Productos element, BuildContext context,
      CarroModelo cartProvider, NumberFormat format) {
    return GestureDetector(
      onTap: () => detalleProducto(element, cartProvider),
      child: Column(
        children: [
          Column(
            children: [
              Visibility(
                visible: (element.activopromocion == 1 &&
                        ((DateTime.parse(element.fechafinpromocion_1!))
                                .compareTo(DateTime.now()) >=
                            0)) ||
                    isProductoEnOferta.value,
                child: Container(
                  height: 30,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Image.asset(
                    'assets/promo_abel.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Visibility(
                visible: element.activoprodnuevo == 1 &&
                    ((DateTime.parse(element.fechafinnuevo_1!))
                            .compareTo(DateTime.now()) >=
                        0),
                child: Container(
                  height: 30,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Image.asset(
                    'assets/nuevos_label.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0),
                height: (element.activopromocion == 1 &&
                                ((DateTime.parse(element.fechafinpromocion_1!))
                                        .compareTo(DateTime.now()) >=
                                    0)) ==
                            false ||
                        isProductoEnOferta.value
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
                        Image.asset('assets/jar-loading.gif'),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/logo_login.png'),
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
                    '${format.currencySymbol}' +
                        formatNumber
                            .format(element.precio)
                            .replaceAll(',00', ''),
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
                  "assets/iniciar_sesion_btn.png",
                ),
                unpressedImage: Image.asset("assets/agregar_btn.png"),
                onTap: () => detalleProducto(element, cartProvider),
              )),
        ],
      ),
    );
  }

  detalleProducto(Productos element, final CarroModelo cartProvider) {
    Productos productos = element;

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
          MaterialPageRoute(builder: (context) => CambiarDetalleCompra()));
    }
  }

  mas(Productos producto, CarroModelo cartProvider) {
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

  menos(Productos producto, CarroModelo cartProvider) {
    String valorInicial = PedidoEmart.obtenerValor(producto)!;

    if (valorInicial == "") {
    } else {
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

  double _carcularValor(precio, String? obtenerValor) {
    double valor = precio * int.parse(obtenerValor!);

    return valor;
  }

  eliminar(Productos producto, CarroModelo cartProvider) {
    setState(() {
      PedidoEmart.listaControllersPedido![producto.codigo]!.text = "0";
      PedidoEmart.registrarValoresPedido(producto, '0', false);
    });

    MetodosLLenarValores().calcularValorTotal(cartProvider);
  }

  int obtenerValorProducto(Productos producto, CarroModelo cartProvider) {
    String valorInicial = PedidoEmart.obtenerValor(producto)!;

    if (valorInicial == "") {
      return 0;
    } else {
      int valor = int.parse(valorInicial);
      if (valor > 0) {
        return 1;
      } else {
        return 0;
      }
    }
  }
}
