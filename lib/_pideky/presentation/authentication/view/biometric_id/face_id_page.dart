import 'dart:async';

import 'package:emart/generated/l10n.dart';
import 'package:emart/src/controllers/validations_forms.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:local_auth/local_auth.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import '../../../../../shared/widgets/boton_agregar_carrito.dart';
import '../../../../../shared/widgets/popups.dart';
import '../../../../../src/preferences/cont_colores.dart';

class FaceIdPage extends StatefulWidget {
  const FaceIdPage();

  @override
  State<FaceIdPage> createState() => _FaceIdPageState();
}

class _FaceIdPageState extends State<FaceIdPage> {
  // bool authenticated = false;

  late final LocalAuthentication auth;
  final prefs = Preferencias();
  final validationForm = Get.find<ValidationForms>();

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    
  }

  @override
  Widget build(BuildContext context) {
    final progress = ProgressDialog(context, isDismissible: false);
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
                image: AssetImage('assets/image/Image_face_ID.png'),
                fit: BoxFit.contain,
              )),
              SizedBox(height: 30),
              Text('Face ID',
                  style: TextStyle(
                      color: HexColor("#41398D"),
                      fontSize: 25,
                      fontWeight: FontWeight.w900)),
              SizedBox(height: 15.0),
              Text(
                  "Para ingresar más rápido la próxima vez puedes configurar tu rostro",
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
                text: "Usar Face ID",
              ),
              TextButton(
                  onPressed: () async {
                    prefs.isDataBiometricActive = false;
                    await progress.show();
                    await validationForm.login(
                        context, progress, false);
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
            'Por favor acerca tu rostro para ingresar a la aplicación.',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (authenticated) {
        //Uxcam tagueo, se guardaron datos biometricos del face
        UxcamTagueo().storedFaceBiometricData();
        prefs.isDataBiometricActive = true;
        prefs.ccupBiometric = prefs.codigoUnicoPideky;
        await progress.show();
        await validationForm.login(
            context,  progress, true);
        return;
      }

      print('Authenticated : $authenticated');
    } on PlatformException catch (e) {
      int timeIteration = 0;
      validationForm.isClosePopup.value = false;
      validationForm.isClosePopup.value = false;
      showPopupUnrecognizedfingerprint(
          context,
          "Rostro no reconocido",
          Image(
            image: AssetImage('assets/image/Image_face_ID.png'),
            fit: BoxFit.contain,
          ));
      Timer.periodic(Duration(milliseconds: 500), (timer) {
        if (timeIteration >= 5) {
          timer.cancel();
          Get.back();
        }
        if (validationForm.isClosePopup.value == true) {
          timer.cancel();
        }
        timeIteration++;
      });
      print(e);
      return;
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
