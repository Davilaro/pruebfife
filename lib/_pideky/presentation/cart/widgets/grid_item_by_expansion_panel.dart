import 'package:emart/_pideky/domain/product/model/product_model.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/_pideky/presentation/cart/widgets/private_alerts.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/shared/widgets/image_button.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/state_controller_radio_buttons.dart';
import 'package:emart/src/modelos/fabricante.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/util.dart';
import 'package:emart/src/widget/simple_card_condiciones_entrega.dart';
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
    VoidCallback setState) {
  final controller = Get.put(StateControllerRadioButtons());
  final cargoConfirmar = Get.find<CambioEstadoProductos>();
  ProductViewModel productoViewModel = Get.find();
  List<Widget> result = [];
  List<Product> listTag = [];

  final size = MediaQuery.of(context).size;

  value.forEach((product) {
    Product productos = PedidoEmart.listaProductos![product.codigo]!;

    if (product.fabricante == fabricante && product.cantidad > 0) {
      listTag.add(productos);
      result
        ..add(Padding(
          padding: EdgeInsets.only(bottom: 10, left: 22, right: 22),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: size.width / 4,
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
                      style: TextStyle(color: ConstantesColores.verde),
                    ),
                  ),
                ),
                Container(
                  width: size.width / 3,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 40.0,
                        width: 40.0,
                        child: IconButton(
                          icon: Image.asset('assets/image/menos.png'),
                          onPressed: () => {
                            cartViewModel.menos(product.productos, fabricante,
                                precioMinimo, setState, cartViewModel),
                          },
                        ),
                      ),
                      Container(
                        width: 40,
                        alignment: Alignment.center,
                        child: ConstrainedBox(
                          constraints: new BoxConstraints(
                            minWidth: 20,
                            maxWidth: 100,
                            minHeight: 10,
                            maxHeight: 70.0,
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            reverse: true,
                            child: TextFormField(
                              maxLines: 1,
                              controller: PedidoEmart
                                  .listaControllersPedido![product.codigo],
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              maxLength: 3,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                              onChanged: (value) =>
                                  cartViewModel.editarCantidad(
                                      product, cartViewModel, value, setState),
                              decoration: InputDecoration(
                                fillColor: Colors.black,
                                hintText: '0',
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
                        height: 40.0,
                        width: 40.0,
                        child: IconButton(
                          icon: Image.asset('assets/image/mas.png'),
                          onPressed: () => cartViewModel.mas(
                              product.productos, cartViewModel, setState),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Text(
                      productoViewModel
                          .getCurrency(product.productos.descuento != 0
                              ? (toInt(PedidoEmart
                                      .listaControllersPedido![product.codigo]!
                                      .text) *
                                  product.productos.precio)
                              : (toInt(PedidoEmart
                                      .listaControllersPedido![product.codigo]!
                                      .text) *
                                  product.productos.preciodescuento)),
                      style: cartViewModel.valuesDesing(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
    }
  });

  result.add(Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8.5),
    child: InkWell(
      onTap: () {
        controller.cashPayment.value = false;
        controller.payOnLine.value = false;
        dialogVaciarCarrito(fabricante, cartViewModel, value, precioMinimo, context);
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

  result
    ..add(Stack(
      children: [
        Container(
          height: 100,
          color: ConstantesColores.azul_precio,
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
        ),
        Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageButton(
                children: <Widget>[],
                width: 250,
                height: 35,
                paddingTop: 5,
                pressedImage: Image.asset(
                  "assets/image/seguir_comprando_btn_detalle-white.png",
                ),
                unpressedImage: Image.asset(
                    "assets/image/seguir_comprando_btn_detalle-white.png"),
                onTap: () async {
                  PedidoEmart.cambioVista.value = 1;
                  cartViewModel.guardarCambiodevista = 1;
                  Navigator.pop(context);
                  List<Fabricante> fabricanteSeleccionado =
                      await DBProvider.db.consultarFricante(fabricante);

                  cartProvider.onClickCatalogo(
                      fabricanteSeleccionado[0].empresa!,
                      context,
                      cartViewModel,
                      fabricanteSeleccionado[0].nombrecomercial!,
                      fabricanteSeleccionado[0].icono!);
                },
              ),
            ],
          ),
        ),
      ],
    ));

  //FIREBASE: Llamamos el evento view_cart
  TagueoFirebase()
      .sendAnalityticViewCart(cartViewModel, listTag, 'CarritoCompras');
  return result;
}
