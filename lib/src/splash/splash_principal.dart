import 'dart:async';
import 'package:emart/_pideky/presentation/country_confirmation/view/country_confirmation_page.dart';
import 'package:emart/_pideky/presentation/my_payments/view_model/my_payments_view_model.dart';
import 'package:emart/_pideky/presentation/suggested_order/view_model/suggested_order_view_model.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/src/controllers/validations_forms.dart';
import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/pages/principal_page/tab_opciones.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/crear_file.dart';
import 'package:emart/src/provider/servicios.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:emart/src/utils/alertas.dart' as alert;
import 'package:local_auth/local_auth.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final viewModelPedidoSugerido = Get.find<SuggestedOrderViewModel>();
  final viewModelNequi = Get.find<MyPaymentsViewModel>();
  final validationForms = Get.find<ValidationForms>();
  final prefs = new Preferencias();
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then((bool isSupported) => setState(() {
          validationForms.supportState.value = isSupported;
        }));
    WidgetsBinding.instance
        .addPostFrameCallback((_) => executeAfterBuild(context));
  }

  @override
  Widget build(BuildContext context) {
    contextPrincipal = context;
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

  void executeAfterBuild(context) async {
    await _descarcarDB();
  }

  Future<void> _descarcarDB() async {
    var cargo = false;
    if (prefs.usurioLogin == null ||
        prefs.paisUsuario == null ||
        prefs.sucursal == '00') {
      Get.offAll(() => CountryConfirmationPage());
    } else if (prefs.usurioLogin == -1) {
      var res = false;
      var contador = 0;
      do {
        if (contador > 3) {
          cargo = false;
          break;
        } else {
          cargo = await AppUtil.appUtil
              .downloadZip('1006120026', prefs.sucursal, true);
          contador++;
        }
      } while (!cargo);

      if (!cargo && contador > 3) {
        alert.mostrarAlert(
            context,
            'Fue imposible la conexión a internet, por favor revisa tu conexión e intenta nuevamente',
            null);
      } else {
        res = await AppUtil.appUtil.abrirBases();
        if (res && cargo) {
          S.load(prefs.paisUsuario == 'CR'
              ? Locale('es', prefs.paisUsuario)
              : prefs.paisUsuario == 'CO'
                  ? Locale('es', 'CO')
                  : Locale('es', 'CO'));

          Get.off(() => TabOpciones());
          //  RegisterPage());
          //Login());
        }
      }
    } else {
      final List<dynamic> divace = await Login.getDeviceDetails();

      String plataforma = await Login.getDeviceOS();

      await Servicies()
          .registrarToken(divace[2], plataforma, prefs.codClienteLogueado);
      var contador = 0;
      do {
        if (contador > 3) {
          cargo = false;
          break;
        } else {
          cargo = await AppUtil.appUtil
              .downloadZip(prefs.codigoUnicoPideky, prefs.sucursal, false);
          contador++;
        }
      } while (!cargo);
      if (!cargo && contador > 3) {
        alert.mostrarAlert(
            context,
            'Fue imposible la conexión a internet, por favor revisa tu conexión e intenta nuevamente',
            null);
      } else {
        var res = await AppUtil.appUtil.abrirBases();

        prefs.usurioLogin = 1;
        SuggestedOrderViewModel.userLog.value = 1;
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
          //Get.to(() => TabOpciones());
          viewModelNequi.initData();
          viewModelPedidoSugerido.initController();
        }
      }
    }
  }
}
