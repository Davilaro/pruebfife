// ignore: import_of_legacy_library_into_null_safe
import 'package:collection/collection.Dart';
import 'package:emart/_pideky/domain/pedido_sugerdio/model/pedido_sugerido.dart';
import 'package:emart/_pideky/domain/pedido_sugerdio/service/pedido_sugerido.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/_pideky/infrastructure/pedido_sugerdio/pedido_sugerido_query.dart';
import 'package:emart/src/preferences/metodo_ingresados.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../src/controllers/cambio_estado_pedido.dart';
import '../../../../src/preferences/class_pedido.dart';

class PedidoSugeridoViewModel extends GetxController
    with GetSingleTickerProviderStateMixin {
  PedidoSugeridoServicio pedidoSugerido;

  PedidoSugeridoViewModel(this.pedidoSugerido);
  //controlador de botones superiores
  late TabController tabController;
  late PageController pageController;
  RxInt tabActual = 0.obs;
  final List titulosSeccion = ["Pedido Sugerido", "Mis listas"];

  //usuario logueado
  final prefs = new Preferencias();

  static RxInt userLog = 0.obs;

  PedidoSugeridoModel model = PedidoSugeridoModel();
  final controlador = Get.put<CambioEstadoProductos>(CambioEstadoProductos());

  RxMap listaProductosPorFabricante = {}.obs;
  RxList<dynamic> listaFabricante = <dynamic>[].obs;
  RxList listaPedidoSugerido = [].obs;
  Map<String, PedidoSugeridoModel> listaProductos = {};
  List listaAgrupar = <PedidoSugeridoModel>[];
  List<Widget> listaAcordion = [];

  RxBool isValid = false.obs;

  void cambiarTab(int estado) {
    pageController.animateToPage(estado,
        duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    this.tabActual.value = estado;
  }

  llenarCarrito(Producto producto, int cantidad, context) async {
    final cartProvider = Provider.of<CarroModelo>(context, listen: false);
    if (producto.codigo != "") {
      PedidoEmart.listaControllersPedido![producto.codigo]!.text = "$cantidad";
      PedidoEmart.registrarValoresPedido(producto, '$cantidad', true);
      MetodosLLenarValores().calcularValorTotal(cartProvider);
    }

    update();
  }

  Future getListaProductosSugeridos() async {
    final listaPedidoSugerido = await pedidoSugerido.obtenerPedidoSugerido();
    mapearProductos(listaPedidoSugerido);
    final groups = groupBy(listaPedidoSugerido, (PedidoSugeridoModel p) {
      return p.negocio;
    });
    groups.forEach((key, value) {
      RxBool isSelected = false.obs;
      String icon = '';
      String nombreComercial = "";
      double precioProductos = 0;
      int bloqueoCartera = 0;

      for (int j = 0; j < listaFabricante.length; j++) {
        if (listaFabricante[j].empresa == key) {
          icon = listaFabricante[j].icono;
          nombreComercial = listaFabricante[j].nombrecomercial;
          bloqueoCartera = listaFabricante[j].bloqueoCartera;
        }
      }

      listaProductosPorFabricante.putIfAbsent(
          key!,
          () => {
                'precioProductos': precioProductos,
                'items': value,
                'imagen': icon,
                'nombrecomercial': nombreComercial,
                'bloqueoCartera': bloqueoCartera,
                'isSelected': isSelected,
              });
    });
    // update();
  }

  void mapearProductos(List<PedidoSugeridoModel> lista) {
    lista.forEach((element) {
      listaProductos[element.codigo!] = element;
    });
  }

  Future getListaFabricantes() async {
    listaFabricante.value = await DBProvider.db.consultarFabricanteBloqueo();
  }

  initController() async {
    listaProductosPorFabricante.clear();
    await getListaFabricantes();
    await getListaProductosSugeridos();
  }

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    initController();
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
    pageController.dispose();
  }

  static PedidoSugeridoViewModel get findOrInitialize {
    try {
      return Get.find<PedidoSugeridoViewModel>();
    } catch (e) {
      Get.put(PedidoSugeridoViewModel(
          PedidoSugeridoServicio(PedidoSugeridoQuery())));
      return Get.find<PedidoSugeridoViewModel>();
    }
  }
}
