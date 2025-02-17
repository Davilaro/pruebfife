// ignore_for_file: unnecessary_statements, unnecessary_null_comparison, deprecated_member_use
import 'dart:async';

import 'package:emart/_pideky/domain/brand/model/brand.dart';
import 'package:emart/_pideky/domain/brand/use_cases/brand_use_cases.dart';
import 'package:emart/_pideky/infrastructure/brand/brand_service.dart';
import 'package:emart/_pideky/presentation/customers_prospection/view/customers_prospection_page.dart';
import 'package:emart/shared/widgets/card_notification_slide_up.dart';
import 'package:emart/shared/widgets/notification_push_in_app.dart';
import 'package:emart/src/controllers/encuesta_controller.dart';
import 'package:emart/src/controllers/slide_up_automatic.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../_pideky/domain/product/use_cases/producto_use_cases.dart';
import '../../_pideky/presentation/customers_prospections_sura/view/customer_prospection_sura_page.dart';
import '../../_pideky/presentation/product/view/detalle_producto_compra.dart';
import 'package:emart/_pideky/domain/notification_push_in_app_slide_up/model/notification_push_in_app_slide_up.dart';
import 'package:emart/_pideky/domain/notification_push_in_app_slide_up/use_cases/notification_push_in_app_slide_up_service.dart';
import 'package:emart/_pideky/domain/product/model/product_model.dart';
import 'package:emart/_pideky/infrastructure/notification_push_in_app_slide_up/notification_push_in_app_slide_up_service.dart';
import 'package:emart/_pideky/infrastructure/product/product_service.dart';
import 'package:emart/_pideky/presentation/winners_club/view/winners_club_page.dart';
import 'package:emart/_pideky/presentation/my_business/view_model/my_business_view_model.dart';
import 'package:emart/_pideky/presentation/my_payments/view/my_payments.dart';
import 'package:emart/shared/widgets/terminos_condiciones.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/bannners_controller.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/modelos/fabricante.dart';
import 'package:emart/src/pages/catalogo/widgets/tab_categorias_opciones.dart';
import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/pages/principal_page/widgets/custom_buscador_fuzzy.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class NotificationsSlideUpAndPushInUpControllers extends GetxController {
  final notificacionesService =
      NotificationPushInAppSlideUpUseCases(NotificationPushInUpAndSlideUpSql());

  final marcaService = BrandUseCases(MarcaRepositorySqlite());

  final prefs = Preferencias();
  final bannerController = Get.put(BannnerControllers());
  final MyBusinessVieModel viewModel = Get.find<MyBusinessVieModel>();
  RxBool onTapPushInUp = false.obs;
  RxBool closePushInUp = false.obs;
  RxBool closeSlideUp = false.obs;
  RxList listSlideUpHome = [].obs;
  RxList listSlideUpProveedores = [].obs;
  RxList listSlideUpMarcas = [].obs;
  RxList listSlideUpCategorias = [].obs;
  NotificationPushInAppSlideUpModel? cartSlideUP;
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
            await Future.delayed(Duration(milliseconds: 300),
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
            await Future.delayed(Duration(milliseconds: 300),
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
            await Future.delayed(Duration(milliseconds: 300),
                () => showSlideUpNotification(context, notificationTemp, ""));
          }
        }
        break;
      default:
    }
  }

  Future<dynamic> showPushInUp(
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
            return true;
          }
        }
        return false;
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
            return true;
          }
        }
        return false;
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
            return true;
          }
        }
        return false;
      default:
        return false;
    }
  }

  Future validarRedireccionOnTap(
      NotificationPushInAppSlideUpModel notificacion,
      BuildContext context,
      CartViewModel provider,
      CambioEstadoProductos cargoConfirmar,
      Preferencias prefs,
      String location,
      bool isPushInUp) async {
    ProductoService productService =
        ProductoService(ProductoRepositorySqlite());
    final providerBottomNavigationBar =
        Provider.of<OpcionesBard>(context, listen: false);
    if (notificacion.redireccion == "") {
      return;
    } else if (notificacion.redireccion == 'Contenido WEB') {
      await launchUrl(notificacion.contenidoWeb);
      Get.back();
      return;
    } else {
      var resBusqueda;
      if (notificacion.redireccion == 'Detalle Producto') {
        resBusqueda = await productService.cargarProductosFiltro(
            notificacion.subCategoriaRedireccion.toString(), "");
        _detalleProducto(
            resBusqueda[0], provider, context, cargoConfirmar, prefs);
      } else if (notificacion.redireccion == 'Categoría') {
        resBusqueda = await DBProvider.db.consultarCategorias(
            notificacion.categoriaRedireccion.toString(), 1);
        var resSubBusqueda = await DBProvider.db
            .consultarCategoriasSubCategorias(resBusqueda[0].codigo);
        _direccionarCategoria(context, provider, resSubBusqueda,
            notificacion.subCategoriaRedireccion.toString());
      } else if (notificacion.redireccion == 'Proveedor') {
        resBusqueda = await DBProvider.db.consultarFabricante(
            notificacion.subCategoriaRedireccion.toString());
        _direccionarProveedor(context, resBusqueda[0]);
      } else if (notificacion.redireccion == 'Marca') {
        resBusqueda = await marcaService
            .consultaMarcas(notificacion.subCategoriaRedireccion.toString());
        _direccionarMarca(context, resBusqueda[0]);
      } else if (notificacion.redireccion == 'Formulario') {
        Get.back();
        Get.to(() => CustomersProspectionPage());

      } else if (notificacion.redireccion == 'Formulario Sura') {
        Get.back();
        Get.to(() => CustomersProspectionSuraPage());

      } 
      else if (notificacion.redireccion == "Términos y condiciones") {
        if (location == 'Home') {
          viewModel.terminosDatosPdf != null
              ? verTerminosCondiciones(
                  context, viewModel.terminosDatosPdf, isPushInUp)
              : Get.back();
        } else {
          await _navegacionPushInUp();
          viewModel.terminosDatosPdf != null
              ? verTerminosCondiciones(
                  context, viewModel.terminosDatosPdf, isPushInUp)
              : Get.back();
        }
      } else if (notificacion.redireccion == "Mi Negocio") {
        if (location == "Home") {
          Get.back();
          providerBottomNavigationBar.selectOptionMenu = 4;
        } else {
          isPushInUp == true
              ? {
                  Navigator.of(context).pop(),
                  Navigator.of(context).pop(),
                  providerBottomNavigationBar.selectOptionMenu = 4,
                }
              : {
                  Navigator.of(context).pop(),
                  providerBottomNavigationBar.selectOptionMenu = 4,
                };
        }
      } else if (notificacion.redireccion == "Mis pagos Nequi") {
        if (location == "Home") {
          await Get.to(() => MypaymentsPage());
          Get.back();
        } else {
          Navigator.of(context).pop();
          await Get.to(() => MypaymentsPage());
          Get.back();
        }
      } else if (notificacion.redireccion == "Club de ganadores") {
        if (location == "Home") {
          await Get.to(() => WinnersClubPage());
          Get.back();
        } else {
          isPushInUp == true
              ? {
                  Navigator.of(context).pop(),
                  Navigator.of(context).pop(),
                  Get.to(() => WinnersClubPage())
                }
              : {Navigator.of(context).pop(), Get.to(() => WinnersClubPage())};
        }
      } else  {
        Get.back();
      }
    }
  }

  Future launchUrl(url) async {
    try {
      await launch(
        url,
      );
    } catch (e) {
      return e;
    }
  }

  Future<void> _navegacionPushInUp() async {
    Get.back();
  }

  _direccionarCategoria(BuildContext context, CartViewModel provider,
      List<dynamic> resSubBusqueda, String subCategoria) async {
    if (subCategoria != '') {
      bannerController.setIsVisitBanner(true);
      bannerController.cambiarSubCategoria(resSubBusqueda.indexWhere(
          (element) =>
              element.descripcion.toLowerCase() == subCategoria.toLowerCase()));
    }

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TabOpcionesCategorias(
                  listaCategorias: resSubBusqueda,
                  nombreCategoria: subCategoria,
                )));
    Get.back();
  }

  _direccionarMarca(
    BuildContext context,
    Brand marca,
  ) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomBuscardorFuzzy(
                  codCategoria: marca.codigo,
                  numEmpresa: 'nutresa',
                  tipoCategoria: 3,
                  nombreCategoria: marca.nombre,
                  locacionFiltro: "marca",
                  codigoProveedor: "",
                )));
    Get.back();
  }

  _direccionarProveedor(
    BuildContext context,
    Fabricante proveedor,
  ) async {
    await Navigator.push(
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
    Get.back();
  }

  _detalleProducto(
      Product producto,
      final CartViewModel cartProvider,
      BuildContext context,
      CambioEstadoProductos cargoConfirmar,
      Preferencias prefs) async {
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

      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CambiarDetalleCompra(
                    cambioVista: 1, isByBuySellEarn: false,
                  )));
      Get.back();
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

  getSlideUpByDataBaseCart(String ubicacion, context) async {
    if (await Get.put(NotificationPushInAppSlideUpUseCases(NotificationPushInUpAndSlideUpSql()))
        .showSlideUpCart()) {
      var listSlideUpsTemp =
          await notificacionesService.consultNotificationsSlideUp(ubicacion);

      if (listSlideUpsTemp.isNotEmpty) {
        cartSlideUP = listSlideUpsTemp.first;
        showSlideUpNotification(context, cartSlideUP, 'Carrito');
      } else {
        cartSlideUP = null;
      }
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

  void validacionGeneralNotificaciones(context) async {
    EncuestaControllers encuestaControllers = Get.find<EncuestaControllers>();
    final slideUpAutomatic = Get.find<SlideUpAutomatic>();
    bool hayEncuestasObligatorias = await encuestaControllers.consultSurveys();

    if (!hayEncuestasObligatorias) {
      await slideUpAutomatic.getAutomaticSlideUp();
      closePushInUp.value = false;
      onTapPushInUp.value = false;
      await getPushInUpByDataBaseHome("Home");
      if (validacionMostrarPushInUp["Home"] == true &&
          listPushInUpHome.isNotEmpty) {
        await showPushInUps(context);
        int elapsedTime = 0;
        Timer.periodic(Duration(seconds: 1), (timer) {
          if (elapsedTime >= listPushInUpHome.first.tiempo) {
            showSlideUps(context);
            slideUpAutomatic.validarMostrarSlide(context);
            timer.cancel();
          } else if (closePushInUp.value == true) {
            showSlideUps(context);
            slideUpAutomatic.validarMostrarSlide(context);
            timer.cancel();
          } else if (onTapPushInUp.value == true) {
            timer.cancel();
          }
          elapsedTime++;
        });
      } else if (validacionMostrarSlideUp["Home"] == true &&
          closeSlideUp.value == false) {
        showSlideUps(context);
        slideUpAutomatic.validarMostrarSlide(context);
      }
    }
  }

  Future<void> showPushInUps(context) async {
    //await controllerNotificaciones.getPushInUpByDataBaseHome("Home");
    if (listPushInUpHome.isNotEmpty) {
      closePushInUp.value = false;
      onTapPushInUp.value = false;
      validacionMostrarPushInUp["Home"] = false;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(
                onWillPop: () async => false,
                child: NotificationPushInApp(listPushInUpHome.first, "Home"));
          });
    }
  }

  void showSlideUps(context) async {
    await getSlideUpByDataBaseHome("Home");
    if (listSlideUpHome.isNotEmpty) {
      closeSlideUp.value = true;
      validacionMostrarSlideUp["Home"] = false;
      await Future.delayed(
          Duration(milliseconds: 100),
          () =>
              showSlideUpNotification(context, listSlideUpHome.first, "Home"));
    }
  }
}
