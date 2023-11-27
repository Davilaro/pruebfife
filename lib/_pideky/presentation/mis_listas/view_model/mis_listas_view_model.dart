import 'dart:async';

import 'package:collection/collection.dart';
import 'package:emart/_pideky/domain/mi_listas/model/lista_detalle_model.dart';
import 'package:emart/_pideky/domain/mi_listas/model/lista_encabezado_model.dart';
import 'package:emart/_pideky/domain/mi_listas/services/mis_listas_service.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/_pideky/infrastructure/mis_listas/mis_listas_repository.dart';
import 'package:emart/_pideky/infrastructure/productos/producto_repository_sqlite.dart';
import 'package:emart/_pideky/presentation/pedido_sugerido/view_model/pedido_sugerido_view_model.dart';
import 'package:emart/shared/widgets/popups.dart';
import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/metodo_ingresados.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyListsViewModel extends GetxController {
  final misListasService =
      MisListasService(misListasInterface: MisListasRepository());
  final prefs = Preferencias();
  RxBool seleecionarTodos = false.obs;
  RxBool refreshPage = false.obs;
  RxList misListas = [].obs;
  RxMap mapListasProductos = {}.obs;
  RxString nombreNuevaLista = "".obs;
  final listaFabricante = Get.find<PedidoSugeridoViewModel>().listaFabricante;

  Future<void> getMisListas() async {
    misListas.value = await misListasService.getMisListas();
  }

  Future<void> addToCar(context) async {
    mapListasProductos.forEach((key, value) {
      final cartProvider = Provider.of<CarroModelo>(context, listen: false);
      value['items'].forEach((ListaDetalle productoDetalle) async {
        if (productoDetalle.isSelected! == true) {
          if (productoDetalle.codigo != "") {
            final db = ProductoRepositorySqlite();

            Producto producto =
                await db.consultarDatosProducto(productoDetalle.codigo);
            PedidoEmart.listaControllersPedido![producto.codigo]!.text =
                "${productoDetalle.cantidad}";
            PedidoEmart.registrarValoresPedido(
                producto, '${productoDetalle.cantidad}', true);
            MetodosLLenarValores().calcularValorTotal(cartProvider);

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
    }
  }

  Future deleteList(context, nombre, idLista) async {
    final result = await misListasService.deleteLista(
        ccup: prefs.codigoUnicoPideky,
        nombre: nombre,
        sucursal: prefs.sucursal,
        idLista: idLista);
    print('respuesta $result');
    if (result[1] == false) {
      backClosePopup(context, texto: result[0], isCorrect: false);
    } else if (result[0] == true) {
      Get.back();
    }
  }

  Future mapearProductos(idLista) async {
    mapListasProductos.clear();
    final listaProductos =
        await misListasService.getProductos(idLista: idLista);
    if (listaProductos.isNotEmpty) {
      final groups = groupBy(listaProductos, (ListaDetalle d) {
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
    final list = [];

    mapListasProductos.forEach((key, value) {
      value['items'].forEach((ListaDetalle productoDetalle) async {
        if (productoDetalle.codigo == codigo) {
          list.add(productoDetalle);
        }
      });
    });

    final result = await misListasService.deleteProducto(productos: list);
    print('result $result');

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
      value['items'].forEach((ListaDetalle productoDetalle) async {
        if (productoDetalle.isSelected == true) {
          list.add(productoDetalle);
        }
      });
    });

    final result = await misListasService.deleteProducto(productos: list);
    print('result $result');

    if (result[1] == false) {
      backClosePopup(context, isCorrect: false, texto: result[0]);
    }

    refreshPage.value = true;

    update();
  }

  void addList(context) async {
    var request = await misListasService.addLista(
        nombreLista: nombreNuevaLista.value,
        sucursal: prefs.sucursal,
        ccup: prefs.codigoUnicoPideky);
    if (request[1] == true) {
      final newList =
          ListaEncabezado(id: request[2], nombre: nombreNuevaLista.value);
      misListas.add(newList);
      Get.back();
      backClosePopup(context,
          texto: request[0],
          pathImage: "assets/image/Icon_correcto.svg",
          isCorrect: true);
      nombreNuevaLista.value = "";
    } else {
      backClosePopup(context, texto: request[0], isCorrect: false);
    }
  }

  Future existProductInList(String codigoProducto, context) async {
  final cargoConfirmar = Get.find<ControlBaseDatos>();
    await actualizarPaginaSinReset(context, cargoConfirmar);
    List<ListaEncabezado> listaProductosRes = [];
    final List<ListaDetalle> productos = await misListasService.getProductos();
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
      Producto producto, int idLista, cantidad, String nombreLista) async {
    final result = await misListasService.addProducto(
        id: idLista,
        codigoProducto: producto.codigo,
        cantidad: cantidad,
        proveedor: producto.fabricante!);
    if (result[1] == false) {
      backClosePopup(Get.context!, texto: result[0], isCorrect: false);
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
