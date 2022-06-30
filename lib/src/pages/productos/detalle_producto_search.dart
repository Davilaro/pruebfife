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
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/widget/custom_card.dart';
import 'package:emart/src/widget/dialog_details_image.dart';
import 'package:emart/src/pages/productos/ir_mi_carrito.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:provider/provider.dart';

class DetalleProductoSearch extends StatefulWidget {
  final Productos producto;
  final double tamano;
  final String title;
  DetalleProductoSearch(
      {Key? key,
      required this.producto,
      required this.tamano,
      required this.title})
      : super(key: key);

  @override
  _DetalleProductoSearchState createState() => _DetalleProductoSearchState();
}

class _DetalleProductoSearchState extends State<DetalleProductoSearch> {
  NumberFormat formatNumber = new NumberFormat("#,##0.00", "es_AR");
  final TextEditingController _controllerCantidadProducto =
      TextEditingController();
  final TextEditingController _controllerBuscarProductoMarca =
      TextEditingController();
  bool isAgotado = false;

  final cargoConfirmar = Get.find<CambioEstadoProductos>();
  final constrollerProductos = Get.find<ControllerProductos>();

  @override
  void initState() {
    super.initState();
    isAgotado = constrollerProductos.validarAgotado(widget.producto);
    _controllerCantidadProducto.text =
        cargoConfirmar.controllerCantidadProducto.value;
    //FIREBASE: Llamamos el evento view_item
    TagueoFirebase().sendAnalityticViewItem(
        widget.producto, int.parse(_controllerCantidadProducto.text));

    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
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

    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      appBar: AppBar(
        title: Text(
          '',
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
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            child: CustomCard(
              padding: EdgeInsets.fromLTRB(30, 50, 20, 0),
              body: Column(
                children: [
                  //Titulo Detalle
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${widget.producto.nombre}',
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      style: diseno_valores(),
                    ),
                  ),
                  // Imagen detalle
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 40),
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
                                        '${widget.producto.codigo}.png',
                                    '${widget.producto.nombrecomercial}'));
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: PinchZoomImage(
                              zoomedBackgroundColor: Colors.transparent,
                              hideStatusBarWhileZooming: true,
                              image: CachedNetworkImage(
                                  imageUrl: Constantes().urlImgProductos +
                                      '${widget.producto.codigo}.png',
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
                  // Cuerpo
                  Container(
                    // padding: EdgeInsets.fromLTRB(30, 0, 20, 0),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          ' ${widget.producto.nombrecomercial}',
                          maxLines: 2,
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          'SKU: ${widget.producto.codigo}',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: HexColor("#a2a2a2")),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Visibility(
                                          visible:
                                              widget.producto.descuento != 0,
                                          child: Container(
                                            height: Get.width * 0.07,
                                            padding:
                                                EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              '${format.currencySymbol}' +
                                                  formatNumber
                                                      .format(widget
                                                          .producto.precio)
                                                      .replaceAll(',00', ''),
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.red),
                                            ),
                                          )),
                                      Container(
                                        height: widget.producto.descuento != 0
                                            ? Get.width * 0.05
                                            : Get.width * 0.07,
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          '${format.currencySymbol}' +
                                              formatNumber
                                                  .format(widget.producto
                                                              .descuento !=
                                                          0
                                                      ? widget.producto
                                                          .precioinicial
                                                      : widget.producto.precio)
                                                  .replaceAll(',00', ''),
                                          textAlign: TextAlign.left,
                                          style: widget.producto.descuento != 0
                                              ? TextStyle(
                                                  color: ConstantesColores
                                                      .azul_precio,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11,
                                                  decoration: TextDecoration
                                                      .lineThrough)
                                              : TextStyle(
                                                  color: ConstantesColores
                                                      .azul_precio,
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 55.0,
                              width: Get.width * 0.35,
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(
                                      height: 70.0,
                                      width: Get.width * 0.11,
                                      child: IconButton(
                                        icon: Image.asset('assets/menos.png'),
                                        onPressed: () => menos(
                                            widget.producto, cartProvider),
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
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            textAlign: TextAlign.center,
                                            maxLength: 3,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Escribe el precio de compra';
                                              }
                                              return null;
                                            },

                                            style:
                                                TextStyle(color: Colors.black),

                                            onChanged: (value) {
                                              /*setState(() {
                                                  if (value != "")
                                                    PedidoEmart.registrarValoresPedido(
                                                        widget.productos, value);
                                                  else
                                                    PedidoEmart.registrarValoresPedido(
                                                        widget.productos, "0");
                                                });*/

                                              cargoConfirmar
                                                  .cambiarValoresEditex(value);

                                              /*MetodosLLenarValores()
                                                    .calcularValorTotal(cartProvider);*/
                                            },
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              fillColor: Colors.black,
                                              hintText: '0',
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
                                      height: 70.0,
                                      width: Get.width * 0.11,
                                      child: IconButton(
                                        icon: Image.asset('assets/mas.png'),
                                        onPressed: () =>
                                            mas(widget.producto, cartProvider),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                            visible: isAgotado,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: isAgotado
                                    ? EdgeInsets.only(top: 5, bottom: 80)
                                    : EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.red[100],
                                ),
                                height: Get.width * 0.07,
                                // width: Get.height * 0.1,
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                // color: Colors.red[100],
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
                  Visibility(
                    visible: !isAgotado,
                    child: InkWell(
                      onTap: () {
                        llenarCarrito(widget.producto, cartProvider);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 40),
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
            ),
          ),
          Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: HexColor("#41398D")),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  mas(Productos producto, CarroModelo cartProvider) {
    String valorInicial = _controllerCantidadProducto.text;

    if (valorInicial.length < 3) {
      if (valorInicial == "") {
        //_controllerCantidadProducto.text = '1';

        cargoConfirmar.cambiarValoresEditex('1');
        setState(() {});
        //PedidoEmart.registrarValoresPedido(producto, '1');
      } else {
        int valoSuma = int.parse(valorInicial) + 1;
        setState(() {
          //_controllerCantidadProducto.text = '$valoSuma';
          cargoConfirmar.cambiarValoresEditex('$valoSuma');
          // PedidoEmart.registrarValoresPedido(producto, '$valoSuma');
        });
      }
    }

    //MetodosLLenarValores().calcularValorTotal(cartProvider);
  }

  menos(Productos producto, CarroModelo cartProvider) {
    String valorInicial = _controllerCantidadProducto.text;
    if (valorInicial != "" && valorInicial != '1' && valorInicial != '0') {
      int valorResta = int.parse(valorInicial) - 1;
      if (valorResta <= 0) {
        setState(() {
          //_controllerCantidadProducto.text = '0';
          cargoConfirmar.cambiarValoresEditex('0');
          // PedidoEmart.registrarValoresPedido(producto, '0');
        });
      } else {
        setState(() {
          //_controllerCantidadProducto.text = '$valorResta';
          cargoConfirmar.cambiarValoresEditex('$valorResta');
          //PedidoEmart.registrarValoresPedido(producto, '$valorResta');
        });
      }
    }

    // MetodosLLenarValores().calcularValorTotal(cartProvider);
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
          ProductoCambiante.m(widget.producto.nombre, widget.producto.codigo),
          2);
      cartProvider.guardarCambiodevista = 2;
      PedidoEmart.cambioVista.value = 2;
      //FIREBASE: Llamamos el evento add_to_cart
      TagueoFirebase().sendAnalityticAddToCart(
          producto, int.parse(_controllerCantidadProducto.text));

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => IrMiCarrito(
                  productos: widget.producto,
                  tamano: retornarTamano(cartProvider) * 1.5)));

