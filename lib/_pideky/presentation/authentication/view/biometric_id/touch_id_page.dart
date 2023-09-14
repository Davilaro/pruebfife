import 'package:emart/generated/l10n.dart';
import 'package:emart/src/controllers/validations_forms.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:local_auth/local_auth.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../../../../shared/widgets/boton_agregar_carrito.dart';
import '../../../../../shared/widgets/popups.dart';
import '../../../../../src/preferences/cont_colores.dart';

class TouchIdPage extends StatefulWidget {
  const TouchIdPage();

  @override
  State<TouchIdPage> createState() => _TouchIdPageState();
}

class _TouchIdPageState extends State<TouchIdPage> {
  // bool authenticated = false;

  final LocalAuthentication auth = LocalAuthentication();
  final prefs = Preferencias();
  final validationForm = Get.find<ValidationForms>();

  @override
  Widget build(BuildContext context) {
    final progress = ProgressDialog(context);
    progress.style(
        message: S.current.logging_in,
        progressWidget: Image(
          image: AssetImage('assets/image/jar-loading.gif'),
          fit: BoxFit.cover,
          height: 20,
        ));
    return Scaffold(
        backgroundColor: ConstantesColores.color_fondo_gris,
        body: Container(
            padding: EdgeInsets.only(top: 150, left: 30, right: 30),
            child: Column(children: [
              Container(
                  child: Image(
                image: AssetImage('assets/image/Icon_touch_ID.png'),
                fit: BoxFit.contain,
              )),
              SizedBox(height: 50),
              Text('Touch ID',
                  style: TextStyle(
                      color: HexColor("#41398D"),
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 15.0),
              Text(
                  "Para ingresar más rápido la próxima vez puedes configurar tu huella",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ConstantesColores.gris_sku,
                    fontSize: 15,
                  )),
              SizedBox(height: 25.0),
              BotonAgregarCarrito(
                borderRadio: 35,
                height: Get.height * 0.06,
                color: ConstantesColores.empodio_verde,
                onTap: () async {
                  await _getAvaliableBiometrics(); // () async {
                  await _authenticate(context, progress);
                },
                text: "Usar Touch ID",
              ),
              TextButton(
                  onPressed: () async {
                    prefs.isDataBiometricActive = false;
                    await progress.show();
                    await validationForm.login(
                        context, validationForm.userName.value, progress, false);
                    //Get.back();
                  },
                  child: Text('Cancelar',
                      style: TextStyle(
                          fontFamily: 'RoundedMplus1c',
                          color: HexColor("#41398D"),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)))
            ])));
  }

  Future<void> _authenticate(context, progress) async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason:
            'Por favor pon tu huella para ingresar a la aplicación.',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (authenticated) {
        prefs.isDataBiometricActive = true;
        prefs.ccupBiometric = validationForm.userName.value;
        await progress.show();
        await validationForm.login(
            context, validationForm.userName.value, progress, true);
        await showPopup(context, 'Touch ID activado',
            SvgPicture.asset('assets/image/Icon_correcto.svg'));
      }

      print('Authenticated : $authenticated');
    } on PlatformException catch (e) {
      showPopupUnrecognizedfingerprint(
          context,
          'Huella no reconocida',
          Image(
            image: AssetImage('assets/image/Icon_touch_ID.png'),
            fit: BoxFit.contain,
          ));
      print(e);
    }
  }

  Future<void> _getAvaliableBiometrics() async {
    List<BiometricType> avaliableBiometrics =
        await auth.getAvailableBiometrics();

    print('List of availableBiometrics : $avaliableBiometrics');

    if (!mounted) {
      return;
    }
  }
}
