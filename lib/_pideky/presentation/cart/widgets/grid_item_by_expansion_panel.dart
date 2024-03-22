import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/domain/product/model/product_model.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/_pideky/presentation/cart/widgets/private_alerts.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/state_controller_radio_buttons.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

// WIDGET INTERIOR AL ACORDION EXPANDIBLE DE CADA FABRICANTE
List<Widget> gridItem(
    List<dynamic> value,
    String fabricante,
    BuildContext context,
    CartViewModel cartViewModel,
    precioMinimo,
    VoidCallback setState) {
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            SizedBox(
                              width: Get.width * 0.02,
                            ),
                            Container(
                              width: size.width / 3,
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
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: ConstantesColores.gris_textos,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
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
                                                product
                                                    .productos.preciodescuento)),
                                    style: TextStyle(
                                        color: product.productos.descuento != 0
                                            ? ConstantesColores.rojo_letra
                                            : ConstantesColores.azul_precio,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
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
                                                  product.productos.precio)
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
                                          decoration: TextDecoration.lineThrough),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: size.width / 3.5,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: ConstantesColores.azul_precio, width: 2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      color: ConstantesColores.gris_sku,
                                    )
                                  : Icon(
                                      Icons.delete_outline,
                                      color: ConstantesColores.gris_sku,
                                    ),
                              onPressed: () => {
                                cartViewModel.menos(
                                    product.productos,
                                    fabricante,
                                    precioMinimo,
                                    setState,
                                    cartViewModel,
                                    context),
                              },
                            ),
                          ),
                          Container(
                            width: 30,
                            child: ConstrainedBox(
                              constraints: new BoxConstraints(
                                minWidth: 20,
                                maxWidth: 100,
                                minHeight: 10,
                                maxHeight: 70.0,
                              ),
                              child: TextFormField(
                                focusNode: cartViewModel
                                    .focusNodesMaps[product.codigo],
                                textAlignVertical: TextAlignVertical.center,
                                maxLines: 1,
                                controller: PedidoEmart
                                    .listaControllersPedido![product.codigo],
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                maxLength: 3,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ConstantesColores.azul_precio,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                                onChanged: (value) {
                                  cartViewModel.editarCantidad(
                                      product, cartViewModel, value, setState);
                                },
                                decoration: InputDecoration(
                                  fillColor: ConstantesColores.azul_precio,
                                  border: InputBorder.none,
                                  hintText: '',
                                  counterText: "",
                                  hintStyle: TextStyle(
                                    color: ConstantesColores.azul_precio,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                            width: 30.0,
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(
                                Icons.add,
                                color:
                                    ConstantesColores.azul_aguamarina_botones,
                              ),
                              onPressed: () => cartViewModel.mas(
                                  product.productos, cartViewModel, setState),
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
        ));
    }
  });

  result.add(Padding(
    padding: const EdgeInsets.only(left: 18, right: 18, top: 8.5, bottom: 15),
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
          )
        ],
      ),
    ),
  ));

  // //FIREBASE: Llamamos el evento view_cart
  // TagueoFirebase()
  //     .sendAnalityticViewCart(cartViewModel, listTag, 'CarritoCompras');
  return result;
}
