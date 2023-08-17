// ignore_for_file: non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';
import 'package:emart/src/pages/carrito/carrito_compras.dart';
import 'package:emart/src/pages/principal_page/tab_opciones.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:emart/src/widget/imagen_notification.dart';
import 'package:emart/src/widget/titulo_pideky_carrito.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

final prefs = new Preferencias();

class IrMiCarrito extends StatefulWidget {
  final Producto productos;
  final double tamano;

  const IrMiCarrito({Key? key, required this.productos, required this.tamano})
      : super(key: key);

  @override
  State<IrMiCarrito> createState() => _IrMiCarritoState();
}

class _IrMiCarritoState extends State<IrMiCarrito> {
  ProductoViewModel productViewModel = Get.find();
  bool productoEncontrado = false;
  bool isRestrictivo = false;

  @override
  void initState() {
    super.initState();
    PedidoEmart.iniciarProductosPorFabricante();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CarroModelo>(context);

    final size = MediaQuery.of(context).size;

    try {
      if (cartProvider.getListaFabricante[widget.productos.fabricante] ==
          null) {
        productoEncontrado = false;
      } else {
        double precioMinimo = PedidoEmart.listaProductosPorFabricante![
                    widget.productos.fabricante]["preciominimo"] !=
                null
            ? PedidoEmart
                    .listaProductosPorFabricante![widget.productos.fabricante]
                ["preciominimo"]
            : 0.0;
        productoEncontrado = PedidoEmart.listaProductosPorFabricante!.length > 0
            ? cartProvider.getListaFabricante[widget.productos.fabricante]
                    ["precioFinal"] <
                precioMinimo
            : false;
      }
    } catch (e) {
      productoEncontrado = false;
      isRestrictivo = false;
    }

    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      appBar: AppBar(
        title: TituloPidekyCarrito(
          widget: TabOpciones(),
          size: size,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ConstantesColores.color_fondo_gris,
          statusBarIconBrightness: Brightness.dark,
        ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        actions: <Widget>[
          BotonActualizar(),
          AccionNotificacion(),
          AccionesBartCarrito(esCarrito: false),
        ],
      ),
      body: Container(
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
                                  Image.asset('assets/image/jar-loading.gif'),
                              errorWidget: (context, url, error) =>
                                  Image.asset('assets/image/logo_login.png'),
                              fit: BoxFit.contain),
                        ),
                        Container(
                          height: widget.tamano * 0.28,
                          width: Get.width * 0.4,
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
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
                                  child: Column(
                                    children: [
                                      cargarValorPrecio(
                                          widget.productos.descuento,
                                          productViewModel),
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
                              "assets/image/seguir_comprando_btn.png",
                            ),
                            onTap: () => {
                              Navigator.pop(context, true),
                            },
                          ),
                        )),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                      child: Container(
                        width: 240,
                        height: 50,
                        child: GestureDetector(
                          child: Image.asset(
                            "assets/image/ir_carrito_btn.png",
                          ),
                          onTap: () => pasarCarrito(),
                        ),
                      )),
                ],
              ),
            ),
            //MENSAJE DE PEDIDO MINIMO
            validarPedidoMinimo(size, cartProvider, productViewModel)
          ],
        ),
      ),
    );
  }

  validarPedidoMinimo(
      Size size, CarroModelo cartProvider, ProductoViewModel productViewModel) {
    var locale = Intl().locale;
    var format = locale.toString() != 'es_CO'
        ? locale.toString() == 'es_CR'
            ? NumberFormat.currency(locale: locale.toString(), symbol: '\₡')
            : NumberFormat.simpleCurrency(locale: locale.toString())
        : NumberFormat.currency(locale: locale.toString(), symbol: '\$');

    if (isRestrictivo) {
      return Container(
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
                        'assets/image/check_producto_agregado.svg'),
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
                        text: PedidoEmart.listaProductosPorFabricante![widget
                                    .productos.fabricante]["preciominimo"] ==
                                0
                            ? ""
                            : validarTextoInformativo(cartProvider),
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
          ));
    } else {
      return cargarWiguet(size, cartProvider, format);
    }
  }

  Future<void> pasarCarrito() async {
    final provider = Provider.of<OpcionesBard>(context, listen: false);
    //UXCam: Llamamos el evento clickCarrito
    UxcamTagueo().clickCarrito(provider, 'Inferior');
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
        ? productViewModel.getCurrency(precio.toInt())
        : "0";

    return valor;
  }

  int calcularDiasFaltantes(List<String> diasSemana, diasEspecificos,
      String diaActual, int diasEntrega) {
    // Obtener el índice del dia actual en la lista de días de la semana
    int indexDiaActual = diasSemana.indexOf(diaActual);

    // Inicializar el contador de dia faltantes
    int diasFaltantes = 1;

    // Recorrer la lista de días de la semana en orden para encontrar el proximo dia de visita
    for (int i = 1; i <= diasSemana.length; i++) {
      int indexSiguienteDia = (indexDiaActual + i) % diasSemana.length;
      String siguienteDia = diasSemana[indexSiguienteDia];

      if (diasEspecificos.contains(siguienteDia)) {
        break;
      } else {
        diasFaltantes++;
      }
    }

    return diasFaltantes + diasEntrega;
  }

  String validarTextoInformativo(CarroModelo cartProvider) {
    List<String> diasDeLaSemana = [
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado',
    ];
    late int diasFaltantes;
    late String textoReturn;
    var diasEntrega =
        PedidoEmart.listaProductosPorFabricante![widget.productos.fabricante]
            ['diasEntrega'];
    var diasVisita =
        PedidoEmart.listaProductosPorFabricante![widget.productos.fabricante]
            ['diasVisita'];
    bool frecuencia =
        PedidoEmart.listaProductosPorFabricante![widget.productos.fabricante]
            ['isFrecuencia'];
    int itinerario =
        PedidoEmart.listaProductosPorFabricante![widget.productos.fabricante]
            ['itinerario'];
    double precioMinimo =
        PedidoEmart.listaProductosPorFabricante![widget.productos.fabricante]
            ['preciominimo'];

    if (itinerario == 1) {
      if (frecuencia == false) {
        diasFaltantes = calcularDiasFaltantes(
            diasDeLaSemana, diasVisita, prefs.diaActual, diasEntrega);
        return textoReturn =
            "Recuerda que tu pedido debe ser superior a ${cargarResultadoPedido(cartProvider)} para ser entregado aproximadamente en $diasFaltantes ${diasFaltantes > 1 ? "días hábiles" : "día hábil"}.";
      } else if (frecuencia == true && precioMinimo == 0) {
        return textoReturn = "";
      }
    } else {
      if (frecuencia == false) {
        return textoReturn =
            "Recuerda que tu pedido debe ser superior a ${cargarResultadoPedido(cartProvider)} para ser entregado aproximadamente en 1 día hábil.";
      } else if (frecuencia == true && precioMinimo == 0) {
        return textoReturn = "";
      } else {
        return textoReturn =
            "Recuerda que tu pedido debe ser superior a ${cargarResultadoPedido(cartProvider)} para ser entregado aproximadamente en $diasEntrega ${diasEntrega > 1 ? "días hábiles" : "día hábil"}.";
      }
    }
    textoReturn = '';
    return textoReturn;
  }

  String cargarResultadoPedido(CarroModelo cartProvider) {
    double precio = 0;

    precio =
        PedidoEmart.listaProductosPorFabricante![widget.productos.fabricante]
            ["preciominimo"];
    return PedidoEmart.listaProductosPorFabricante!.length > 0
        ? productViewModel.getCurrency(precio.toInt())
        : "0";
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
    double valor = 0.0;
    print(
        "precio minimo ${PedidoEmart.listaProductosPorFabricante![widget.productos.fabricante]["preciominimo"]}");

    if (PedidoEmart.listaProductosPorFabricante!.length > 0) {
      double topeMinimo =
          PedidoEmart.listaProductosPorFabricante![widget.productos.fabricante]
                      ["topeMinimo"] !=
                  null
              ? PedidoEmart
                      .listaProductosPorFabricante![widget.productos.fabricante]
                  ["topeMinimo"]
              : 0.0;
      if (topeMinimo > 0) {
        valor = PedidoEmart
                    .listaProductosPorFabricante![widget.productos.fabricante]
                ["topeMinimo"] *
            1.19;
        double valorMinimo = cartProvider
            .getListaFabricante[widget.productos.fabricante]["precioFinal"];

        return valor > valorMinimo;
      } else {
        return PedidoEmart.listaProductosPorFabricante![
                        widget.productos.fabricante]["preciominimo"] !=
                    null &&
                PedidoEmart.listaProductosPorFabricante![
                        widget.productos.fabricante]["preciominimo"] !=
                    0
            ? true
            : false;
      }
    }
    return false;
  }

  Widget cargarWiguet(size, CarroModelo cartProvider, format) {
    return cargarResultadoPedidoCondicion(
      cartProvider,
    )
        ? Container(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: Center(
                  child: Row(
                    children: [
                      Container(
                        width: size.width * 0.1,
                        child: IconButton(
                          icon: SvgPicture.asset(
                              'assets/image/check_producto_agregado.svg'),
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
                                  text: validarTextoInformativo(cartProvider),
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
                              'assets/image/check_producto_agregado.svg'),
                          onPressed: () => {},
                        ),
                      ),
                      Container(
                        width: size.width * 0.75,
                        height: Get.height * 0.1,
                        padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                        child: Center(
                          child: Text('Has agregado un producto al carrito. ',
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

  Widget cargarValorPrecio(
      double? descuento, ProductoViewModel productViewModel) {
    if (descuento != 0) {
      return Column(children: [
        Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
          alignment: Alignment.topLeft,
          child: Text(
            productViewModel.getCurrency(widget.productos.preciodescuento),
            textAlign: TextAlign.left,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          alignment: Alignment.topLeft,
          child: Text(
              productViewModel.getCurrency(widget.productos.precioinicial),
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: ConstantesColores.azul_precio,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  decoration: TextDecoration.lineThrough)),
        ),
      ]);
    }
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      alignment: Alignment.topLeft,
      child: Text(
        productViewModel.getCurrency(widget.productos.precioinicial),
        textAlign: TextAlign.left,
        style: TextStyle(
            color: ConstantesColores.azul_precio,
            fontWeight: FontWeight.bold,
            fontSize: 18),
      ),
    );
  }
}
