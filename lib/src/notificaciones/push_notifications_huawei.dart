// ignore_for_file: cancel_subscriptions

import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:huawei_push/huawei_push.dart';

class PushNotificationsHuawei {
  String _token = '';

  String get token => _token;

  String obtainToken() {
    Push.getTokenStream.listen(_onTokenEvent, onError: _onErrorToken);
    return _token;
  }

  void _onTokenEvent(String event) {
    log('[token-huawei] $_token');
    pushLocalNoti();
  }

  void _onErrorToken(Object error) {
    PlatformException e = error as PlatformException;
    log('error en notificaciones de huawei $e');
  }

  pushLocalNoti() async {
    try {
      await Push.localNotification({
        HMSLocalNotificationAttr.TITLE: "Pideky",
        HMSLocalNotificationAttr.MESSAGE: "Pideky"
      });
    } catch (e) {
      print('Error notifiaciones huawei $e');
    }
  }

  void _onNotificationOpenedApp(dynamic event) {
    if (event != null) {
      log('[onnotificationOpenedApp]' + event.toString());
    }
  }

  void _onMessageRecived(RemoteMessage remoteMessage) async {
    String? data = remoteMessage.data;
    if (data != null) {
      await Push.localNotification({
        HMSLocalNotificationAttr.TITLE: "Pideky",
        HMSLocalNotificationAttr.MESSAGE: data
      });
    }
  }

  static backgroundMessageCallBack(RemoteMessage message) async {
    String? data = message.data;
    if (data != null) {
      await Push.localNotification({
        HMSLocalNotificationAttr.TITLE: "Pideky",
        HMSLocalNotificationAttr.MESSAGE: data
      });
    }
  }

  Future<void> initPlatformStateHuawei() async {
    final token =
        Push.getTokenStream.listen(_onTokenEvent, onError: _onErrorToken);
    Push.onNotificationOpenedApp.listen(_onNotificationOpenedApp);
    var initialNotification = await Push.getInitialNotification();
    _onNotificationOpenedApp(initialNotification);
    Push.onMessageReceivedStream.listen(_onMessageRecived);
    Push.getRemoteMsgSendStatusStream;
    bool backGroundMessageHandler =
        await Push.registerBackgroundMessageHandler(backgroundMessageCallBack);
    Push.getToken('');

    token.onData((data) {
      _token = data;
    });

    log('backgroundMessageHandler registered $backGroundMessageHandler');
  }
}

PushNotificationsHuawei pushNotificationsHuawei = PushNotificationsHuawei();
