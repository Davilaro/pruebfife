import 'dart:convert';

import 'package:emart/_pideky/domain/condicion_entrega/model/condicionEntrega.dart';
import 'package:emart/_pideky/domain/condicion_entrega/service/condicion_entrega_service.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/_pideky/domain/producto/service/producto_service.dart';
import 'package:emart/_pideky/infrastructure/condicion_entrega/condicion_entrega_sqlite.dart';
import 'package:emart/_pideky/infrastructure/productos/producto_repository_sqlite.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/shared/widgets/custom_modal.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/widget/imagen_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProductoViewModel extends GetxController {
  CondicionEntregaService condicionEntregaService =
      CondicionEntregaService(CondicionEntregaRepositorySqlite());
  ProductoService productService = ProductoService(ProductoRepositorySqlite());

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

  String getCurrency(dynamic valor) {
    NumberFormat formatNumber = new NumberFormat("#,##0.00", "es_AR");

    var result = '${getFormat().currencySymbol}' +
        formatNumber.format(valor).replaceAll(',00', '');

    return result;
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
    print('cargamos condiciones');
  }

  void getCondicionEntrega() async {
    listCondicionEntrega.value =
        await condicionEntregaService.consultarCondicionEntrega();
  }

  bool validarFrecuencia(String fabricante) {
    var diaLocal = DateFormat.EEEE().format(DateTime.now());
    var listDias = [];

    CondicionEntrega condicionEntrega = listCondicionEntrega.value
        .firstWhere((element) => element.fabricante == fabricante);
    var diasCondicion = condicionEntrega.diaVisita?.split('-');
    listDias = trasformarDias(diasCondicion);

    return condicionEntrega.semana == 1 &&
        listDias.contains(diaLocal.capitalize);
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
      print('sin resultados $e');
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

  void insertarPedidoTemporal() async {
    List<Producto> listPedidoTemp =
        await productService.consultarPedidoTemporal();
    print('hola res de pedido ${listPedidoTemp.length}');
    // listPedidoTemp.forEach((element) {
    //   PedidoEmart.listaValoresPedidoAgregados?.forEach((key, value) {
    //     print(
    //         'ejecuto ${element.codigo} ---- $key -----${key.contains(element.codigo.toString())}');
    //     if (value) {
    //       if (element.codigo.contains(key.toString())) {
    //         print('ejecuto el update ${element.codigo}');
    //       } else {
    //         // print('ejecuto el insert ${element.codigo}');
    //       }
    //     }
    //   });
    // });
    PedidoEmart.listaValoresPedidoAgregados?.forEach((key, value) async {
      if (value == true) {
        if (listPedidoTemp.isNotEmpty) {
          print('entre');
          var getPedido = listPedidoTemp
              .firstWhere((element) => key.contains(element.codigo));
          if (getPedido != null) {
            if (int.parse(
                    PedidoEmart.obtenerValor(PedidoEmart.listaProductos![key]!)
                        .toString()) >
                0) {
              if (int.parse(PedidoEmart.obtenerValor(
                          PedidoEmart.listaProductos![key]!)
                      .toString()) !=
                  getPedido.cantidad) {
                print('ejecuto el update de ${getPedido.codigo}');
                return;
              }
            } else {
              print('ejecuto el delete de ${getPedido.codigo}');
              return;
            }
            print('ejecuto el delete de ${getPedido.codigo}');
            return;
          }
        }
        print('ejecuto el insert 2 de ${key}');
        await productService.insertPedidoTemp(
            key,
            int.parse(
                PedidoEmart.obtenerValor(PedidoEmart.listaProductos![key]!)
                    .toString()));

        //     // await DBProviderHelper.db.insertPedidoTemp(
        //     //     key,
        //     //     int.parse(
        //     //         PedidoEmart.obtenerValor(PedidoEmart.listaProductos![key]!)
        //     //             .toString()));
        //   }
      }
    });
  }

  static ProductoViewModel get findOrInitialize {
    try {
      return Get.find<ProductoViewModel>();
    } catch (e) {
      Get.put(ProductoViewModel());
      return Get.find<ProductoViewModel>();
    }
  }
}
