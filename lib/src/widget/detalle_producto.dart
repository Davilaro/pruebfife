import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/src/modelos/productos.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/metodo_ingresados.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/widget/dialog_details_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:provider/provider.dart';

import 'acciones_carrito_bart.dart';

class DetalleProducto extends StatefulWidget {
  final Productos productos;
  final double tamano;

  const DetalleProducto(
      {Key? key, required this.productos, required this.tamano})
      : super(key: key);

  @override
  State<DetalleProducto> createState() => _DetalleProductoState();
}

class _DetalleProductoState extends State<DetalleProducto> {
  NumberFormat formatNumber = new NumberFormat("#,##0.00", "es_AR");
  final TextEditingController _controllerCantidadProducto =
      TextEditingController();
  bool isAgotado = false;

  final cargoConfirmar = Get.find<CambioEstadoProductos>();
  final constrollerProductos = Get.find<ControllerProductos>();

  @override
  void initState() {
    super.initState();
    isAgotado = constrollerProductos.validarAgotado(widget.productos);
    //FIREBASE: Llamamos el evento view_item
    TagueoFirebase().sendAnalityticViewItem(widget.productos, 1);
    setState(() {});
  }

  @override
  void dispose() {
    _controllerCantidadProducto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CarroModelo>(context);
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: locale.toString());

