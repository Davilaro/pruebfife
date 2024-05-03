import 'package:emart/_pideky/domain/notification_push_in_app_slide_up/interface/interface_notification_push_in_app_slide_up_gate_way.dart';
import 'package:emart/_pideky/domain/notification_push_in_app_slide_up/model/notification_push_in_app_slide_up.dart';

class NotificationPushInAppSlideUpUseCases {
  final InterfaceNotificationPushInAppSlideUpGateWay notificationPushInAppRepository;

  NotificationPushInAppSlideUpUseCases(this.notificationPushInAppRepository);

  Future<List<NotificationPushInAppSlideUpModel>>
      consultNotificationsSlideUp(String ubicacion) {
    return notificationPushInAppRepository.consultNotificationsSlideUp(ubicacion);
  }

  Future<List<NotificationPushInAppSlideUpModel>>
      consultNotificationPushInApp(String ubicacion) {
    return notificationPushInAppRepository.consultNotificationPushInApp(ubicacion);
  }

  Future<List<NotificationPushInAppSlideUpModel>> getAutomaticSlideUp() {
    return notificationPushInAppRepository.getAutomaticSlideUp();
  }

  Future<int> showSlideUpValidation(String negocio) {
    return notificationPushInAppRepository.showSlideUpValidation(negocio);
  }

  Future<dynamic> sendShowedSlideUp(String negocio) {
    return notificationPushInAppRepository.sendShowedSlideUp(negocio);
  }
  Future<bool> showSlideUpCart() {
    return notificationPushInAppRepository.showSlideUpCart();
  }
}
