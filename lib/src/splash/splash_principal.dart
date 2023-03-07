import 'dart:async';
import 'dart:io';

import 'package:emart/_pideky/presentation/confirmacion_pais/view/confirmacion_pais.dart';
import 'package:emart/_pideky/presentation/pedido_sugerido/view_model/pedido_sugerido_controller.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/pages/principal_page/tab_opciones.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/crear_file.dart';
import 'package:emart/src/provider/servicios.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
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
    Future.delayed(Duration(milliseconds: 1000), () {
      executeAfterBuild(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    //UXCAM: Se define el nombre de la interfaz
    FlutterUxcam.tagScreenName('LogoPidekyPage');
    return Scaffold(
      body: Center(
          child: Image.asset(
        'assets/image/splash.png',
        fit: BoxFit.cover,
      )),
    );
  }

  void executeAfterBuild(context) {
    _descarcarDB();
  }

  Future<void> _descarcarDB() async {
    var cargo = false;
    if (prefs.usurioLogin == null || prefs.paisUsuario == null) {
      cargo =
          await AppUtil.appUtil.downloadZip('1006120026', prefs.sucursal, true);
      var res = await AppUtil.appUtil.abrirBases();
      prefs.usurioLogin = -1;
      if (res && cargo) {
        Get.off(() => ConfirmacionPais());
      }
    } else if (prefs.usurioLogin == -1) {
      cargo =
          await AppUtil.appUtil.downloadZip('1006120026', prefs.sucursal, true);
      var res = await AppUtil.appUtil.abrirBases();

      if (res && cargo) {
        S.load(prefs.paisUsuario == 'CR'
            ? Locale('es', prefs.paisUsuario)
            : prefs.paisUsuario == 'CO'
                ? Locale('es', 'CO')
                : Locale('es', 'CO'));
        Get.off(() => TabOpciones());
      }
    } else {
      final List<dynamic> divace = await Login.getDeviceDetails();

      String plataforma = Platform.isAndroid ? 'Android' : 'Ios';

      await Servicies()
          .registrarToken(divace[2], plataforma, prefs.usurioLoginCedula);

      cargo = await AppUtil.appUtil
          .downloadZip(prefs.usurioLoginCedula, prefs.sucursal, false);
      var res = await AppUtil.appUtil.abrirBases();
      prefs.usurioLogin = 1;
      PedidoSugeridoController.userLog.value = 1;
      if (res && cargo) {
        if (prefs.usurioLogin == 1) {
          S.load(prefs.paisUsuario == 'CR'
              ? Locale('es', prefs.paisUsuario)
              : prefs.paisUsuario == 'CO'
                  ? Locale('es', 'CO')
                  : Locale('es', 'CO'));
          UxcamTagueo().validarTipoUsuario();
        }

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
