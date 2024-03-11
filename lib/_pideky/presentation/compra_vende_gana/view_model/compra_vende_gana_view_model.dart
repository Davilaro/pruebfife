import 'dart:async';
import 'package:emart/_pideky/domain/compra_vende_gana/model/compra_vende_gana_model.dart';
import 'package:emart/_pideky/domain/compra_vende_gana/service/compra_vende_gana_service.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/_pideky/infrastructure/productos/producto_repository_sqlite.dart';
import 'package:emart/_pideky/presentation/productos/view/detalle_producto_compra.dart';
import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/metodo_ingresados.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CompraVendeGanaViewModel extends GetxController {
  final CompraVendeGanaService _compraVendeGanaService =
      CompraVendeGanaService();

  Future<List<CompraVendeGanaModel>> getCupons() async {
    return await _compraVendeGanaService.getCupons();
  }

  Future<void> addCuponToCar(String cuponCode, BuildContext context) async {
    final cargoConfirmar = Get.find<CambioEstadoProductos>();
    final db = ProductoRepositorySqlite();
    Producto producto = await db.consultarDatosProducto(cuponCode);
    cargoConfirmar.cargarProductoNuevo(
        ProductoCambiante.m(producto.nombre, producto.codigo), 2);
    Get.to(() => CambiarDetalleCompra(
          cambioVista: 1,
        ));
  }

  static CompraVendeGanaViewModel getMyController() {
    return Get.isRegistered<CompraVendeGanaViewModel>()
        ? Get.find<CompraVendeGanaViewModel>()
        : Get.put(CompraVendeGanaViewModel());
  }
}
