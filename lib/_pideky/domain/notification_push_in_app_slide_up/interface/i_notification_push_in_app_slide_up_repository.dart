import 'package:emart/_pideky/domain/notification_push_in_app_slide_up/model/notification_push_in_app_slide_up.dart';


abstract class INotificationPushInAppSlideUpRepository {
  Future<List<NotificationPushInAppSlideUpp>> consultNotificationsSlideUp();
  Future<List<NotificationPushInAppSlideUpp>> consultNotificationPushInApp();
}
