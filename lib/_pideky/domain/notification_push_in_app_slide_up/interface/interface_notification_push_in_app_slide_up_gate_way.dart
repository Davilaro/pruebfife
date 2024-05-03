import 'package:emart/_pideky/domain/notification_push_in_app_slide_up/model/notification_push_in_app_slide_up.dart';

abstract class InterfaceNotificationPushInAppSlideUpGateWay {
  Future<List<NotificationPushInAppSlideUpModel>> consultNotificationsSlideUp(
      String ubicacion);
  Future<List<NotificationPushInAppSlideUpModel>> consultNotificationPushInApp(
      String ubicacion);
  Future<List<NotificationPushInAppSlideUpModel>> getAutomaticSlideUp();
  Future<int> showSlideUpValidation(String negocio);
  Future<dynamic> sendShowedSlideUp(String negocio);
  Future<bool> showSlideUpCart();

}
