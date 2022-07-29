import 'dart:async';
import 'dart:io';

import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/pages/principal_page/tab_opciones.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/crear_file.dart';
import 'package:emart/src/provider/servicios.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final prefs = new Preferencias();

  @override
  void initState() {
    super.initState();
    //UXCAM: Se define el nombre de la interfaz
    FlutterUxcam.tagScreenName('LogoPidekyPage');
    Future.delayed(Duration(milliseconds: 1000), () {
      executeAfterBuild(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //   future: _descarcarDB(),
    //   builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
    //     if (snapshot.hasData) {
    //       return TabOpciones();
    //     } else {
    //       return Center(
    //           child: Image.asset(
    //         'assets/splash.png',
    //         fit: BoxFit.cover,
    //       ));
    //     }
    //   },
    // );
    return Scaffold(
      body: Center(
          child: Image.asset(
        'assets/splash.png',
        fit: BoxFit.cover,
      )),
    );
  }

  void executeAfterBuild(context) {
    _descarcarDB();
  }

  Future<void> _descarcarDB() async {
    var cargo = false;
    if (prefs.usurioLogin == null) {
      cargo = await AppUtil.appUtil.downloadZip('1006120026', prefs.codCliente,
          '10360653', '10426885', '10847893', '', true);
      var res = await AppUtil.appUtil.abrirBases();
      prefs.usurioLogin = -1;
      if (res && cargo) {
        Get.off(() => TabOpciones());
      }
    } else if (prefs.usurioLogin == -1) {
      cargo = await AppUtil.appUtil.downloadZip('1006120026', prefs.codCliente,
          '10360653', '10426885', '10847893', '', true);

      var res = await AppUtil.appUtil.abrirBases();
      prefs.usurioLogin = -1;
      if (res && cargo) {
        Navigator.pushReplacementNamed(
          context,
          'tab_opciones',
        );
      }
    } else {
      final List<dynamic> divace = await Login.getDeviceDetails();

      String plataforma = Platform.isAndroid ? 'Android' : 'Ios';

      await Servicies()
          .registrarToken(divace[2], plataforma, prefs.usurioLoginCedula);
      cargo = await AppUtil.appUtil.downloadZip(
          prefs.usurioLoginCedula,
          prefs.codCliente,
          prefs.codigonutresa,
          prefs.codigozenu,
          prefs.codigomeals,
          prefs.codigopadrepideky,
          false);
      var res = await AppUtil.appUtil.abrirBases();
      prefs.usurioLogin = 1;
      if (res && cargo) {
        Navigator.pushReplacementNamed(
          context,
          'tab_opciones',
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
