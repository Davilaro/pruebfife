import 'package:emart/_pideky/domain/notification_push_in_app_slide_up/service/notification_push_in_app_slide_up_service.dart';
import 'package:emart/_pideky/infrastructure/notification_push_in_app_slide_up/notification_push_in_app_slide_up_sql.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:get/get.dart';

class NotificationsSlideUpAndPushInUpControllers extends GetxController {
  final notificacionesService =
      NotificationPushInAppSlideUpService(NotificationPushInUpAndSlideUpSql());

  final prefs = Preferencias();
  RxList listSlideUpHome = [].obs;
  RxList listSlideUpProveedores = [].obs;
  RxList listSlideUpMarcas = [].obs;
  RxList listSlideUpHomeCategorias = [].obs;
  RxList listPushInUpHome = [].obs;
  RxList listPushInUpProveedores = [].obs;
  RxList listPushInUpMarcas = [].obs;
  RxList listPushInUpCategorias = [].obs;

  getSlideUpByDataBaseHome(String ubicacion) async {
    var listSlideUpsTemp =
        await notificacionesService.consultNotificationsSlideUp(ubicacion);

    if (listSlideUpsTemp.isNotEmpty) {
      listSlideUpHome.assignAll(listSlideUpsTemp);
    }
  }

  getSlideUpByDataBaseProveedores(String ubicacion) async {
    var listSlideUpsTemp =
        await notificacionesService.consultNotificationsSlideUp(ubicacion);

    if (listSlideUpsTemp.isNotEmpty) {
      listSlideUpProveedores.assignAll(listSlideUpsTemp);
    }
  }

  getSlideUpByDataBaseMarcas(String ubicacion) async {
    var listSlideUpsTemp =
        await notificacionesService.consultNotificationsSlideUp(ubicacion);

    if (listSlideUpsTemp.isNotEmpty) {
      listSlideUpMarcas.assignAll(listSlideUpsTemp);
    }
  }

  getSlideUpByDataBaseCategorias(String ubicacion) async {
    var listSlideUpsTemp =
        await notificacionesService.consultNotificationsSlideUp(ubicacion);

    if (listSlideUpsTemp.isNotEmpty) {
      listSlideUpHomeCategorias.assignAll(listSlideUpsTemp);
    }
  }

  getPushInUpByDataBaseHome(String ubicacion) async {
    var listPushInUpsTemp =
        await notificacionesService.consultNotificationPushInApp(ubicacion);
    if (listPushInUpsTemp.isNotEmpty) {
      listPushInUpHome.assignAll(listPushInUpsTemp);
    }
  }

  getPushInUpByDataBaseProveedores(String ubicacion) async {
    var listPushInUpsTemp =
        await notificacionesService.consultNotificationPushInApp(ubicacion);
    if (listPushInUpsTemp.isNotEmpty) {
      listPushInUpProveedores.assignAll(listPushInUpsTemp);
    }
  }

  getPushInUpByDataBaseMarcas(String ubicacion) async {
    var listPushInUpsTemp =
        await notificacionesService.consultNotificationPushInApp(ubicacion);
    if (listPushInUpsTemp.isNotEmpty) {
      listPushInUpMarcas.assignAll(listPushInUpsTemp);
    }
  }

  getPushInUpByDataBaseCategorias(String ubicacion) async {
    var listPushInUpsTemp =
        await notificacionesService.consultNotificationPushInApp(ubicacion);
    if (listPushInUpsTemp.isNotEmpty) {
      listPushInUpCategorias.assignAll(listPushInUpsTemp);
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
