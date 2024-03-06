import 'package:emart/_pideky/presentation/authentication/view/log_in/login_page.dart';
import 'package:emart/_pideky/presentation/buscador_general/view_model/search_fuzzy_view_model.dart';
import 'package:emart/_pideky/presentation/productos/view/detalle_producto_compra.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/card_product_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

final prefs = new Preferencias();

class InputValoresCatalogo extends StatefulWidget {
  final Producto element;
  final bool isCategoriaPromos;
  final int index;
  final bool search;

  InputValoresCatalogo(
      {Key? key,
      required this.element,
      required this.isCategoriaPromos,
      required this.index,
      required this.search})
      : super(key: key);

  @override
  State<InputValoresCatalogo> createState() => _InputValoresCatalogoState();
}

class _InputValoresCatalogoState extends State<InputValoresCatalogo> {
  final cargoConfirmar = Get.find<CambioEstadoProductos>();
  final constrollerProductos = Get.find<ControllerProductos>();
  final searchFuzzyViewModel = Get.find<SearchFuzzyViewModel>();
  bool isProductoEnOferta = false;
  RxBool isNewProduct = false.obs;
  RxBool isPromoProduct = false.obs;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CarroModelo>(context);

    return FittedBox(
      fit: BoxFit.contain,
      child: FutureBuilder(
        future: DBProvider.db
            .consultarProductoEnOfertaPorCodigo(widget.element.codigo),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == widget.element.codigo) {
            isProductoEnOferta = true;
          } else {
            isProductoEnOferta = false;
          }
          isNewProduct.value =
              widget.element.fechafinnuevo_1!.contains(RegExp(r'[0-9]'));
          isPromoProduct.value =
              (widget.element.fechafinpromocion_1!.contains(RegExp(r'[0-9]')) ||
                      widget.isCategoriaPromos) ||
                  isProductoEnOferta;

          bool isAgotado = constrollerProductos.validarAgotado(widget.element);
          return Obx(() => CardProductCustom(
              producto: widget.element,
              cartProvider: cartProvider,
              isProductoEnOferta: isProductoEnOferta,
              onTapCard: () async {
                if (prefs.usurioLogin != -1) {
                  if (searchFuzzyViewModel.controllerUser.text != '') {
                    searchFuzzyViewModel.llenarRecientes(
                        widget.element, Producto);
                  }
                  if (widget.search) {
                    await searchFuzzyViewModel
                        .insertarProductoBusqueda(widget.element.codigo);
                  }
                  //FIREBASE: Llamamos el evento select_item
                  TagueoFirebase().sendAnalityticSelectItem(widget.element, 1);
                  //UXCam: Llamamos el evento seeDetailProduct
                  UxcamTagueo().seeDetailProduct(widget.element, widget.index,
                      '', isAgotado, isNewProduct.value, isPromoProduct.value);
                }
                detalleProducto(widget.element, cartProvider);
              },
              isAgotadoLabel: isAgotado,
              isVisibleLabelPromo: isPromoProduct.value,
              isVisibleLabelNuevo: isNewProduct.value));
        },
      ),
    );
  }

  detalleProducto(Producto producto, CarroModelo cartProvider) async {
    if (prefs.usurioLogin == -1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LogInPage()));
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
          MaterialPageRoute(builder: (context) => CambiarDetalleCompra(cambioVista: 1,)));
    }
  }
}
