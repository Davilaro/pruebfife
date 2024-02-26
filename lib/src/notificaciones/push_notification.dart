//no borrar
//SHA1:  90:3F:45:0A:17:48:B8:5C:AA:01:5A:00:9B:95:C6:03:D5:22:0C:C0

import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:emart/src/notificaciones/push_notifications_huawei.dart';
import 'package:flutter_hms_gms_availability/flutter_hms_gms_availability.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:huawei_push/huawei_push.dart' as huawei;
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
    await Firebase.initializeApp();
    print('notificacion ${message.data['type']}');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    String? title = message.notification?.title;
    String? body = message.notification?.body;

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
    String? title = message.notification?.title;
    String? body = message.notification?.body;

    showOverlayNotification((context) {
      Widget titleNotificacion = Html(data: """${title!}""");
      Widget notificacion = Html(data: """${body!}""");

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

  void setPushNotificationToken(String pushToken) {}

  static Future initializeApp() async {
    String vendor = '';
    try {
      String? token2 = '';
      if (Platform.isIOS) {
        await Firebase.initializeApp();
        await requesPermission();
        FirebaseMessaging _messaging = FirebaseMessaging.instance;
        token2 = await _messaging.getAPNSToken();
        token = token2;

        FlutterUxcam.setPushNotificationToken(token2!);
      } else {
        DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        String version = androidInfo.manufacturer;
        vendor = version.toString().toUpperCase();
        if (vendor != 'HUAWEI') {
          await Firebase.initializeApp();
          await requesPermission();
          FirebaseMessaging _messaging = FirebaseMessaging.instance;
          token = await _messaging.getToken();
          FlutterUxcam.setPushNotificationToken(token!);
        } else {
          bool isGmsAvailable = await FlutterHmsGmsAvailability.isGmsAvailable;
          if (isGmsAvailable == true) {
            log('Iniciando servicios de HUAWEI/GOOGLE');
            await Firebase.initializeApp();
            await requesPermission();
            FirebaseMessaging _messaging = FirebaseMessaging.instance;
            token = await _messaging.getToken();
            FlutterUxcam.setPushNotificationToken(token!);
          } else {
            log('Iniciando servicios de HUAWEI');
             huawei.Push.enableLogger();
             await pushNotificationsHuawei.initPlatformStateHuawei();
          }
        }
      }

      if (vendor != 'HUAWEI') {
        print('token $token ---- $token2');

        //handlers
        FirebaseMessaging.onMessage.listen(_onMessageHandler);
        FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
        FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
      }
    } catch (e) {
      print('---ERROR NOTIFICAICONES $e');
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
        ? print('User granted permission')
        : print('User declined or has not accepted permission');
  }
}