      // Navigator.of(context).pop();
    }
  }

  double retornarTamano(cartProvider) {
    double precioMinimo = 0;
    double valor = 0.7;

    for (int i = 0; i < PedidoEmart.listaFabricante!.length; i++) {
      if (PedidoEmart.listaFabricante![i].empresa == widget.producto.fabricante)
        precioMinimo = PedidoEmart.listaFabricante![i].pedidominimo;
    }

    try {
      if (cartProvider.getListaFabricante[widget.producto.fabricante]
                  ["precioFinal"] <
              precioMinimo &&
          widget.producto.fabricante!.toUpperCase() != 'MEALS') {
        if (Get.height > 600) {
          valor = Get.height * 0.8;
        } else {
          valor = Get.height * 0.8;
        }
      } else {
        if (widget.producto.fabricante!.toUpperCase() == 'MEALS') {
          valor = Get.height * 0.8;
        } else {
          valor = Get.height * 0.8;
        }
      }
    } catch (e) {
      precioMinimo = 0;
      valor = Get.height > 750 ? 0.7 : 0.8;
    }

    return valor;
  }

  double retornarTamanoPrincipal(cartProvider) {
    double precioMinimo = 0;
    double valor = 0.6;

    for (int i = 0; i < PedidoEmart.listaFabricante!.length; i++) {
      if (PedidoEmart.listaFabricante![i].empresa == widget.producto.fabricante)
        precioMinimo = PedidoEmart.listaFabricante![i].pedidominimo;
    }

    try {
      if (cartProvider.getListaFabricante[widget.producto.fabricante]
                  ["precioFinal"] <
              precioMinimo &&
          widget.producto.fabricante!.toUpperCase() != 'MEALS') {
        if (Get.height > 600) {
          valor = Get.height * 0.75;
        } else {
          valor = Get.height * 0.8;
        }
      } else if (Get.height > 600) {
        if (widget.producto.fabricante!.toUpperCase() == 'MEALS') {
          valor = Get.height * 0.75;
        } else {
          valor = Get.height * 0.6;
        }
      }
    } catch (e) {
      precioMinimo = 0;
      valor = Get.height > 750 ? 0.7 : 0.8;
    }

    return valor;
  }

  TextStyle diseno_valores() => TextStyle(
      fontSize: 16.0, color: HexColor("#43398E"), fontWeight: FontWeight.bold);
  TextStyle diseno_valores_text() =>
      TextStyle(fontSize: 20.0, color: HexColor("#43398E"));
}
