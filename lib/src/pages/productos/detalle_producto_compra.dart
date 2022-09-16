import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/modelos/productos.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/pages/productos/detalle_producto.dart';
import 'package:emart/src/pages/productos/ir_mi_carrito.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CambiarDetalleCompra extends StatefulWidget {
  @override
  State<CambiarDetalleCompra> createState() => _CambiarDetalleCompraState();
}

class _CambiarDetalleCompraState extends State<CambiarDetalleCompra> {
  final cargoConfirmar = Get.find<CambioEstadoProductos>();
  Productos? productos;

  @override
  void initState() {
    super.initState();
    productos = PedidoEmart.listaProductos![cargoConfirmar.dato.value.codigo]!;
    PedidoEmart.cambioVista.value = 1;
  }

  @override
  Widget build(BuildContext context) {
    productos = PedidoEmart.listaProductos![cargoConfirmar.dato.value.codigo]!;
    final cartProvider = Provider.of<CarroModelo>(context);
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: locale.toString());

    return Scaffold(
        backgroundColor: ConstantesColores.color_fondo_gris,
        extendBodyBehindAppBar: true,
        body: Obx(
          () => SingleChildScrollView(
            child: Column(
              children: [
                PedidoEmart.cambioVista.value == 1
                    ? Container(
                        height: Get.height * 0.8,
                        child: DetalleProducto(
                            productos: PedidoEmart.listaProductos![
                                cargoConfirmar.dato.value.codigo]!,
                            tamano: Get.height * 0.7))
                    : Container(
                        height: retornarTamanoPrincipal(cartProvider) * 1.1,
                        child: IrMiCarrito(
                            productos: PedidoEmart.listaProductos![
                                cargoConfirmar.dato.value.codigo]!,
                            tamano: retornarTamano(cartProvider) * 1.1),
                      ),
                Container(
                  margin: EdgeInsets.fromLTRB(10.0, 0, 10, 0),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Aprovecha estas ofertas',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: HexColor("#41398D"),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: Get.height * 0.45,
                        child: _cargarInformacionInferior(format, cartProvider),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  _cargarInformacionInferior(format, cartProvider) {
    return FutureBuilder(
        future: DBProvider.db.consultarSuguerido(),
        initialData: [],
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            scrollDirection: Axis.horizontal,
            children:
                _cargarDatos(context, snapshot.data, format, cartProvider),
          );
        });
  }

  List<Widget> _cargarDatos(BuildContext context, List<dynamic> listaProductos,
      format, cartProvider) {
    final List<Widget> opciones = [];

    if (listaProductos.length == 0) {
      return opciones..add(Text('No hay informacion para mostrar'));
    }

    listaProductos.forEach((element) {
      Productos productos = element;

      final template =
          _cargarDisenoInterno(context, productos, format, cartProvider);

      opciones.add(template);
    });

    return opciones;
  }

  _cargarDisenoInterno(
      BuildContext context, Productos productos, format, cartProvider) {
    return Container(
      width: 190,
      child: Card(
        shape: RoundedRectangleBorder(
            side: new BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8.0)),
        child:
            _cargarDisenoInternoDatos(context, productos, cartProvider, format),
      ),
    );
  }

  _cargarDisenoInternoDatos(BuildContext context, element,
      CarroModelo cartProvider, NumberFormat format) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => detalleProducto(element, cartProvider),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10.0),
            height: Get.height * 0.15,
            width: size.width * 0.3,
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
          Container(
            height: Get.height * 0.23,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: Get.height * 0.15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${element.nombre}',
                            maxLines: 4,
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
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                    child: Container(
                      height: Get.height * 0.05,
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
              height: 30,
              width: 140,
              alignment: Alignment.center,
              child: GestureDetector(
                child: Image.asset("assets/agregar_btn.png"),
                onTap: () => detalleProducto(element, cartProvider),
              )),
        ],
      ),
    );
  }

  detalleProducto(Productos element, CarroModelo cartProvider) {
    cargoConfirmar.cambiarValoresEditex(PedidoEmart.obtenerValor(element)!);
    cargoConfirmar.cargarProductoNuevo(
        ProductoCambiante.m(element.nombre, element.codigo), 2);
    cartProvider.guardarCambiodevista = 1;
    PedidoEmart.cambioVista.value = 1;
    setState(() {});
  }

  double retornarTamano(cartProvider) {
    double precioMinimo = 0;
    double valor = 0.7;

    for (int i = 0; i < PedidoEmart.listaFabricante!.length; i++) {
      if (PedidoEmart.listaFabricante![i].empresa == productos!.fabricante)
        precioMinimo = PedidoEmart.listaFabricante![i].pedidominimo;
    }

    try {
      if (cartProvider.getListaFabricante[productos!.fabricante]
                  ["precioFinal"] <
              precioMinimo &&
          productos!.fabricante!.toUpperCase() != 'MEALS') {
        valor = Get.height > 600 ? Get.height * 0.8 : Get.height * 0.8;
      } else {
        valor = productos!.fabricante!.toUpperCase() == 'MEALS'
            ? Get.height * 0.8
            : Get.height * 0.8;
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
      if (PedidoEmart.listaFabricante![i].empresa == productos!.fabricante)
        precioMinimo = PedidoEmart.listaFabricante![i].pedidominimo;
    }

    try {
      if (cartProvider.getListaFabricante[productos!.fabricante]
                  ["precioFinal"] <
              precioMinimo &&
          productos!.fabricante!.toUpperCase() != 'MEALS') {
        valor = Get.height > 600 ? Get.height * 0.75 : Get.height * 0.8;
      }
      if (Get.height > 600) {
        valor = productos!.fabricante!.toUpperCase() == 'MEALS'
            ? Get.height * 0.75
            : Get.height * 0.7;
      }
    } catch (e) {
      precioMinimo = 0;
      valor = Get.height > 750 ? 0.7 : 0.8;
    }

    return valor;
  }
}
