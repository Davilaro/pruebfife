import 'dart:math';

import 'package:emart/_pideky/presentation/cart/view/order_notification_page.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/_pideky/presentation/cart/view_model/configure_order_view_model.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/state_controller_radio_buttons.dart';
import 'package:emart/src/modelos/pedido.dart';
import 'package:emart/src/modelos/validar_pedido.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/provider/servicios.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:emart/src/widget/pedido_realizado.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

final prefs = new Preferencias();
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

dialogEnviarPedido(size, context, context2) async {
  final cartProvider = Provider.of<CartViewModel>(context, listen: false);
  final List<Pedido> listaProductosPedidos = [];
  final List<String> listaSkuProductos = [];
  final progress = ProgressDialog(context, isDismissible: false);

  progress.style(
      message: 'Validando pedido...',
      progressWidget: Image(
        image: AssetImage('assets/image/jar-loading.gif'),
        fit: BoxFit.cover,
        height: 20,
      ));

  PedidoEmart.listaValoresPedido!.forEach((key, value) {
    if (value == "") {
    } else if (int.parse(value) > 0) {
      String directo = "";

      for (var i = 0; i < PedidoEmart.listaFabricante!.length; i++) {
        if (PedidoEmart.listaFabricante![i].empresa ==
            PedidoEmart.listaProductos![key]!.fabricante) {
          directo = PedidoEmart.listaFabricante![i].tipofabricante;
        }
      }

      Pedido pedidoNuevo = new Pedido(
          cantidad: int.parse(value),
          precioBase: PedidoEmart.listaProductos![key]!.precioBase,
          isOferta: PedidoEmart.listaProductos![key]!.isOferta,
          codigoProducto: key,
          iva: PedidoEmart.listaProductos![key]!.iva,
          precio: PedidoEmart.listaProductos![key]!.precio,
          fabricante: PedidoEmart.listaProductos![key]!.fabricante,
          codigoFabricante: PedidoEmart.listaProductos![key]!.codigoFabricante,
          nitFabricante: PedidoEmart.listaProductos![key]!.nitFabricante,
          codCliente: prefs.codCliente,
          tipoFabricante: directo,
          codProveedor: 1,
          precioDescuento: PedidoEmart.listaProductos![key]!.precioConDescuento,
          codigocliente: PedidoEmart.listaProductos![key]!.codigocliente,
          nombreProducto: PedidoEmart.listaProductos![key]!.nombre,
          precioInicial: PedidoEmart.listaProductos![key]!.precioinicial,
          descuento: PedidoEmart.listaProductos![key]!.descuento,
          isFrecuencia: cartProvider.getFrecuenciaFabricante[
                      PedidoEmart.listaProductos![key]!.fabricante] ==
                  true
              ? 0
              : 1);

      if (PedidoEmart.listaValoresPedidoAgregados![key] == true) {
        listaProductosPedidos.add(pedidoNuevo);
        listaSkuProductos.add(key);
      }
    }
  });
  print('topes ${productViewModel.productListSentWithMax}');
  await progress.show();
  final responseDuplicateOrder = await Servicies()
      .duplicateOrder(listaSkuProductos, cartProvider.getTotal);
  await progress.hide();
  if (responseDuplicateOrder == '1') {
    await progress.show();
    mostrarAlertOrderDuplicate(
        context,
        Text(
          ' Hoy realizaste un pedido con el mismo valor y productos similares ¿Estas seguro?',
          textAlign: TextAlign.center,
        ),
        null,
        Icon(Icons.close, color: Colors.red),
        size,
        listaProductosPedidos,
        progress,
        context2);
  } else {
    showLoaderDialog(context, size, cargandoPedido(context, size), 300);
    await dialogPedidoRegistrado(
        listaProductosPedidos, size, context, context2);
  }
}

