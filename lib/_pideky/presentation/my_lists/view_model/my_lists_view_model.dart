import 'dart:async';

import 'package:collection/collection.dart';
import 'package:emart/_pideky/domain/my_lists/model/detail_list_model.dart';
import 'package:emart/_pideky/domain/my_lists/use_cases/my_lists_use_cases.dart';
import 'package:emart/_pideky/domain/product/model/product_model.dart';
import 'package:emart/_pideky/infrastructure/my_lists/my_lists_service.dart';
import 'package:emart/_pideky/infrastructure/product/product_service.dart';
import 'package:emart/_pideky/presentation/suggested_order/view_model/suggested_order_view_model.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/shared/widgets/popups.dart';
import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/metodo_ingresados.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyListsViewModel extends GetxController {
  final misListasService =
      MyListsUseCases(misListasInterface: MyListsService());
  final prefs = Preferencias();
  final cargoConfirmar = Get.find<ControlBaseDatos>();
  ProductViewModel productViewModel = Get.find();
  RxBool seleecionarTodos = false.obs;
  RxList misListas = [].obs;
  RxList productListToCartUxcam = [].obs;
  RxMap mapListasProductos = {}.obs;
  RxString nombreNuevaLista = "".obs;
  final listaFabricante = Get.find<SuggestedOrderViewModel>().listaFabricante;

  Future<void> getMisListas() async {
    misListas.assignAll(await misListasService.getMisListas());
  }

  Future<bool> addToCar(context) async {
    bool flag = false;
    productListToCartUxcam.clear();
    ProductViewModel productViewModel = Get.find();
    final cartProvider = Provider.of<CartViewModel>(context, listen: false);
    for (var entry in mapListasProductos.entries) {
      var value = entry.value;
      await Future.forEach(value['items'], (DetailList productoDetalle) async {
        if (productoDetalle.isSelected! == true) {
          if (productoDetalle.codigo != "") {
            final db = ProductoRepositorySqlite();
            Product producto =
                await db.consultarDatosProducto(productoDetalle.codigo);
            productListToCartUxcam.add(producto);
            PedidoEmart.listaControllersPedido![producto.codigo]!.text =
                "${productoDetalle.cantidad}";
            PedidoEmart.registrarValoresPedido(
                producto, '${productoDetalle.cantidad}', true);
            MetodosLLenarValores().calcularValorTotal(cartProvider);
            productViewModel.insertarPedidoTemporal(producto.codigo);
            flag = true;
          }
          Get.back();
          update();
        }
      });
    }
    return flag;
  }

  Future<void> updateProduct(
      id, codigoProducto, cantidad, proveedor, context) async {
    final result = await misListasService.updateProducto(
        id: id,
        codigoProducto: codigoProducto,
        cantidad: cantidad,
        proveedor: proveedor);
    if (result[1] == false) {
      backClosePopup(context, texto: result[0], isCorrect: false);
    } else {
      await DBProviderHelper.db
          .actualizarProductoDeLista(id, cantidad, codigoProducto);
    }
  }

  Future deleteList(context, nombre, idLista) async {
    final result = await misListasService.deleteLista(
        ccup: prefs.codigoUnicoPideky,
        nombre: nombre,
        sucursal: prefs.sucursal,
        idLista: idLista,
        context: context);
    if (result[1] == false) {
      backClosePopup(context, texto: result[0], isCorrect: false);
    } else if (result[0] == true) {
      await DBProviderHelper.db.eliminarLista(idLista);
      await getMisListas();
      Get.back();
    }
  }

  Future mapearProductos(idLista) async {
    mapListasProductos.clear();
    final listaProductos =
        await misListasService.getProductos(idLista: idLista);
    if (listaProductos.isNotEmpty) {
      final groups = groupBy(listaProductos, (DetailList d) {
        return d.proveedor;
      });

      groups.forEach((key, value) {
        String icon = '';
        String nombreComercial = "";
        RxDouble precioProductos = 0.0.obs;
        RxBool isSelected = false.obs;

        for (int j = 0; j < listaFabricante.length; j++) {
          if (listaFabricante[j].empresa == key) {
            icon = listaFabricante[j].icono;
            nombreComercial = listaFabricante[j].nombrecomercial;
          }
        }
        mapListasProductos.putIfAbsent(
            key,
            () => {
                  'precioProductos': precioProductos,
                  'items': RxList(value),
                  'imagen': icon,
                  'nombrecomercial': nombreComercial,
                  'isSelected': isSelected,
                });
      });
    }
  }

  void deleteProduct(codigo, context, VoidCallback setState) async {
    List list = [];

    mapListasProductos.forEach((key, value) async {
      value['items'].forEach((DetailList productoDetalle) async {
        if (productoDetalle.codigo == codigo) {
          list.add(productoDetalle);
          await DBProviderHelper.db.eliminarProductoDeLista(
              productoDetalle.codigo, productoDetalle.id);
        }
      });
    });

    final result = await misListasService.deleteProducto(productos: list);

    if (result[1] == true) {
      mapListasProductos.forEach((key, value) {
        value['items'].removeWhere((element) => element.codigo == codigo);
      });
    } else {
      backClosePopup(context, isCorrect: false, texto: result[0]);
    }

    setState();
  }

  void deleteProducts(context) async {
    final list = [];

    mapListasProductos.forEach((key, value) {
      value['items'].forEach((DetailList productoDetalle) async {
        if (productoDetalle.isSelected == true) {
          list.add(productoDetalle);
        }
      });
    });

    final result = await misListasService.deleteProducto(productos: list);

    if (result[1] == false) {
      backClosePopup(context, isCorrect: false, texto: result[0]);
    }

    update();
  }

  Future<void> addList(context) async {
    var request = await misListasService.addLista(
        nombreLista: nombreNuevaLista.value,
        sucursal: prefs.sucursal,
        ccup: prefs.codigoUnicoPideky);
    if (request[1] == true) {
      await DBProviderHelper.db
          .guardarLista(request[2], nombreNuevaLista.value);
      await getMisListas();
      Get.back();
      backClosePopup(context,
          texto: request[0],
          pathImage: "assets/image/Icon_correcto.svg",
          isCorrect: true);
      nombreNuevaLista.value = "";
    } else {
      backClosePopup(context, texto: request[0], isCorrect: false);
    }
    update();
  }

  Future existProductInList(String codigoProducto, context) async {
    List listaProductosRes = [];
    final List productos = await misListasService.getProductos();
    final listaIds = [];
    productos.forEach((e) {
      if (codigoProducto == e.codigo) {
        listaIds.add(e.id);
      }
    });
    misListas.forEach((element) {
      if (listaIds.contains(element.id)) {
        listaProductosRes.add(element);
      }
    });
    return listaProductosRes;
  }

  Future<void> addProduct(
      Product producto, int idLista, cantidad, String nombreLista) async {
    final result = await misListasService.addProducto(
        id: idLista,
        codigoProducto: producto.codigo,
        cantidad: cantidad,
        proveedor: producto.fabricante!);
    if (result[1] == false) {
      backClosePopup(Get.context!, texto: result[0], isCorrect: false);
    } else {
      await DBProviderHelper.db.agregarProductoALista(idLista, producto.nombre,
          producto.codigo, cantidad, producto.fabricante!);
    }
  }

  // logica para que el pop up se cierre solo
  backClosePopup(context,
      {String? texto = "Usuario y/o contraseña incorrecto",
      String? pathImage = 'assets/image/Icon_incorrecto.svg',
      required bool isCorrect}) async {
    showPopup(context, texto!, SvgPicture.asset(pathImage!));
  }

  void validateMaxByEachProduct(
      DetailList product, context, VoidCallback setState) {
    if (product.cantidad >
            product.cantidadMaxima! - product.cantidadSolicitada! &&
        product.isOferta == 1) {
      if ((product.cantidadMaxima! - product.cantidadSolicitada!) != 0) {
        updateProduct(
            product.id,
            product.codigo,
            product.cantidadMaxima! - product.cantidadSolicitada!,
            product.proveedor,
            context);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState();
        });
      } else {
          deleteProduct(product.codigo, context, setState);
      }
    }
  }

  void validationProductsMax(DetailList producto) {
    if (producto.cantidadMaxima != 0 &&
        producto.cantidad ==
            producto.cantidadMaxima! - producto.cantidadSolicitada! &&
        producto.isOferta == 1) {
      producto.hasMax = true;
    } else {
      producto.hasMax = false;
    }
    if (producto.isOferta == 1 && producto.cantidadMaxima != 0) {
      productViewModel.fillProductListSentWithMax(
          producto.codigo,
          producto.cantidad,
          producto.cantidadSolicitada!,
          producto.cantidadMaxima!);
    } else {
      if (productViewModel.productListSentWithMax
              .containsKey(producto.codigo) &&
          producto.cantidad != 0) {
        productViewModel.deleteProductListSentWithMax(producto.codigo);
      }
    }
  }

  @override
  void onInit() async {
    await getMisListas();

    super.onInit();
  }

  static MyListsViewModel get findOrInitialize {
    try {
      return Get.find<MyListsViewModel>();
    } catch (e) {
      Get.put(MyListsViewModel());
      return Get.find<MyListsViewModel>();
    }
  }
}
