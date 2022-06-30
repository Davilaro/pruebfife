import 'dart:io';

import 'package:emart/src/provider/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

void mostrarAlertaUtils(BuildContext context, String mensaje, String titulo) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK')),
          ],
        );
      });
}

void mostrarAlertaUtilsEnvio(
    BuildContext context, String mensaje, String titulo) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
                child: Text('OK')),
          ],
        );
      });
}

void mostrarAlertaUtilsRegistro(
    BuildContext context, String mensaje, String titulo) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content:
              Text(mensaje == null ? 'Registro exitoso en servidor' : mensaje),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context, true);
                },
                child: Text('OK')),
          ],
        );
      });
}

Future<String> get iosPaht async {
  Directory appDocDirectory = await getApplicationDocumentsDirectory();
  return appDocDirectory.path + '/';
}

Future<String> get androidPaht async {
  Directory appDocDirectory = await getApplicationDocumentsDirectory();
  return appDocDirectory.path + '/';
}

void mostrarAlertaSalir(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Advertencia'),
          content: Text(
              'Está seguro de salir del modulo? la información se perdera!'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
                child: Text('Aceptar')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancelar')),
          ],
        );
      });
}

void validarVersionActual(BuildContext context) async {
  String typeOS = Platform.isAndroid ? 'ANDROID' : 'IPHONE';
  String versionLocal = await cargarVersion();
  String versionServer = await DBProvider.db.consultarVersion(typeOS);
  int obligatorio = await DBProvider.db.consultarVersionObligatoria();
  String appPackageName = await obtenerPackageName();
  if (versionLocal != null && versionServer != null) {
    double vrLocal = toDouble(versionLocal.replaceAll(".", ""));
    double vrServer = toDouble(versionServer.replaceAll(".", ""));

    if (vrLocal < vrServer) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return WillPopScope(
              onWillPop: () => Future.value(false),
              child: AlertDialog(
                title: Text('Actualiza'),
                content: Text(obligatorio == 1
                    ? 'Hay una nueva versión  con cambios importantes, es necesario actualizar'
                    : 'Hay una nueva versión, desea actualizar?'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        // Navigator.of(context).pop();
                        try {
                          launch("market://details?id=" + appPackageName);
                        } on PlatformException catch (e) {
                          if (Platform.isAndroid) {
                            launch(
                                "https://play.google.com/store/apps/details?id=" +
                                    appPackageName);
                          } else {
                            launch(
                                "https://apps.apple.com/co/app/pideky/id1593480925");
                          }
                        } finally {
                          if (Platform.isAndroid) {
                            launch(
                                "https://play.google.com/store/apps/details?id=" +
                                    appPackageName);
                          } else {
                            launch(
                                "https://apps.apple.com/co/app/pideky/id1593480925");
                          }
                        }
                      },
                      child: Text('Actualizar',
                          style: TextStyle(color: Colors.black))),
                ],
              ),
            );
          });
    }
  }
}

Future<String> cargarVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;

  return version;
}

Future<String> obtenerPackageName() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.packageName;
  return version;
}

int toInt(String value) {
  try {
    return int.parse(value);
  } catch (e) {
    return 0;
  }
}

double toDouble(String value) {
  try {
    return double.parse(value);
  } catch (e) {
    return 0.0;
  }
}
