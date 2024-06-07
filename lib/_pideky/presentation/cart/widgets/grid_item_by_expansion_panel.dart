import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/domain/product/model/product_model.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/_pideky/presentation/cart/widgets/private_alerts.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/shared/widgets/notification_of_maximum_promotion_limit.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/state_controller_radio_buttons.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/util.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

// WIDGET INTERIOR AL ACORDION EXPANDIBLE DE CADA FABRICANTE
List<Widget> gridItem(
  List<dynamic> value,
  String fabricante,
  BuildContext context,
  CartViewModel cartViewModel,
  precioMinimo,
  VoidCallback setState,
) {
  final controller = Get.put(StateControllerRadioButtons());
  final cargoConfirmar = Get.find<CambioEstadoProductos>();
  ProductViewModel productoViewModel = Get.find();
  List<Widget> result = [];
  List<Product> listTag = [];

  final size = MediaQuery.of(context).size;

  value.forEach((product) {
    cartViewModel.focusNodesMaps.putIfAbsent(product.codigo, () => FocusNode());
    Product productos = PedidoEmart.listaProductos![product.codigo]!;

    if (product.fabricante == fabricante && product.cantidad > 0) {
      bool showNotificationMaximumPromotionLimit =
          productViewModel.checkAndSetAlert(
              productos.cantidadMaxima!,
              toInt(PedidoEmart.listaControllersPedido![product.codigo]!.text),
              productos.cantidadSolicitada!);
      if (PedidoEmart.listaProductos![product.codigo]!.isOferta == 1 &&
          PedidoEmart.listaProductos![product.codigo]!.cantidadMaxima != 0) {
        productViewModel.fillProductListSentWithMax(
            PedidoEmart.listaProductos![product.codigo]!.codigo,
            toInt(PedidoEmart.listaControllersPedido![product.codigo]!.text),
            PedidoEmart.listaProductos![product.codigo]!.cantidadSolicitada!,
            PedidoEmart.listaProductos![product.codigo]!.cantidadMaxima!);
      } else {
        if (productViewModel.productListSentWithMax
                .containsKey(product.codigo) &&
            toInt(PedidoEmart.listaControllersPedido![product.codigo]!.text) !=
                0)
          productViewModel.deleteProductListSentWithMax(product.codigo);
      }
      listTag.add(productos);
      result
        ..add(Padding(
          padding: EdgeInsets.only(bottom: 10, left: 22, right: 22),
          child: Column(
            children: [
              Divider(
                color: ConstantesColores.gris_sku,
              ),
              Container(
                //   color: Colors.amber,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: CachedNetworkImage(
                                  height: size.height * 0.06,
                                  imageUrl: Constantes().urlImgProductos +
                                      '${product.codigo}.png',
                                  placeholder: (context, url) => Image.asset(
                                      'assets/image/jar-loading.gif'),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'assets/image/logo_login.png',
                                    width: size.width * 0.195,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Container(
                              // color: Colors.red,
                              padding: EdgeInsets.only(left: 5.0),
                              width: size.width / 1.5,
                              child: GestureDetector(
                                onTap: () => {
                                  cargoConfirmar.cambiarValoresEditex(
                                      PedidoEmart.obtenerValor(productos)!),
                                  cargoConfirmar.cargarProductoNuevo(
                                      ProductoCambiante.m(
                                          productos.nombre, productos.codigo),
                                      1),
                                  PedidoEmart.cambioVista.value = 1,
                                  cartViewModel.guardarCambiodevista = 1,
                                  Navigator.popAndPushNamed(
                                      context, 'detalle_compra_producto'),
                                },
                                child: Text(
                                  product.nombre,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: ConstantesColores
                                          .azul_aguamarina_botones,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: size.width * 0.2,
                                margin: EdgeInsets.only(left: 10.0),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    productoViewModel.getCurrency(
                                        product.productos.descuento != 0
                                            ? (toInt(PedidoEmart
                                                    .listaControllersPedido![
                                                        product.codigo]!
                                                    .text) *
                                                product.productos.precio)
                                            : (toInt(PedidoEmart
                                                    .listaControllersPedido![
                                                        product.codigo]!
                                                    .text) *
                                                product.productos
                                                    .preciodescuento)),
                                    style: TextStyle(
                                        color: product.productos.descuento != 0
                                            ? ConstantesColores.rojo_letra
                                            : ConstantesColores.azul_precio,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: product.productos.descuento != 0,
                                child: Container(
                                  margin: EdgeInsets.only(left: 10.0),
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: Text(
                                      productoViewModel.getCurrency(
                                          product.productos.descuento != 0
                                              ? (toInt(PedidoEmart
                                                      .listaControllersPedido![
                                                          product.codigo]!
                                                      .text) *
                                                  product
                                                      .productos.precioinicial)
                                              : (toInt(PedidoEmart
                                                      .listaControllersPedido![
                                                          product.codigo]!
                                                      .text) *
                                                  product.productos
                                                      .preciodescuento)),
                                      style: TextStyle(
                                          color: ConstantesColores.gris_textos,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 120),

                              //CONTROL PARA MANEJAR CANTIDADES DE LOS PRODUCTOS
                              Container(
                                width: size.width / 3.5,
                                height: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ConstantesColores.azul_precio,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      height: 30.0,
                                      width: 30.0,
                                      child: IconButton(
                                        padding: EdgeInsets.all(0),
                                        icon: PedidoEmart
                                                    .listaControllersPedido![
                                                        product.codigo]!
                                                    .text !=
                                                '1'
                                            ? Icon(
                                                Icons.remove,
                                                color:
                                                    ConstantesColores.gris_sku,
                                              )
                                            : Icon(
                                                Icons.delete_outline,
                                                color:
                                                    ConstantesColores.gris_sku,
                                              ),
                                        onPressed: () => {
                                          cartViewModel.menos(
                                            product.productos,
                                            fabricante,
                                            precioMinimo,
                                            setState,
                                            cartViewModel,
                                            context,
                                          ),
                                          productoViewModel
                                                  .seeAlertMaximumPromotionLimit
                                                  .value =
                                              showNotificationMaximumPromotionLimit,
                                        },
                                      ),
                                    ),
                                    Container(
                                      width: 30,
                                      child: TextFormField(
                                        focusNode: cartViewModel
                                            .focusNodesMaps[product.codigo],
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        maxLines: 1,
                                        controller:
                                            PedidoEmart.listaControllersPedido![
                                                product.codigo],
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        maxLength: 3,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:
                                                ConstantesColores.azul_precio,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                        onChanged: (value) {
                                          cartViewModel.editarCantidad(product,
                                              cartViewModel, value, setState);
                                        },
                                        decoration: InputDecoration(
                                          fillColor:
                                              ConstantesColores.azul_precio,
                                          border: InputBorder.none,
                                          hintText: '',
                                          counterText: "",
                                          hintStyle: TextStyle(
                                            color:
                                                ConstantesColores.azul_precio,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                      child:
                                          showNotificationMaximumPromotionLimit
                                              ? IconButton(
                                                  icon: Icon(
                                                    Icons.lock_outline_sharp,
                                                    color: ConstantesColores
                                                        .gris_sku,
                                                  ),
                                                  onPressed: () async {
                                                    if (Get.isSnackbarOpen) {
                                                      await Get
                                                          .closeCurrentSnackbar();
                                                      notificationMaximumPromotionlimit();
                                                    } else {
                                                      notificationMaximumPromotionlimit();
                                                    }
                                                  })
                                              : IconButton(
                                                  padding: EdgeInsets.zero,
                                                  icon: Icon(
                                                    Icons.add,
                                                    color: ConstantesColores
                                                        .azul_aguamarina_botones,
                                                  ),
                                                  onPressed: () {
                                                    cartViewModel.mas(
                                                        product.productos,
                                                        cartViewModel,
                                                        setState);
                                                    productoViewModel
                                                            .seeAlertMaximumPromotionLimit
                                                            .value =
                                                        showNotificationMaximumPromotionLimit;
                                                  },
                                                ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
    }
  });

  result.add(Container(
    child: Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, top: 8.5, bottom: 15),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Visibility(
              visible:
                  !cartViewModel.isSavedBymanufacturerOpenToShowTrashBox.value,
              child: InkWell(
                onTap: () {
                  controller.cashPayment.value = false;
                  controller.payOnLine.value = false;
                  dialogVaciarCarrito(
                      fabricante, cartViewModel, value, precioMinimo, context);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: HexColor("#42B39C"),
                    ),
                    Text(
                      "Vaciar carrito",
                      style: TextStyle(
                          color: HexColor("#42B39C"),
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: cartViewModel.getListaFabricante[fabricante]
                          ["descuento"] ==
                      0.0
                  ? false
                  : true,
              child: Obx(
                () => GestureDetector(
                  onTap: () async {
                    if (!cartViewModel.isTimerActive.value)
                      cartViewModel.animateSquare();
                  },
                  child: AnimatedContainer(
                    width: cartViewModel.widthSaveSquare.value,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: cartViewModel.isSavedBymanufacturerOpen.value
                          ? ConstantesColores.azul_precio
                          : ConstantesColores.azul_aguamarina_botones,
                    ),
                    duration: Duration(milliseconds: 200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: !cartViewModel
                                  .isSavedBymanufacturerOpenToShowTrashBox.value
                              ? ImageIcon(
                                  AssetImage(
                                      'assets/icon/Icono_valor_ahorrado.png'),
                                  color: Colors.white,
                                )
                              : Container(
                                  margin: EdgeInsets.only(right: 15.0, left: 5),
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      color: ConstantesColores
                                          .azul_aguamarina_botones,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: ImageIcon(
                                    AssetImage(
                                        'assets/icon/Icono_valor_ahorrado.png'),
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                        Visibility(
                            visible:
                                cartViewModel.isSavedBymanufacturerOpen.value,
                            child: Expanded(
                              flex: 2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getCurrency(cartViewModel
                                              .getListaFabricante[fabricante]
                                          ["descuento"]),
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      S.current.value_saved_cart,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  ));

  // //FIREBASE: Llamamos el evento view_cart
  // TagueoFirebase()
  //     .sendAnalityticViewCart(cartViewModel, listTag, 'CarritoCompras');
  return result;
}
