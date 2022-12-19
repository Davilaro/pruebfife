// ignore: import_of_legacy_library_into_null_safe
import 'package:collection/collection.Dart';
import 'package:emart/_pideky/domain/pedido_sugerdio/model/pedido_sugerido.dart';
import 'package:emart/_pideky/domain/pedido_sugerdio/service/pedido_sugerido.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PedidoSugeridoController extends GetxController
    with GetSingleTickerProviderStateMixin {
  PedidoSugeridoServicio pedidoSugerido;

  PedidoSugeridoController(this.pedidoSugerido);
  //controlador de botones superiores
  late TabController controller;
  RxInt tabActual = 0.obs;
  final List titulosSeccion = ["Pedido Sugerido", "Pedido Rápido"];

  //usuario logueado
  RxString usuarioLogueado = "".obs;

  PedidoSugeridoModel model = PedidoSugeridoModel();

  Map<String, dynamic> listaProductosPorFabricante = new Map();
  RxList<dynamic> listaFabricante = <dynamic>[].obs;
  RxList listaPedidoSugerido = [].obs;
  Map<String, PedidoSugeridoModel> listaProductos = {};
  List listaAgrupar = <PedidoSugeridoModel>[];

  RxBool cargarDeNuevo = false.obs;
  RxBool isValid = false.obs;

  void cambiarTab(int estado) {
    this.tabActual.value = estado;
  }

  Future getListaProductosSugeridos() async {
    final listaPedidoSugerido = await pedidoSugerido.obtenerPedidoSugerido();
    mapearProductos(listaPedidoSugerido);
    final groups = groupBy(listaPedidoSugerido, (PedidoSugeridoModel p) {
      return p.negocio;
    });
    groups.forEach((key, value) {
      String icon = '';
      String nombreComercial = "";
      double precioProductos = 0;

      for (int i = 0; i < value.length; i++) {
        precioProductos =
            precioProductos + (value[i].cantidad! * value[i].precio!);
      }

      for (int j = 0; j < listaFabricante.length; j++) {
        if (listaFabricante[j].empresa == key) {
          icon = listaFabricante[j].icono;
          nombreComercial = listaFabricante[j].nombrecomercial;
        }
      }

      listaProductosPorFabricante.putIfAbsent(
          key!,
          () => {
                'precioProductos': precioProductos,
                'items': value,
                'imagen': icon,
                'nombrecomercial': nombreComercial
              });
    });
  }

  void mapearProductos(List<PedidoSugeridoModel> lista) {
    lista.forEach((element) {
      listaProductos[element.codigo!] = element;
    });
  }

  Future getListaFabricantes() async {
    listaFabricante.value = await DBProvider.db.consultarFricante("");
    // listaFabricante.forEach((element) {
    //   print(element.nombrecomercial);
    // });
  }

  @override
  void onInit() {
    controller = TabController(length: 2, vsync: this, initialIndex: 0);
    getListaFabricantes();
    getListaProductosSugeridos();

    super.onInit();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
