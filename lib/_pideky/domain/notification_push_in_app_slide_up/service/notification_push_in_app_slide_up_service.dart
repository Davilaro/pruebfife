import 'package:emart/_pideky/domain/notification_push_in_app_slide_up/interface/i_notification_push_in_app_slide_up_repository.dart';
import 'package:emart/_pideky/domain/notification_push_in_app_slide_up/model/notification_push_in_app_slide_up.dart';

class NotificationPushInAppSlideUpService {
  final INotificationPushInAppRepository notificationPushInAppRepository;

  NotificationPushInAppSlideUpService(this.notificationPushInAppRepository);

  Future<List<NotificationPushInAppSlideUpp>> consultNotificationsSlideUp() {
    return notificationPushInAppRepository.consultNotificationsSlideUp();
  }

  Future<List<NotificationPushInAppSlideUpp>> consultNotificationPushInApp() {
    return notificationPushInAppRepository.consultNotificationPushInApp();
  }
}
