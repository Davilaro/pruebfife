import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/src/modelos/productos.dart';
import 'package:emart/src/pages/carrito/carrito_compras.dart';
import 'package:emart/src/pages/principal_page/tab_opciones.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/widget/imagen_notification.dart';
import 'package:emart/src/widget/titulo_pideky_carrito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

NumberFormat formatNumber = new NumberFormat("#,##0.00", "es_AR");
final prefs = new Preferencias();
final TextEditingController _controllerBuscarProductoMarca =
    TextEditingController();

class IrMiCarrito extends StatefulWidget {
  final Productos productos;
  final double tamano;

  const IrMiCarrito({Key? key, required this.productos, required this.tamano})
      : super(key: key);

  @override
  State<IrMiCarrito> createState() => _IrMiCarritoState();
}

class _IrMiCarritoState extends State<IrMiCarrito> {
  bool productoEncontrado = false;

  @override
  void initState() {
    super.initState();
    PedidoEmart.iniciarProductosPorFabricante();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CarroModelo>(context);
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: locale.toString());
    final size = MediaQuery.of(context).size;

    try {
      if (cartProvider.getListaFabricante[widget.productos.fabricante] ==
          null) {
        productoEncontrado = false;
      } else {
        productoEncontrado = PedidoEmart.listaProductosPorFabricante!.length > 0
            ? cartProvider.getListaFabricante[widget.productos.fabricante]
                    ["precioFinal"] <
                PedidoEmart.listaProductosPorFabricante![
                    widget.productos.fabricante]["preciominimo"]
            : false;
      }
    } catch (e) {
      productoEncontrado = false;
    }

    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      appBar: AppBar(
        title: TituloPidekyCarrito(
          widget: TabOpciones(),
          size: size,
        ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        actions: <Widget>[
          AccionNotificacion(),
          AccionesBartCarrito(esCarrito: false),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Container(
                height: size.height * 0.05,
                child: Text(
                  'Agregaste a tu carrito:',
                  style: diseno_valores(),
                ),
              ),
            ),
            //INFORMACION DEL PRODUCTO
            Container(
              height: widget.tamano * 0.30,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: widget.tamano * 0.15,
                          width: Get.width * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: CachedNetworkImage(
                              imageUrl: Constantes().urlImgProductos +
                                  '${widget.productos.codigo}.png',
                              placeholder: (context, url) =>
                                  Image.asset('assets/jar-loading.gif'),
                              errorWidget: (context, url, error) =>
                                  Image.asset('assets/logo_login.png'),
                              fit: BoxFit.contain),
                        ),
                        Container(
                          height: widget.tamano * 0.28,
                          width: Get.width * 0.4,
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                      // height: Get.height * 0.13,
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      child: Text('${widget.productos.nombre}',
                                          maxLines: 4,
                                          style: TextStyle(
                                              color: HexColor('30C3A3'),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)))),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  // height: Get.height * 0.08,
                                  child: Column(
                                    children: [
                                      cargarValorPrecio(
                                          widget.productos.descuento, format),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //BOTONES DE ACCION
            Container(
              // height: widget.tamano * 0.2,
              child: Column(
                children: [
                  Center(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Container(
                          width: 240,
                          height: 50,
                          child: GestureDetector(
                            child: Image.asset(
                              "assets/seguir_comprando_btn.png",
                            ),
                            onTap: () => {
                              Navigator.pop(context, true),
                            },
                          ),
                        )),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Container(
                        width: 240,
                        height: 50,
                        child: GestureDetector(
                          child: Image.asset(
                            "assets/ir_carrito_btn.png",
                          ),
                          onTap: () => pasarCarrito(),
                        ),
                      )),
                ],
              ),
            ),
            //MENSAJE DE PEDIDO MINIMO
            productoEncontrado
                ? Container(
                    height: size.height * 0.15,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Center(
                      child: Row(
                        children: [
                          Container(
                            width: size.width * 0.1,
                            child: IconButton(
                              icon: SvgPicture.asset(
                                  'assets/check_producto_agregado.svg'),
                              onPressed: () => {},
                            ),
                          ),
                          Expanded(
                              child: Center(
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text:
                                        'Has agregado un producto al carrito. ',
                                    style: TextStyle(
                                        color: ConstantesColores.gris_oscuro,
                                        fontSize: size.width * 0.04,
                                        fontFamily: 'RoundedMplus1c')),
                                TextSpan(
                                  text:
                                      'Recuerda que el pedido mínimo para ${_nombreFabricante(widget.productos.fabricante)} es de ${format.currencySymbol}${cargarResultado(cartProvider)}',
                                  style: TextStyle(
                                      color: ConstantesColores.rojo_letra,
                                      fontSize: size.width * 0.04,
                                      fontFamily: 'RoundedMplus1c'),
                                )
                              ]),
                            ),
                          ))
                        ],
                      ),
                    ))
                : widget.productos.fabricante!.toUpperCase() != 'MEALS'
                    ? Container()
                    : cargarWiguet(size, cartProvider, format)
          ],
        ),
      ),
    );
  }

  _campoTexto(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      padding: EdgeInsets.fromLTRB(20, 10, 5, 0),
      decoration: BoxDecoration(
        color: HexColor("#E4E3EC"),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _controllerBuscarProductoMarca,
        style: TextStyle(color: HexColor("#41398D"), fontSize: 11.5),
        decoration: InputDecoration(
            fillColor: HexColor("#41398D"),
            hintText: 'Buscar tus productos de esta marca',
            hintStyle: TextStyle(
              color: HexColor("#41398D"),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Icon(
                Icons.search,
                color: HexColor("#41398D"),
              ),
            ),
            border: InputBorder.none),
      ),
    );
  }

  //SE CREA UNA RESPUESTA PARA DEVOLVER
  Future<void> pasarCarrito() async {
    var resul = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => CarritoCompras(numEmpresa: prefs.numEmpresa)),
    );
  }

  TextStyle diseno_valores() => TextStyle(
      fontSize: 18.0, color: HexColor("#43398E"), fontWeight: FontWeight.bold);
  TextStyle diseno_valores_interno() => TextStyle(
      fontSize: 15.0, color: HexColor("#43398E"), fontWeight: FontWeight.bold);
  TextStyle diseno_valores_text() =>
      TextStyle(fontSize: 20.0, color: HexColor("#43398E"));

  String cargarResultado(CarroModelo cartProvider) {
    double precio =
        PedidoEmart.listaProductosPorFabricante![widget.productos.fabricante]
            ["preciominimo"];
    var valor = PedidoEmart.listaProductosPorFabricante!.length > 0
        ? formatNumber.format(precio.toInt()).replaceAll(',00', '')
        : "0";

    return valor;
  }

  String cargarResultadoPedido(CarroModelo cartProvider) {
    double precio =
        PedidoEmart.listaProductosPorFabricante![widget.productos.fabricante]
                ["topeMinimo"] *
            1.19;
    var valor = PedidoEmart.listaProductosPorFabricante!.length > 0
        ? formatNumber.format(precio.toInt()).replaceAll(',00', '')
        : "0";

    return valor;
  }

  String _nombreFabricante(String? fabricante) {
    String nombre = '';
    for (int i = 0; i < PedidoEmart.listaFabricante!.length; i++) {
      if (PedidoEmart.listaFabricante![i].empresa == fabricante) {
        nombre = PedidoEmart.listaFabricante![i].nombrecomercial;
      }
    }
    return nombre;
  }

  bool cargarResultadoPedidoCondicion(CarroModelo cartProvider) {
    double valor = PedidoEmart.listaProductosPorFabricante!.length > 0
        ? PedidoEmart.listaProductosPorFabricante![widget.productos.fabricante]
                ["topeMinimo"] *
            1.19
        : 0.0;

    double valorMinimo = cartProvider
        .getListaFabricante[widget.productos.fabricante]["precioFinal"];

    return valor > valorMinimo;
  }

  Widget cargarWiguet(size, CarroModelo cartProvider, format) {
    return cargarResultadoPedidoCondicion(
      cartProvider,
    )
        ? Container(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Container(
                height: widget.tamano * 0.2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Center(
                  child: Row(
                    children: [
                      Container(
                        width: size.width * 0.1,
                        child: IconButton(
                          icon: SvgPicture.asset(
                              'assets/check_producto_agregado.svg'),
                          onPressed: () => {},
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'Has agregado un producto al carrito. ',
                                  style: TextStyle(
                                      color: ConstantesColores.gris_oscuro,
                                      fontSize: size.width * 0.04,
                                      fontFamily: 'RoundedMplus1c')),
                              TextSpan(
                                  text:
                                      'Recuerda que tu pedido de ${_nombreFabricante(widget.productos.fabricante)} debe ser superior a ${format.currencySymbol}${cargarResultadoPedido(cartProvider)} para entregado el próximo día hábil.',
                                  style: TextStyle(
                                      color: ConstantesColores.rojo_letra,
                                      fontSize: size.width * 0.04,
                                      fontFamily: 'RoundedMplus1c'))
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          )
        : Container(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Container(
                //height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Center(
                  child: Row(
                    children: [
                      Container(
                        width: size.width * 0.1,
                        child: IconButton(
                          icon: SvgPicture.asset(
                              'assets/check_producto_agregado.svg'),
                          onPressed: () => {},
                        ),
                      ),
                      Container(
                        width: size.width * 0.75,
                        height: Get.height * 0.1,
                        padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                        child: Center(
                          child: Text(
                              'Tu pedido será entregado el siguiente día hábil.',
                              style: TextStyle(
                                  color: ConstantesColores.gris_oscuro,
                                  fontSize: size.width * 0.04,
                                  fontFamily: 'RoundedMplus1c')),
                        ),
                      ),
                    ],
                  ),
                )),
          );
  }

  Widget cargarValorPrecio(double? descuento, format) {
    if (descuento != 0) {
      return Column(children: [
        Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
          alignment: Alignment.topLeft,
          child: Text(
            '${format.currencySymbol}' +
                formatNumber
                    .format(widget.productos.preciodescuento)
                    .replaceAll(',00', ''),
            textAlign: TextAlign.left,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          alignment: Alignment.topLeft,
          child: Text(
              '${format.currencySymbol}' +
                  formatNumber
                      .format(widget.productos.precioinicial)
                      .replaceAll(',00', ''),
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: ConstantesColores.azul_precio,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  decoration: TextDecoration.lineThrough)),
        ),
      ]);
    } else {
      return Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        alignment: Alignment.topLeft,
        child: Text(
          '${format.currencySymbol}' +
              formatNumber
                  .format(widget.productos.precioinicial)
                  .replaceAll(',00', ''),
          textAlign: TextAlign.left,
          style: TextStyle(
              color: ConstantesColores.azul_precio,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
      );
    }
  }
}
