import 'package:emart/_pideky/domain/product/use_cases/producto_use_cases.dart';
import 'package:emart/_pideky/infrastructure/product/product_service.dart';
import 'package:emart/_pideky/presentation/product/view/detalle_producto.dart';
import 'package:emart/_pideky/presentation/product/view/ir_mi_carrito.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/_pideky/domain/product/model/product_model.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/widget/card_product_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

final prefs = new Preferencias();

class CambiarDetalleCompra extends StatefulWidget {
  @override
  State<CambiarDetalleCompra> createState() => _CambiarDetalleCompraState();
}

class _CambiarDetalleCompraState extends State<CambiarDetalleCompra> {
  final cargoConfirmar = Get.find<CambioEstadoProductos>();
  Product? productos;
  final constrollerProductos = Get.find<ControllerProductos>();
  final productViewModel = Get.find<ProductViewModel>();

  @override
  void initState() {
    super.initState();
    //UXCAM: Se define el nombre de la interfaz
    FlutterUxcam.tagScreenName('ProductDetail');
    productos = PedidoEmart.listaProductos![cargoConfirmar.dato.value.codigo]!;
    PedidoEmart.cambioVista.value = 1;
  }

  @override
  Widget build(BuildContext context) {
    productos = PedidoEmart.listaProductos![cargoConfirmar.dato.value.codigo]!;
    final cartProvider = Provider.of<CartViewModel>(context);

    bool isFrecuencia = prefs.paisUsuario == 'CR'
        ? productViewModel.validarFrecuencia(productos!.fabricante.toString())
        : true;

    // bool isFrecuencia =
    //     productViewModel.validarFrecuencia(productos!.fabricante.toString());

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
                          tamano: Get.height * 0.7,
                          isFrecuencia: isFrecuencia,
                          isByBuySellEarn: false,
                        ))
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
                        'Imperdibles para tu negocio',
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
                        child: _cargarInformacionInferior(cartProvider),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  _cargarInformacionInferior(cartProvider) {
    ProductoService productService =
        ProductoService(ProductoRepositorySqlite());
    return FutureBuilder(
        future:
            productService.cargarProductosInterno(2, '', 0, 1000000, 0, "", ""),
        initialData: [],
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            scrollDirection: Axis.horizontal,
            children: _cargarDatos(context, snapshot.data, cartProvider),
          );
        });
  }

  List<Widget> _cargarDatos(
      BuildContext context, List<dynamic> listaProductos, cartProvider) {
    final List<Widget> opciones = [];

    if (listaProductos.length == 0) {
      return opciones..add(Text(S.current.no_information_to_display));
    }

    listaProductos.forEach((element) {
      Product producto = element;

      final template = Container(
          child: FittedBox(
              fit: BoxFit.scaleDown,
              child: FutureBuilder(
                  future: DBProvider.db
                      .consultarProductoEnOfertaPorCodigo(producto.codigo),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    bool isProductoEnOferta = false;
                    var dateNow = DateTime(DateTime.now().year,
                        DateTime.now().month, DateTime.now().day);
                    if (snapshot.data == producto.codigo) {
                      isProductoEnOferta = true;
                    } else {
                      isProductoEnOferta = false;
                    }
                    return CardProductCustom(
                        producto: producto,
                        cartProvider: cartProvider,
                        isProductoEnOferta: isProductoEnOferta,
                        onTapCard: () =>
                            detalleProducto(producto, cartProvider),
                        isAgotadoLabel:
                            constrollerProductos.validarAgotado(producto),
                        isVisibleLabelPromo: (producto.activopromocion == 1 &&
                            ((DateTime.parse(producto.fechafinpromocion_1!))
                                    .compareTo(dateNow) >=
                                0)),
                        isVisibleLabelNuevo: producto.fechafinnuevo_1!
                            .contains(RegExp(r'[0-9]')));
                  })));

      opciones.add(template);
    });

    return opciones;
  }

  detalleProducto(Product element, CartViewModel cartProvider) {
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
