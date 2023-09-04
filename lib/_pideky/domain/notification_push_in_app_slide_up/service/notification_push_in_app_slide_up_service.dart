import 'package:emart/_pideky/domain/notification_push_in_app_slide_up/interface/i_notification_push_in_app_slide_up_repository.dart';
import 'package:emart/_pideky/domain/notification_push_in_app_slide_up/model/notification_push_in_app_slide_up.dart';

class NotificationPushInAppSlideUpService {
  final INotificationPushInAppSlideUpRepository notificationPushInAppRepository;

  NotificationPushInAppSlideUpService(this.notificationPushInAppRepository);

  Future<List<NotificationPushInAppSlideUpModel>>
      consultNotificationsSlideUp(String ubicacion) {
    return notificationPushInAppRepository.consultNotificationsSlideUp(ubicacion);
  }

  Future<List<NotificationPushInAppSlideUpModel>>
      consultNotificationPushInApp(String ubicacion) {
    return notificationPushInAppRepository.consultNotificationPushInApp(ubicacion);
  }
}
