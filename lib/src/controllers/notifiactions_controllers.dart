// ignore_for_file: unnecessary_statements, unnecessary_null_comparison
import 'package:emart/shared/widgets/card_notification_slide_up.dart';
import 'package:emart/shared/widgets/notification_push_in_app.dart';

import '../../_pideky/domain/producto/service/producto_service.dart';
import '../../_pideky/presentation/productos/view/detalle_producto_compra.dart';
import 'package:emart/_pideky/domain/notification_push_in_app_slide_up/model/notification_push_in_app_slide_up.dart';
import 'package:emart/_pideky/domain/notification_push_in_app_slide_up/service/notification_push_in_app_slide_up_service.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/_pideky/infrastructure/notification_push_in_app_slide_up/notification_push_in_app_slide_up_sql.dart';
import 'package:emart/_pideky/infrastructure/productos/producto_repository_sqlite.dart';
import 'package:emart/_pideky/presentation/club_ganadores/view/club_ganadores_page.dart';
import 'package:emart/_pideky/presentation/mi_negocio/view_model/mi_negocio_view_model.dart';
import 'package:emart/_pideky/presentation/mis_pagos_nequi/view/mis_pagos_nequi.dart';
import 'package:emart/shared/widgets/terminos_condiciones.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/bannnersController.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/modelos/fabricantes.dart';
import 'package:emart/src/modelos/marcas.dart';
import 'package:emart/src/pages/catalogo/widgets/tab_categorias_opciones.dart';
import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/pages/principal_page/widgets/custom_buscador_fuzzy.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class NotificationsSlideUpAndPushInUpControllers extends GetxController {
  final notificacionesService =
      NotificationPushInAppSlideUpService(NotificationPushInUpAndSlideUpSql());

  final prefs = Preferencias();
  final bannerController = Get.put(BannnerControllers());
  final MiNegocioViewModel viewModel = Get.find<MiNegocioViewModel>();
  RxBool onTapPushInUp = false.obs;
  RxBool closePushInUp = false.obs;
  RxBool closeSlideUp = false.obs;
  RxList listSlideUpHome = [].obs;
  RxList listSlideUpProveedores = [].obs;
  RxList listSlideUpMarcas = [].obs;
  RxList listSlideUpCategorias = [].obs;
  RxList listPushInUpHome = [].obs;
  RxList listPushInUpProveedores = [].obs;
  RxList listPushInUpMarcas = [].obs;
  RxList listPushInUpCategorias = [].obs;
  RxMap validacionMostrarSlideUp = {}.obs;
  RxMap validacionMostrarPushInUp = {}.obs;

  void resetMaps() {
    validacionMostrarSlideUp.clear();
    validacionMostrarPushInUp.clear();
  }

  void llenarMapSlideUp(String dataKeys) {
    for (int i = 0; i < dataKeys.length; i++) {
      validacionMostrarSlideUp.putIfAbsent(dataKeys, () => true);
    }
  }

  void llenarMapPushInUp(String dataKeys) {
    for (int i = 0; i < dataKeys.length; i++) {
      validacionMostrarPushInUp.putIfAbsent(dataKeys, () => true);
    }
  }

  Future<void> showSlideUp(String? nombreSeccion, String? nombreCategoria,
      BuildContext context) async {
    switch (nombreSeccion) {
      case "categoria":
        if (validacionMostrarSlideUp[nombreCategoria] == true) {
          var notificationTemp = listSlideUpCategorias.first;
          if (notificationTemp.subCategoriaUbicacion == nombreCategoria) {
            validacionMostrarSlideUp[nombreCategoria] = false;
            closeSlideUp.value = true;
            await Future.delayed(Duration(milliseconds: 100),
                () => showSlideUpNotification(context, notificationTemp, ""));
          }
        }
        break;
      case "marca":
        if (validacionMostrarSlideUp[nombreCategoria] == true) {
          var notificationTemp = listSlideUpMarcas.first;
          if (notificationTemp.subCategoriaUbicacion == nombreCategoria) {
            validacionMostrarSlideUp[nombreCategoria] = false;
            closeSlideUp.value = true;
            await Future.delayed(Duration(milliseconds: 100),
                () => showSlideUpNotification(context, notificationTemp, ""));
          }
        }
        break;
      case "proveedor":
        if (validacionMostrarSlideUp[nombreCategoria] == true) {
          var notificationTemp = listSlideUpProveedores.first;
          if (notificationTemp.subCategoriaUbicacion == nombreCategoria) {
            validacionMostrarSlideUp[nombreCategoria] = false;
            closeSlideUp.value = true;
            await Future.delayed(Duration(milliseconds: 100),
                () => showSlideUpNotification(context, notificationTemp, ""));
          }
        }
        break;
      default:
    }
  }

  Future<void> showPushInUp(
    String? nombreSeccion,
    String? nombreCategoria,
    BuildContext context,
  ) async {
    switch (nombreSeccion) {
      case 'categoria':
        if (validacionMostrarPushInUp[nombreCategoria] == true) {
          var notificationTemp = listPushInUpCategorias.first;
          if (notificationTemp.subCategoriaUbicacion == nombreCategoria) {
            validacionMostrarPushInUp[nombreCategoria] = false;
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return WillPopScope(
                      onWillPop: () async => false,
                      child: NotificationPushInApp(notificationTemp, ""));
                });
          }
        }
        break;
      case 'marca':
        if (validacionMostrarPushInUp[nombreCategoria] == true) {
          var notificationTemp = listPushInUpMarcas.first;
          if (notificationTemp.subCategoriaUbicacion == nombreCategoria) {
            validacionMostrarPushInUp[nombreCategoria] = false;
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return WillPopScope(
                      onWillPop: () async => false,
                      child: NotificationPushInApp(notificationTemp, ""));
                });
          }
        }
        break;
      case 'proveedor':
        if (validacionMostrarPushInUp[nombreCategoria] == true) {
          var notificationTemp = listPushInUpProveedores.first;
          if (notificationTemp.subCategoriaUbicacion == nombreCategoria) {
            validacionMostrarPushInUp[nombreCategoria] = false;
            validacionMostrarPushInUp[nombreCategoria] = false;
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return WillPopScope(
                      onWillPop: () async => false,
                      child: NotificationPushInApp(notificationTemp, ""));
                });
          }
        }
        break;
      default:
    }
  }

  void validarRedireccionOnTap(
    NotificationPushInAppSlideUpModel notificacion,
    BuildContext context,
    CarroModelo provider,
    CambioEstadoProductos cargoConfirmar,
    Preferencias prefs,
    String locasionBanner,
  ) async {
    ProductoService productService =
        ProductoService(ProductoRepositorySqlite());
    final providerBottomNavigationBar =
        Provider.of<OpcionesBard>(context, listen: false);

    var resBusqueda;
    if (notificacion.redireccion == 'Detalle Producto') {
      resBusqueda = await productService.cargarProductosFiltro(
          notificacion.subCategoriaRedireccion.toString(), "");
      _detalleProducto(
          resBusqueda[0], provider, context, cargoConfirmar, prefs);
    } else if (notificacion.redireccion == 'Categoría') {
      resBusqueda = await DBProvider.db
          .consultarCategorias(notificacion.categoriaRedireccion.toString(), 1);
      var resSubBusqueda = await DBProvider.db
          .consultarCategoriasSubCategorias(resBusqueda[0].codigo);
      _direccionarCategoria(context, provider, resSubBusqueda,
          notificacion.subCategoriaRedireccion.toString());
    } else if (notificacion.redireccion == 'Proveedor') {
      resBusqueda = await DBProvider.db
          .consultarFricante(notificacion.subCategoriaRedireccion.toString());
      // print('soy proveedor ${jsonEncode(resBusqueda)}');
      _direccionarProveedor(context, resBusqueda[0]);
    } else if (notificacion.redireccion == 'Marca') {
      resBusqueda = await DBProvider.db
          .consultarMarcas(notificacion.categoriaRedireccion.toString());
      _direccionarMarca(context, resBusqueda[0]);
    } else if (notificacion.redireccion == "Términos y condiciones") {
      if (locasionBanner == 'Home') {
        viewModel.terminosDatosPdf != null
            ? verTerminosCondiciones(context, viewModel.terminosDatosPdf)
            : null;
      } else {
        await _navegacionPushInUp();
        viewModel.terminosDatosPdf != null
            ? verTerminosCondiciones(context, viewModel.terminosDatosPdf)
            : null;
      }
    } else if (notificacion.redireccion == "Mi Negocio") {
      if (locasionBanner == "Home") {
        providerBottomNavigationBar.selectOptionMenu = 4;
      } else {
        Navigator.of(context).pop();
        providerBottomNavigationBar.selectOptionMenu = 4;
      }
    } else if (notificacion.redireccion == "Mis pagos Nequi") {
      if (locasionBanner == "Home") {
        Get.to(() => MisPagosNequiPage());
      } else {
        Navigator.of(context).pop();
        Get.to(() => MisPagosNequiPage());
      }
    } else if (notificacion.redireccion == "Club de ganadores") {
      if (locasionBanner == "Home") {
        Get.to(() => ClubGanadoresPage());
      } else {
        Navigator.of(context).pop();
        Get.to(() => ClubGanadoresPage());
      }
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomBuscardorFuzzy(
                    codCategoria: notificacion.fabricante!,
                    numEmpresa: 'nutresa',
                    tipoCategoria: 4,
                    nombreCategoria: notificacion.nombreComercial!,
                    img: notificacion.imageUrl,
                    locasionBanner: locasionBanner,
                    locacionFiltro: "proveedor",
                    codigoProveedor: "",
                  )));
    }
  }

  Future<void> _navegacionPushInUp() async {
    Get.back();
  }

  _direccionarCategoria(BuildContext context, CarroModelo provider,
      List<dynamic> resSubBusqueda, String subCategoria) async {
    if (subCategoria != '') {
      bannerController.cambiarSubCategoria(resSubBusqueda.indexWhere(
          (element) =>
              element.descripcion.toLowerCase() == subCategoria.toLowerCase()));
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TabOpcionesCategorias(
                  listaCategorias: resSubBusqueda,
                  nombreCategoria: subCategoria,
                )));
  }

  _direccionarMarca(
    BuildContext context,
    Marcas marca,
  ) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomBuscardorFuzzy(
                  codCategoria: marca.codigo,
                  numEmpresa: 'nutresa',
                  tipoCategoria: 3,
                  nombreCategoria: marca.titulo,
                  isActiveBanner: false,
                  locacionFiltro: "marca",
                  codigoProveedor: "",
                )));
  }

  _direccionarProveedor(
    BuildContext context,
    Fabricantes proveedor,
  ) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomBuscardorFuzzy(
                  codCategoria: proveedor.empresa!,
                  numEmpresa: 'nutresa',
                  tipoCategoria: 4,
                  nombreCategoria: proveedor.nombrecomercial!,
                  img: proveedor.icono,
                  locacionFiltro: "proveedor",
                  codigoProveedor: proveedor.empresa.toString(),
                )));
  }

  _detalleProducto(
      Producto producto,
      final CarroModelo cartProvider,
      BuildContext context,
      CambioEstadoProductos cargoConfirmar,
      Preferencias prefs) {
    if (prefs.usurioLogin == -1) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      PedidoEmart.inicializarValoresFabricante();
      cartProvider.actualizarListaFabricante =
          PedidoEmart.listaPrecioPorFabricante!;
      cargoConfirmar.cambiarValoresEditex(PedidoEmart.obtenerValor(producto)!);
      cargoConfirmar.cargarProductoNuevo(
          ProductoCambiante.m(producto.nombre, producto.codigo), 1);
      cartProvider.guardarCambiodevista = 1;
      PedidoEmart.cambioVista.value = 1;

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CambiarDetalleCompra()));
    }
  }

  getSlideUpByDataBaseHome(String ubicacion) async {
    var listSlideUpsTemp =
        await notificacionesService.consultNotificationsSlideUp(ubicacion);

    if (listSlideUpsTemp.isNotEmpty) {
      listSlideUpHome.assignAll(listSlideUpsTemp);
    } else {
      listSlideUpHome.clear();
    }
  }

  getSlideUpByDataBaseProveedores(String ubicacion) async {
    var listSlideUpsTemp =
        await notificacionesService.consultNotificationsSlideUp(ubicacion);

    if (listSlideUpsTemp.isNotEmpty) {
      listSlideUpProveedores.assignAll(listSlideUpsTemp);
    } else {
      listSlideUpProveedores.clear();
    }
  }

  getSlideUpByDataBaseMarcas(String ubicacion) async {
    var listSlideUpsTemp =
        await notificacionesService.consultNotificationsSlideUp(ubicacion);

    if (listSlideUpsTemp.isNotEmpty) {
      listSlideUpMarcas.assignAll(listSlideUpsTemp);
    } else {
      listSlideUpMarcas.clear();
    }
  }

  getSlideUpByDataBaseCategorias(String ubicacion) async {
    var listSlideUpsTemp =
        await notificacionesService.consultNotificationsSlideUp(ubicacion);

    if (listSlideUpsTemp.isNotEmpty) {
      listSlideUpCategorias.assignAll(listSlideUpsTemp);
    } else {
      listSlideUpCategorias.clear();
    }
  }

  getPushInUpByDataBaseHome(String ubicacion) async {
    var listPushInUpsTemp =
        await notificacionesService.consultNotificationPushInApp(ubicacion);
    if (listPushInUpsTemp.isNotEmpty) {
      listPushInUpHome.assignAll(listPushInUpsTemp);
    } else {
      listPushInUpHome.clear();
    }
  }

  getPushInUpByDataBaseProveedores(String ubicacion) async {
    var listPushInUpsTemp =
        await notificacionesService.consultNotificationPushInApp(ubicacion);
    if (listPushInUpsTemp.isNotEmpty) {
      listPushInUpProveedores.assignAll(listPushInUpsTemp);
    } else {
      listPushInUpProveedores.clear();
    }
  }

  getPushInUpByDataBaseMarcas(String ubicacion) async {
    var listPushInUpsTemp =
        await notificacionesService.consultNotificationPushInApp(ubicacion);
    if (listPushInUpsTemp.isNotEmpty) {
      listPushInUpMarcas.assignAll(listPushInUpsTemp);
    } else {
      listPushInUpMarcas.clear();
    }
  }

  getPushInUpByDataBaseCategorias(String ubicacion) async {
    var listPushInUpsTemp =
        await notificacionesService.consultNotificationPushInApp(ubicacion);
    if (listPushInUpsTemp.isNotEmpty) {
      listPushInUpCategorias.assignAll(listPushInUpsTemp);
    } else {
      listPushInUpCategorias.clear();
    }
  }

  static NotificationsSlideUpAndPushInUpControllers get findOrInitialize {
    try {
      return Get.find<NotificationsSlideUpAndPushInUpControllers>();
    } catch (e) {
      Get.put(NotificationsSlideUpAndPushInUpControllers());
      return Get.find<NotificationsSlideUpAndPushInUpControllers>();
    }
  }
}
