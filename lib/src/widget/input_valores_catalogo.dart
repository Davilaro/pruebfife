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
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

NumberFormat formatNumber = new NumberFormat("#,##0.00", "es_AR");

final prefs = new Preferencias();

class InputValoresCatalogo extends StatefulWidget {
  final Productos element;
  final String numEmpresa;
  final bool isCategoriaPromos;

  InputValoresCatalogo(
      {Key? key,
      required this.element,
      required this.numEmpresa,
      required this.isCategoriaPromos})
      : super(key: key);

  @override
  State<InputValoresCatalogo> createState() => _InputValoresCatalogoState();
}

class _InputValoresCatalogoState extends State<InputValoresCatalogo> {
  final cargoConfirmar = Get.find<CambioEstadoProductos>();
  final constrollerProductos = Get.find<ControllerProductos>();

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CarroModelo>(context);
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: locale.toString());

    return Card(
      shape: RoundedRectangleBorder(
          side: new BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(8.0)),
      child:
          _cargarDisenoInterno(widget.element, context, cartProvider, format),
    );
  }

  _cargarDisenoInterno(
      element, BuildContext context, CarroModelo cartProvider, format) {
    Productos productos = element;
    bool isAgotado = constrollerProductos.validarAgotado(productos);

    return GestureDetector(
        onTap: () {
          //FIREBASE: Llamamos el evento select_item
          TagueoFirebase().sendAnalityticSelectItem(productos, 1);
          detalleProducto(productos, cartProvider);
        },
        child: Container(
          margin: EdgeInsets.only(left: 2, right: 2),
          child: Column(
            children: [
              Column(children: [
                OverflowBar(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Visibility(
                        visible: element.descuento != 0 ||
                            widget.isCategoriaPromos == true,
                        child: Container(
                          //aqui debo cambiar el logo de precios especiales por promo e imp0lementar productos nuevos
                          child: Image.asset(
                            'assets/promo_abel.png',
                            height: Get.height * 0.06,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      //aqui debo validar que sea producto nuevo
                      child: Visibility(
                        visible: element.descuento != 0,
                        child: Container(
                          child: Image.asset(
                            'assets/nuevos_label.png',
                            // width: Get.width * 0.3,
                            height: Get.height * 0.06,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: Get.width * 0.24,
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 5.0, left: 10, right: 10),
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      imageUrl: Constantes().urlImgProductos +
                          '${element.codigo}.png',
                      placeholder: (context, url) =>
                          Image.asset('assets/jar-loading.gif'),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/logo_login.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ]),
              Container(
                height:
                    element.descuento == 0 ? Get.width * 0.2 : Get.width * 0.15,
                alignment: Alignment.topLeft,
                padding: EdgeInsets.only(top: 2.0, left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${element.nombre}',
                      maxLines: element.descuento == 0 ? 3 : 2,
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
              Container(
                height: Get.height * 0.05,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Visibility(
                        visible: element.descuento != 0,
                        child: Container(
                          height: Get.width * 0.07,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                      height: element.descuento != 0
                          ? Get.width * 0.05
                          : Get.width * 0.07,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        '${format.currencySymbol}' +
                            formatNumber
                                .format(element.descuento != 0
                                    ? element.precioinicial
                                    : element.precio)
                                .replaceAll(',00', ''),
                        textAlign: TextAlign.left,
                        style: element.descuento != 0
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
                    Visibility(
                        visible: isAgotado,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 10, bottom: 3),
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
                  ],
                ),
              ),
              Visibility(
                visible: !isAgotado,
                child: Container(
                    height: Get.width * 0.1,
                    width: 150,
                    alignment: Alignment.center,
                    child: GestureDetector(
                        child: Image.asset("assets/agregar_btn.png"),
                        onTap: () => {
                              //FIREBASE: Llamamos el evento select_item
                              TagueoFirebase()
                                  .sendAnalityticSelectItem(productos, 1),
                              detalleProducto(productos, cartProvider)
                            })),
              ),
            ],
          ),
        ));
  }

  detalleProducto(Productos producto, CarroModelo cartProvider) async {
    if (prefs.usurioLogin == -1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      PedidoEmart.inicializarValoresFabricante();
      cartProvider.actualizarListaFabricante =
          PedidoEmart.listaPrecioPorFabricante!;
      cargoConfirmar.cambiarValoresEditex(PedidoEmart.obtenerValor(producto)!);
      cargoConfirmar.cargarProductoNuevo(
          ProductoCambiante.m(producto.nombre, producto.codigo), 2);
      cartProvider.guardarCambiodevista = 1;
      PedidoEmart.cambioVista.value = 1;

      var resul = await Navigator.push(context,
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

    calcularValorTotal(cartProvider);
  }

  menos(Productos producto, CarroModelo cartProvider) {
    String valorInicial = PedidoEmart.obtenerValor(producto)!;

    if (valorInicial == "") {
    } else {
      int valorResta = int.parse(valorInicial) - 1;

      if (valorResta <= 0) {
        setState(() {
          PedidoEmart.listaControllersPedido![producto.codigo]!.text = "1";
          PedidoEmart.registrarValoresPedido(producto, '1', false);
        });
      } else {
        setState(() {
          PedidoEmart.listaControllersPedido![producto.codigo]!.text =
              "$valorResta";
          PedidoEmart.registrarValoresPedido(producto, '$valorResta', true);
        });
      }
    }
    calcularValorTotal(cartProvider);
  }

  void calcularValorTotal(CarroModelo cartProvider) {
    double valorTotal = 0;
    double valorAhorro = 0;
    int cantidad = 0;

    PedidoEmart.listaValoresPedido!.forEach((key, value) {
      if (value != "0") {
        if (PedidoEmart.listaValoresPedidoAgregados![key] == true) {
          double precio = PedidoEmart.listaProductos![key]!.precio;
          valorTotal = valorTotal + precio * int.parse(value);
          valorAhorro = valorAhorro +
              PedidoEmart.listaProductos![key]!.precio * int.parse(value);
          cantidad++;
        }
      } else
        cantidad == 0 ? cantidad = 0 : cantidad--;
    });

    cartProvider.actualizarItems = 0;
    cartProvider.guardarValorCompra = valorTotal;
    cartProvider.guardarValorAhorro = valorAhorro;

    //PedidoEmart.inicializarValoresFabricante();
    PedidoEmart.calcularPrecioPorFabricante();
    cartProvider.actualizarListaFabricante =
        PedidoEmart.listaPrecioPorFabricante!;
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
