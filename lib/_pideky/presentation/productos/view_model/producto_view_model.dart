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

  void insertarPedidoTemporal(String codigoProducto) async {
    List<Producto> listPedidoTemp =
        await productService.consultarPedidoTemporal();
    print('hola res de pedido ${listPedidoTemp.length}');

    try {
      var cantidadNueva = int.parse(
          PedidoEmart.obtenerValor(PedidoEmart.listaProductos![codigoProducto]!)
              .toString());

      if (listPedidoTemp.isNotEmpty) {
        var getPedido;
        print('entre');

        for (var element in listPedidoTemp) {
          if (codigoProducto.contains(element.codigo)) {
            print(
                'esto encontro $codigoProducto --- ${element.codigo} -- ${element.cantidad}');
            getPedido = element;
            break;
          }
        }
        if (getPedido != null) {
          print('Get pedido trajo ${getPedido.codigo}');
          if (cantidadNueva != getPedido.cantidad) {
            if (cantidadNueva > 0) {
              if (cantidadNueva != getPedido.cantidad) {
                print('ejecuto el update de ${getPedido.codigo}');
                await productService.modificarPedidoTemp(
                    codigoProducto, cantidadNueva);
                return;
              }
            } else {
              print('ejecuto el delete 1 de ${getPedido.codigo}');
              eliminarProductoTemporal(codigoProducto);
              return;
            }
          }
          print('no ejecutamos nada');
          return;
        }
      }
      print('ejecuto el insert 2 de ${codigoProducto}');
      await productService.insertPedidoTemp(codigoProducto, cantidadNueva);
    } catch (e) {
      print("Error en insertar pedido temporal $e");
    }
  }

  void eliminarProductoTemporal(String codProducto) async =>
      await productService.eliminarPedidoTemp(codProducto);

  cargarTemporal() async {
    try {
      print('si entre a la temporal');
      List<Producto> listPedidoTemp =
          await productService.consultarPedidoTemporal();
      listPedidoTemp.forEach((element) async {
        Producto producto =
            await productService.consultarDatosProducto(element.codigo);
        print('si entre a la temporal ${producto.codigo}');
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

  static ProductoViewModel get findOrInitialize {
    try {
      return Get.find<ProductoViewModel>();
    } catch (e) {
      Get.put(ProductoViewModel());
      return Get.find<ProductoViewModel>();
    }
  }
}
