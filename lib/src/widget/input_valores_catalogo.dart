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

NumberFormat formatNumber = new NumberFormat("#,##0.00", "es_AR");

final prefs = new Preferencias();

class InputValoresCatalogo extends StatefulWidget {
  final Producto element;
  final String numEmpresa;
  final bool isCategoriaPromos;
  final int index;

  InputValoresCatalogo(
      {Key? key,
      required this.element,
      required this.numEmpresa,
      required this.isCategoriaPromos,
      required this.index})
      : super(key: key);

  @override
  State<InputValoresCatalogo> createState() => _InputValoresCatalogoState();
}

class _InputValoresCatalogoState extends State<InputValoresCatalogo> {
  final cargoConfirmar = Get.find<CambioEstadoProductos>();
  final constrollerProductos = Get.find<ControllerProductos>();
  bool isProductoEnOferta = false;
  RxBool isProductoNuevo = false.obs;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CarroModelo>(context);

    return FittedBox(
      fit: BoxFit.fill,
      child: FutureBuilder(
        future: DBProvider.db
            .consultarProductoEnOfertaPorCodigo(widget.element.codigo),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          bool isNewProduct =
              widget.element.fechafinnuevo_1!.contains(RegExp(r'[0-9]'));
          bool isPromoProduct =
              (widget.element.fechafinpromocion_1!.contains(RegExp(r'[0-9]')) ||
                      widget.isCategoriaPromos) ||
                  isProductoEnOferta;
          if (snapshot.data == widget.element.codigo) {
            isProductoEnOferta = true;
          } else {
            isProductoEnOferta = false;
          }
          bool isAgotado = constrollerProductos.validarAgotado(widget.element);
          return CardProductCustom(
              producto: widget.element,
              cartProvider: cartProvider,
              isProductoEnOferta: isProductoEnOferta,
              onTapCard: () {
                if (prefs.usurioLogin != -1) {
                  //FIREBASE: Llamamos el evento select_item
                  TagueoFirebase().sendAnalityticSelectItem(widget.element, 1);
                  //UXCam: Llamamos el evento seeDetailProduct
                  UxcamTagueo().seeDetailProduct(widget.element, widget.index,
                      '', isAgotado, isNewProduct, isPromoProduct);
                }
                detalleProducto(widget.element, cartProvider);
              },
              isAgotadoLabel: isAgotado,
              isVisibleLabelPromo: isPromoProduct,
              isVisibleLabelNuevo: isNewProduct);
        },
      ),
    );
  }

  detalleProducto(Producto producto, CarroModelo cartProvider) async {
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

      await Navigator.push(context,
          MaterialPageRoute(builder: (context) => CambiarDetalleCompra()));
    }
  }
}