void mostrarAlertOrderDuplicate(
    BuildContext context,
    Widget mensaje,
    Widget? icon,
    Widget? iconClose,
    size,
    listaProductosPedidos,
    progress,
    context2) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            content: Container(
              constraints: BoxConstraints(
                  minHeight: 200, minWidth: double.infinity, maxHeight: 350),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Visibility(
                      visible: iconClose == null ? false : true,
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await progress.hide();
                                Get.back();
                              },
                              child: Icon(
                                Icons.cancel,
                                color: ConstantesColores.verde,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      child: icon != null
                          ? icon
                          : Image.asset(
                              'assets/image/alerta_img.png',
                            ),
                    ),
                    Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: mensaje),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: GestureDetector(
                        onTap: () async {
                          Get.back();
                          showLoaderDialog(context, size,
                              cargandoPedido(context, size), 300);
                          await dialogPedidoRegistrado(
                              listaProductosPedidos, size, context, context2);
                        },
                        child: Container(
                          height: 40,
                          width: double.infinity,
                          child: Image.asset(
                            "assets/image/btn_aceptar.png",
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

dialogPedidoRegistrado(listaProductosPedidos, size, context, context2) async {
  final controladorCambioEstadoProductos = Get.find<CambioEstadoProductos>();
  final configureOrderViewModel = Get.find<ConfigureOrderViewModel>();
  final productoViewModel = Get.find<ProductViewModel>();
  final controller = Get.find<StateControllerRadioButtons>();
  final cartProvider = Provider.of<CartViewModel>(context, listen: false);
  DateTime now = DateTime.now();
  String fechaPedido = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  var numeroAleatorio = Random();
  String numDoc = DateFormat('yyyyMMddHHmmssSSS').format(now);
  numDoc += numeroAleatorio.nextInt(1000 - 1).toString();

  ValidarPedido validar = await configureOrderViewModel.cartUseCases.sendOrder(
      listaProductosPedidos,
      prefs.codClienteLogueado,
      fechaPedido,
      numDoc,
      cartProvider);

  if (validar.estado == 'OK') {
    PedidoEmart.listaValoresPedido!.forEach((key, value) {
      PedidoEmart
          .listaControllersPedido![PedidoEmart.listaProductos![key]!.codigo]!
          .text = "0";
      PedidoEmart.registrarValoresPedido(
          PedidoEmart.listaProductos![key]!, "1", false);
    });

    //FIREBASE: Llamamos el evento purchase
    TagueoFirebase().sendAnalityticsPurchase(
        cartProvider.getTotal, listaProductosPedidos, numDoc);
    //UXCam: Llamamos el evento confirmOrder
    UxcamTagueo().confirmOrder(listaProductosPedidos, cartProvider);
    cartProvider.guardarValorCompra = 0;
    cartProvider.guardarValorAhorro = 0;
    PedidoEmart.cantItems.value = '0';
    controladorCambioEstadoProductos.mapaHistoricos
        .updateAll((key, value) => value = false);
    productViewModel.productListSentWithMax
        .forEach((codigoProducto, mapCantidades) {
      DBProviderHelper.db.updateOffer(
          codigoProducto,
          (mapCantidades['cantidadSolicitada'] <= mapCantidades['cantidadMaxima']
              ? (mapCantidades['cantidadSolicitada'] +
                  mapCantidades['cantidadActual'])
              : mapCantidades['cantidadMaxima']));
    });
    productoViewModel.productListSentWithMax.clear();
    productoViewModel.eliminarBDTemporal();
    if (controller.isPayOnLine.value) {
      Get.off(() => OrderNotificationPage(
          numEmpresa: configureOrderViewModel.numEmpresa.value,
          numdoc: numDoc));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => PedidoRealizado(
              numEmpresa: configureOrderViewModel.numEmpresa.value,
              numdoc: numDoc)));
    }
  } else {
    Navigator.pop(context);
    mostrarAlertaUtilsError(context2, validar.mensaje!);
  }
}

cargandoPedido(context, size) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
          height: 300,
          width: size.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(36.0),
                      child: Icon(
                        Icons.bus_alert,
                        size: 40,
                        color: HexColor("#30C3A3"),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(2),
                      width: size.width * 0.7,
                      child: Text(
                        "Tu pedido está",
                        style: TextStyle(
                            color: HexColor("#43398E"),
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(2),
                      height: 30,
                      width: size.width * 0.7,
                      child: Text(
                        "siendo procesado...",
                        style:
                            TextStyle(color: HexColor("#43398E"), fontSize: 22),
                        textAlign: TextAlign.left,
                      ),
                    )
                  ],
                )
              ],
            ),
          ))
    ],
  );
}
