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
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyListsViewModel extends GetxController {
  final misListasService =
      MyListsUseCases(misListasInterface: MyListsService());
  final prefs = Preferencias();
  final cargoConfirmar = Get.find<ControlBaseDatos>();
  RxBool seleecionarTodos = false.obs;
  RxBool refreshPage = false.obs;
  RxList misListas = [].obs;
  RxMap mapListasProductos = {}.obs;
  RxString nombreNuevaLista = "".obs;
  final listaFabricante = Get.find<SuggestedOrderViewModel>().listaFabricante;

  Future<void> getMisListas() async {
    misListas.assignAll(await misListasService.getMisListas());
  }

  Future<void> addToCar(context) async {
    ProductViewModel productViewModel = Get.find();
    final cartProvider = Provider.of<CartViewModel>(context, listen: false);
    mapListasProductos.forEach((key, value) {
      value['items'].forEach((DetailList productoDetalle) async {
        if (productoDetalle.isSelected! == true) {
          if (productoDetalle.codigo != "") {
            final db = ProductoRepositorySqlite();

            Product producto =
                await db.consultarDatosProducto(productoDetalle.codigo);
            PedidoEmart.listaControllersPedido![producto.codigo]!.text =
                "${productoDetalle.cantidad}";
            PedidoEmart.registrarValoresPedido(
                producto, '${productoDetalle.cantidad}', true);
            MetodosLLenarValores().calcularValorTotal(cartProvider);
            productViewModel.insertarPedidoTemporal(producto.codigo);

            Get.back();
          }

          update();
        }
      });
    });
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
      await DBProviderHelper.db.actualizarProductoDeLista(id, cantidad);
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

  void deleteProduct(codigo, context) async {
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

    refreshPage.value = true;

    update();
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

    refreshPage.value = true;

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
