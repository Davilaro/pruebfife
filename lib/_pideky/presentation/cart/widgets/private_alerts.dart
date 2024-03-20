import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';

void dialogVaciarCarrito(String fabricante, CartViewModel cartProvider,
    List<dynamic> listProductos, precioMinimo, BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Advertencia'),
          content: Text('Está seguro de vaciar el carrito?'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.black),
                )),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  //UXCam: Llamamos el evento emptyToCart
                  UxcamTagueo().emptyToCart(
                      fabricante, cartProvider, listProductos, precioMinimo);
                  //FIREBASE: Llamamos el evento delete_cart
                  TagueoFirebase().sendAnalityticDeleteCart("2", "Delete");
                  cartProvider.vaciarProductosFabricante(
                      fabricante, cartProvider);
                },
                child: Text(
                  'Aceptar',
                  style: TextStyle(color: Colors.black),
                )),
          ],
        );
      });
}

showLoaderDialog(BuildContext context, size, Widget widget, double altura) {
  AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0))),
      content: Container(
          height: altura,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white,
          ),
          child: widget));
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
