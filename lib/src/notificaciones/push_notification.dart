//no borrar
//SHA1:  90:3F:45:0A:17:48:B8:5C:AA:01:5A:00:9B:95:C6:03:D5:22:0C:C0

import 'dart:convert';
import 'dart:io';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:emart/src/notificaciones/message_notification.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final prefs = new Preferencias();

class PushNotificationServer {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static String? token;

  static Future<void> _backgroundHandler(RemoteMessage message) async {
    print('hola res ${message.data['message']}');
    var hola = jsonDecode(message.data['message']);
    print('hola res 33 ${hola.title}');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    var title = message.notification?.title;
    var body = message.notification?.body;

    showOverlayNotification((context) {
      Widget notificacion = Html(data: """${body!}""");
      Widget titleNotificacion = Html(data: """${title!}""");
      return MessageNotification(
          key: Key("1"),
          message: notificacion,
          title: titleNotificacion,
          onReplay: () {
            OverlaySupportEntry.of(context)
                ?.dismiss(); //use OverlaySupportEntry to dismiss overlay
            toast('Notificación cerrada');
          });
    }, duration: Duration(seconds: 10));
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    await Firebase.initializeApp();
    await requesPermission();
    Widget notificacion = Html(data: """${message.notification!.body}""");
    showSimpleNotification(notificacion);
  }

  void setPushNotificationToken(String pushToken) {}

  static Future initializeApp() async {
    try {
      await Firebase.initializeApp();
      FirebaseMessaging _messaging = FirebaseMessaging.instance;
      await requesPermission();
      String? token2 = '';
      token = await FirebaseMessaging.instance.getToken();
      if (Platform.isIOS) {
        token2 = await FirebaseMessaging.instance.getAPNSToken();
        FlutterUxcam.setPushNotificationToken(token2!);
      } else {
        FlutterUxcam.setPushNotificationToken(token!);
      }

      print('token $token ---- $token2');

      //handlers
      FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
      FirebaseMessaging.onMessage.listen(_onMessageHandler);
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
    } catch (e) {
      print('ERROR NOTIFICAICONES $e');
    }
  }

  //apple // web permisos de notificacion
  static requesPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    settings.authorizationStatus == AuthorizationStatus.authorized
        ? print('hola User granted permission')
        : print('hola User declined or has not accepted permission');
  }
}
