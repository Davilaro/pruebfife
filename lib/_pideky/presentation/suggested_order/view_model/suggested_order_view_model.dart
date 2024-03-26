// ignore: import_of_legacy_library_into_null_safe
import 'package:collection/collection.Dart';
import 'package:emart/_pideky/domain/suggested_order/model/suggested_order_model.dart';
import 'package:emart/_pideky/domain/suggested_order/use_cases/suggested_order_use_cases.dart';
import 'package:emart/_pideky/domain/product/model/product_model.dart';
import 'package:emart/_pideky/infrastructure/suggested_order/suggested_order_service.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/src/preferences/metodo_ingresados.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../src/controllers/cambio_estado_pedido.dart';
import '../../../../src/preferences/class_pedido.dart';

class SuggestedOrderViewModel extends GetxController
    with GetSingleTickerProviderStateMixin {
  SuggestedOrderUseCases pedidoSugerido;

  SuggestedOrderViewModel(this.pedidoSugerido);
  //controlador de botones superiores
  late TabController tabController;
  late PageController pageController;
  RxInt tabActual = 0.obs;
  final List titulosSeccion = ["Pedido Sugerido", "Mis listas"];

  //usuario logueado
  final prefs = new Preferencias();

  static RxInt userLog = 0.obs;

  SuggestedOrderModel model = SuggestedOrderModel();
  final controlador = Get.put<CambioEstadoProductos>(CambioEstadoProductos());

  RxMap listaProductosPorFabricante = {}.obs;
  RxList<dynamic> listaFabricante = <dynamic>[].obs;
  RxList listaPedidoSugerido = [].obs;
  Map<String, SuggestedOrderModel> listaProductos = {};
  List listaAgrupar = <SuggestedOrderModel>[];
  List<Widget> listaAcordion = [];

  RxBool isValid = false.obs;

  void cambiarTab(int estado) {
    pageController.animateToPage(estado,
        duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    this.tabActual.value = estado;
  }

  llenarCarrito(Product producto, int cantidad, context) async {
    final cartProvider = Provider.of<CartViewModel>(context, listen: false);
    ProductViewModel productViewModel = Get.find();
    if (producto.codigo != "") {
      PedidoEmart.listaControllersPedido![producto.codigo]!.text = "$cantidad";
      PedidoEmart.registrarValoresPedido(producto, '$cantidad', true);
      MetodosLLenarValores().calcularValorTotal(cartProvider);
      productViewModel.insertarPedidoTemporal(producto.codigo);
    }

    update();
  }

  Future getListaProductosSugeridos() async {
    final listaPedidoSugerido = await pedidoSugerido.obtenerPedidoSugerido();
    mapearProductos(listaPedidoSugerido);
    final groups = groupBy(listaPedidoSugerido, (SuggestedOrderModel p) {
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

  void mapearProductos(List<SuggestedOrderModel> lista) {
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

  static SuggestedOrderViewModel get findOrInitialize {
    try {
      return Get.find<SuggestedOrderViewModel>();
    } catch (e) {
      Get.put(SuggestedOrderViewModel(
          SuggestedOrderUseCases(PedidoSugeridoQuery())));
      return Get.find<SuggestedOrderViewModel>();
    }
  }
}