    _controllerCantidadProducto.text =
        isAgotado ? '0' : cargoConfirmar.controllerCantidadProducto.value;

    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      appBar: AppBar(
        title: Text(
          'Producto',
          style: TextStyle(color: HexColor("#41398D")),
        ),
        elevation: 0,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          AccionesBartCarrito(esCarrito: true),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 20, 0),
            child: Container(
              child: Text(
                '${widget.productos.nombre}',
                maxLines: 2,
                style: diseno_valores(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Container(
              alignment: Alignment.center,
              height: widget.tamano * 0.4,
              width: double.infinity,
              child: Stack(children: [
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => DialogDetailsImage(
                            Constantes().urlImgProductos +
                                '${widget.productos.codigo}.png',
                            '${widget.productos.nombrecomercial}'));
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: PinchZoomImage(
                      zoomedBackgroundColor: Colors.transparent,
                      hideStatusBarWhileZooming: true,
                      image: CachedNetworkImage(
                          imageUrl: Constantes().urlImgProductos +
                              '${widget.productos.codigo}.png',
                          placeholder: (context, url) =>
                              Image.asset('assets/jar-loading.gif'),
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/logo_login.png'),
                          fit: BoxFit.contain),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          Container(
            width: double.infinity,
            height: widget.tamano * 0.29,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(
                width: Get.width,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: Get.width * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.productos.nombrecomercial}',
                                  maxLines: 2,
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  'SKU: ' + widget.productos.codigo,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      color: HexColor("#a2a2a2"),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Visibility(
                                    visible: widget.productos.descuento != 0,
                                    child: Container(
                                      height: Get.width * 0.07,
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        '${format.currencySymbol}' +
                                            formatNumber
                                                .format(widget.productos.precio)
                                                .replaceAll(',00', ''),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.red),
                                      ),
                                    )),
                                Container(
                                  height: widget.productos.descuento != 0
                                      ? Get.width * 0.05
                                      : Get.width * 0.07,
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '${format.currencySymbol}' +
                                        formatNumber
                                            .format(
                                                widget.productos.descuento != 0
                                                    ? widget
                                                        .productos.precioinicial
                                                    : widget.productos.precio)
                                            .replaceAll(',00', ''),
                                    textAlign: TextAlign.left,
                                    style: widget.productos.descuento != 0
                                        ? TextStyle(
                                            color:
                                                ConstantesColores.azul_precio,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            decoration:
                                                TextDecoration.lineThrough)
                                        : TextStyle(
                                            color:
                                                ConstantesColores.azul_precio,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text('Precio por unidad',
                                      style: TextStyle(
                                        color: ConstantesColores.verde,
                                      )),
                                ),
                                Visibility(
                                    visible: isAgotado,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: Colors.red[100],
                                        ),
                                        height: Get.width * 0.06,
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: Text(
                                          'Agotado',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Colors.red),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      height: 45.0,
                      width: Get.width * 0.35,
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              height: 40.0,
                              width: Get.width * 0.1,
                              child: IconButton(
                                icon: Image.asset('assets/menos.png'),
                                onPressed: () =>
                                    menos(widget.productos, cartProvider),
                              ),
                            ),
                            Container(
                              width: Get.width * 0.1,
                              alignment: Alignment.bottomCenter,
                              child: ConstrainedBox(
                                constraints: new BoxConstraints(
                                  minWidth: 20,
                                  maxWidth: 100,
                                  minHeight: 40.0,
                                  maxHeight: 40.0,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  reverse: true,
                                  child: TextFormField(
                                    maxLines: 1,
                                    controller:
                                        _controllerCantidadProducto, //PedidoEmart.listaControllersPedido![widget.productos.codigo],
                                    keyboardType: TextInputType.number,
                                    textAlignVertical: TextAlignVertical.center,
                                    textAlign: TextAlign.center,
                                    maxLength: 3,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Escribe el precio de compra';
                                      }
                                      return null;
                                    },
                                    style: TextStyle(color: Colors.black),
                                    onChanged: (value) {
                                      cargoConfirmar
                                          .cambiarValoresEditex(value);
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Colors.black,
                                      hintText: '',
                                      isDense: true,
                                      counterText: "",
                                      hintStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40.0,
                              width: Get.width * 0.1,
                              child: IconButton(
                                icon: Image.asset('assets/mas.png'),
                                onPressed: () =>
                                    mas(widget.productos, cartProvider),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              llenarCarrito(widget.productos, cartProvider);
            },
            child: Visibility(
              visible: !isAgotado,
              child: Container(
                height: widget.tamano * 0.1,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                  child: Image.asset(
                    "assets/agregar_al_carrito_btn.png",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  mas(Productos producto, CarroModelo cartProvider) {
    String valorInicial = _controllerCantidadProducto.text;

    if (valorInicial.length < 3) {
      if (valorInicial == "") {
        cargoConfirmar.cambiarValoresEditex('1');
        setState(() {});
      } else {
        int valoSuma = int.parse(valorInicial) + 1;
        setState(() {
          cargoConfirmar.cambiarValoresEditex('$valoSuma');
        });
      }
    }
  }

  menos(Productos producto, CarroModelo cartProvider) {
    String valorInicial = _controllerCantidadProducto.text;
    if (valorInicial != "" && valorInicial != '1' && valorInicial != '0') {
      int valorResta = int.parse(valorInicial) - 1;
      if (valorResta <= 0) {
        setState(() {
          cargoConfirmar.cambiarValoresEditex('0');
        });
      } else {
        setState(() {
          cargoConfirmar.cambiarValoresEditex('$valorResta');
        });
      }
    }
  }

  llenarCarrito(Productos producto, CarroModelo cartProvider) {
    if (_controllerCantidadProducto.text == '') {
    } else if (_controllerCantidadProducto.text == '0') {
    } else {
      PedidoEmart.listaControllersPedido![producto.codigo]!.text =
          _controllerCantidadProducto.text;
      PedidoEmart.registrarValoresPedido(
          producto, _controllerCantidadProducto.text, true);
      MetodosLLenarValores().calcularValorTotal(cartProvider);

      cargoConfirmar.cargarProductoNuevo(
          ProductoCambiante.m(widget.productos.nombre, widget.productos.codigo),
          2);
      cartProvider.guardarCambiodevista = 2;
      PedidoEmart.cambioVista.value = 2;
      //FIREBASE: Llamamos el evento add_to_cart
      TagueoFirebase().sendAnalityticAddToCart(
          producto, int.parse(_controllerCantidadProducto.text));
      setState(() {});
    }
  }

  TextStyle diseno_valores() => TextStyle(
      fontSize: 16.0, color: HexColor("#43398E"), fontWeight: FontWeight.bold);
  TextStyle diseno_valores_text() =>
      TextStyle(fontSize: 20.0, color: HexColor("#43398E"));
}
