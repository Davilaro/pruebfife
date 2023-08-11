import 'package:emart/_pideky/domain/notification_push_in_app_slide_up/service/notification_push_in_app_slide_up_service.dart';
import 'package:emart/_pideky/infrastructure/notification_push_in_app_slide_up/notification_push_in_app_slide_up_sql.dart';
import 'package:get/get.dart';

class NotificationsSlideUpAndPushInUpControllers extends GetxController {
  final notificacionesService =
      NotificationPushInAppSlideUpService(NotificationPushInUpAndSlideUpSql());

  RxList<dynamic> _listSlideUps = [].obs;
  RxList<dynamic> _listPushInUp = [].obs;

  get listSlideUps => _listSlideUps;
  get listPushInUp => _listPushInUp;

  getSlideUpAndPushInUpByDataBase() async {
    var listSlideUpsTemp =
        await notificacionesService.consultNotificationsSlideUp();
    // var listPushInUpsTemp =
    //     await notificacionesService.consultNotificationPushInApp();

    _listSlideUps.assignAll(listSlideUpsTemp);
    // _listPushInUp.assignAll(listPushInUpsTemp);
    _listSlideUps.forEach((element) => print("lista ${element.ubicacion}"));
    print("lista slide ${_listSlideUps.length}");
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
