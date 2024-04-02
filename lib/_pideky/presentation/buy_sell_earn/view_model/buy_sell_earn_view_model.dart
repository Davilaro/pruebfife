import 'dart:async';
import 'package:emart/_pideky/domain/buy_sell_earn/model/buy_sell_earn_model.dart';
import 'package:emart/_pideky/domain/buy_sell_earn/use_cases/buy_sell_earn_use_cases.dart';
import 'package:emart/_pideky/domain/product/model/product_model.dart';
import 'package:emart/_pideky/infrastructure/product/product_service.dart';
import 'package:emart/_pideky/presentation/product/view/detalle_producto_compra.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuySellEarnViewModel extends GetxController {
  final CompraVendeGanaService _compraVendeGanaService =
      CompraVendeGanaService();

  Future<List<BuySellEarnModel>> getCupons() async {
    return await _compraVendeGanaService.getCupons();
  }

  Future<void> addCuponToCar(String cuponCode, BuildContext context) async {
    final cargoConfirmar = Get.find<CambioEstadoProductos>();
    final db = ProductoRepositorySqlite();
    Product producto = await db.consultarDatosProducto(cuponCode);
    cargoConfirmar.cargarProductoNuevo(
        ProductoCambiante.m(producto.nombre, producto.codigo), 2);
    Get.to(() => CambiarDetalleCompra(
          cambioVista: 1,
        ));
  }

  static BuySellEarnViewModel getMyController() {
    return Get.isRegistered<BuySellEarnViewModel>()
        ? Get.find<BuySellEarnViewModel>()
        : Get.put(BuySellEarnViewModel());
  }
}
