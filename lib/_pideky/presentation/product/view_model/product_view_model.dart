// ignore_for_file: invalid_use_of_protected_member

import 'package:emart/_pideky/domain/delivery_conditions/model/condicionEntrega.dart';
import 'package:emart/_pideky/domain/delivery_conditions/use_cases/condicion_entrega_use_cases.dart';
import 'package:emart/_pideky/domain/product/model/product_model.dart';
import 'package:emart/_pideky/domain/product/use_cases/producto_use_cases.dart';
import 'package:emart/_pideky/infrastructure/delivery_conditions/delivery_conditions_service.dart';
import 'package:emart/_pideky/infrastructure/product/product_service.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/shared/widgets/custom_modal.dart';
import 'package:emart/src/controllers/slide_up_automatic.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/widget/imagen_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProductViewModel extends GetxController {
  CondicionEntregaUseCases condicionEntregaService =
      CondicionEntregaUseCases(CondicionEntregaRepositorySqlite());
  ProductoService productService = ProductoService(ProductoRepositorySqlite());

  final db = ProductoRepositorySqlite();

  var listSemana = {
    "L": "Lunes",
    "M": "Martes",
    "W": "Miércoles",
    "J": "Jueves",
    "V": "Viernes",
    "S": "Sábado",
    "D": "Domingo"
  };

  RxList listCondicionEntrega = [].obs;

  RxBool seeAlertMaximumPromotionLimit = false.obs;
  // este map<String, Map<String, dynamic>> se usa para guardar los productos que se
  // se envian en el pedido y tienen cantidad maxima para modificar la db
  Map productListSentWithMax = {}.obs;

  // metodo para llenar el map productListSentWithMax
  void fillProductListSentWithMax(String codigoProducto, int cantidadActual,
      int cantidadSolicitada, int cantidadMaxima) {
    if (productListSentWithMax.containsKey(codigoProducto)) {
      productListSentWithMax[codigoProducto]['cantidadActual'] = cantidadActual;
      productListSentWithMax[codigoProducto]['cantidadSolicitada'] =
          cantidadSolicitada;
      productListSentWithMax[codigoProducto]['cantidadMaxima'] = cantidadMaxima;
      return;
    }
    productListSentWithMax.putIfAbsent(
        codigoProducto,
        () => {
              'cantidadActual': cantidadActual,
              'cantidadSolicitada': cantidadSolicitada,
              'cantidadMaxima': cantidadMaxima
            });
  }

  // metodo para eliminar un producto del map productListSentWithMax
  void deleteProductListSentWithMax(String codigoProducto) {
    productListSentWithMax.remove(codigoProducto);
  }

  String getCurrency(dynamic valor) {
    NumberFormat formatNumber = new NumberFormat("#,##0.00", "es_AR");

    var result = '${getFormat().currencySymbol}' +
        formatNumber.format(valor).replaceAll(',00', '');

    return result;
  }

  Future<Product> getProducto(String skuProduct) async {
    Product producto = await db.consultarDatosProducto(skuProduct);
    return producto;
  }

  NumberFormat getFormat() {
    var locale = Intl().locale;
    var format = locale.toString() != 'es_CO'
        ? locale.toString() == 'es_CR'
            ? NumberFormat.currency(locale: locale.toString(), symbol: '\₡')
            : NumberFormat.simpleCurrency(locale: locale.toString())
        : NumberFormat.currency(locale: locale.toString(), symbol: '\$');

    return format;
  }

  void cargarCondicionEntrega() async {
    PedidoEmart.listaFabricante =
        await DBProvider.db.consultarFricanteGeneral();
    getCondicionEntrega();
  }

  void getCondicionEntrega() async {
    listCondicionEntrega.value =
        await condicionEntregaService.consultarCondicionEntrega();
  }

  bool validarFrecuencia(String fabricante) {
    DateTime now = DateTime.now();

    var diaLocal = DateFormat.EEEE().format(now);
    var listDias = [];

    CondicionEntrega condicionEntrega = listCondicionEntrega.value
        .firstWhere((element) => element.fabricante == fabricante);
    var diasCondicion = condicionEntrega.diaVisita?.split('-');
    listDias = trasformarDias(diasCondicion);
    String horaLocal = DateFormat('HH').format(now);
    var horaMaxFrecuencia = condicionEntrega.hora?.split(':');

    return condicionEntrega.semana == 1 &&
        listDias.contains(diaLocal.capitalize) &&
        int.parse(horaLocal) < int.parse(horaMaxFrecuencia![0]);
  }

  void abrirModal(context, listDias) {
    showLoaderDialog(
        context,
        CustomModal(
          icon: Image.asset(
            'assets/icon/cart_shop.png',
            alignment: Alignment.center,
            width: Get.width * 0.15,
            color: ConstantesColores.azul_aguamarina_botones,
          ),
          mensaje: S.current.delivery_days(listDias),
          visibilitySecondBtn: false,
          onTapFirsBtn: () => Get.back(),
        ),
        Get.height * 0.3);
  }

  void iniciarModal(context, fabricante) {
    abrirModal(context, getListaDiasSemana(fabricante));
  }

  String getListaDiasSemana(String fabricante) {
    try {
      CondicionEntrega condicionEntrega = listCondicionEntrega.value
          .firstWhere((element) => element.fabricante == fabricante);
      var diasCondicion = condicionEntrega.diaVisita?.split('-');

      String listDias = '';
      if (diasCondicion!.length == 1) {
        listDias = "${listSemana[diasCondicion[0]].toString()}.";
      }
      if (diasCondicion.length == 2) {
        for (var i = 0; i < diasCondicion.length; i++) {
          i == 0
              ? listDias = "${listSemana[diasCondicion[i]].toString()} y"
              : listDias += " ${listSemana[diasCondicion[i]].toString()}.";
        }
      }
      if (diasCondicion.length > 2) {
        for (var i = 0; i < diasCondicion.length; i++) {
          if (i == diasCondicion.length - 1) {
            listDias += " y ${listSemana[diasCondicion[i]].toString()}.";
          } else if (i == diasCondicion.length - 2) {
            listDias += "${listSemana[diasCondicion[i]].toString()} ";
          } else {
            listDias += "${listSemana[diasCondicion[i]].toString()}, ";
          }
        }
      }

      return listDias;
    } catch (e) {
      return '';
    }
  }

  List<dynamic> trasformarDias(List<String>? diasCondicion) {
    var listDias = [];
    diasCondicion?.forEach((element) {
      listDias.add(listSemana[element]);
    });

    return listDias;
  }

  void insertarPedidoTemporal(String codigoProducto) async {
    List<Product> listPedidoTemp =
        await productService.consultarPedidoTemporal();

    try {
      var cantidadNueva = int.parse(
          PedidoEmart.obtenerValor(PedidoEmart.listaProductos![codigoProducto]!)
              .toString());

      if (listPedidoTemp.isNotEmpty) {
        var getPedido;

        for (var element in listPedidoTemp) {
          if (codigoProducto.contains(element.codigo)) {
            getPedido = element;
            break;
          }
        }
        if (getPedido != null) {
          if (cantidadNueva != getPedido.cantidad) {
            if (cantidadNueva > 0) {
              if (cantidadNueva != getPedido.cantidad) {
                await productService.modificarPedidoTemp(
                    codigoProducto, cantidadNueva);
                return;
              }
            } else {
              eliminarProductoTemporal(codigoProducto);
              return;
            }
          }

          return;
        }
      }

      await productService.insertPedidoTemp(codigoProducto, cantidadNueva);
    } catch (e) {
      print("Error en insertar pedido temporal $e");
    }
  }

  void eliminarProductoTemporal(String codProducto) async =>
      await productService.eliminarPedidoTemp(codProducto);

  cargarTemporal() async {
    try {
      List<Product> listPedidoTemp =
          await productService.consultarPedidoTemporal();
      listPedidoTemp.forEach((element) async {
        Product producto =
            await productService.consultarDatosProducto(element.codigo);
        Get.find<SlideUpAutomatic>().listaProductosCarrito.add(producto);
        PedidoEmart.listaControllersPedido![producto.codigo]!.text =
            element.cantidad.toString();
        PedidoEmart.registrarValoresPedido(
            producto, element.cantidad.toString(), true);
      });
    } catch (e) {
      print('paso un error en cargarTemporal $e');
    }
  }

  eliminarBDTemporal() async =>
      await DBProviderHelper.db.eliminarBasesDeDatosTemporal();

  static ProductViewModel get findOrInitialize {
    try {
      return Get.find<ProductViewModel>();
    } catch (e) {
      Get.put(ProductViewModel());
      return Get.find<ProductViewModel>();
    }
  }

  bool isMaximumPromotionLimitReached(
      int maxQuantity, int currentQuantity, int requestedAmount) {
    return maxQuantity != 0 &&
        (maxQuantity - requestedAmount) <= currentQuantity;
  }

  // Método para verificar y actualizar la variable reactiva
  bool checkAndSetAlert(
      int maxQuantity, int currentQuantity, int requestedAmount) {
    seeAlertMaximumPromotionLimit.value =
        maxQuantity != 0 && (maxQuantity - requestedAmount) <= currentQuantity;
    return seeAlertMaximumPromotionLimit.value;
  }

  bool get isAlertVisible => seeAlertMaximumPromotionLimit.value;
}
