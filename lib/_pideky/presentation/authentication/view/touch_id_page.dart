//import 'package:emart/_pideky/infrastructure/authentication/biometrics_local_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../shared/widgets/boton_agregar_carrito.dart';
import '../../../../shared/widgets/popups.dart';
import '../../../../src/preferences/cont_colores.dart';

class TouchIdPage extends StatefulWidget {
  const TouchIdPage();

  @override
  State<TouchIdPage> createState() => _TouchIdPageState();
}

class _TouchIdPageState extends State<TouchIdPage> {
  // bool authenticated = false;

  late final LocalAuthentication auth;
  bool _supporState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) => setState(() {
          _supporState = isSupported;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ConstantesColores.color_fondo_gris,
        body: Container(
            padding: EdgeInsets.only(top: 150, left: 30, right: 30),
            child: Column(children: [
              if (_supporState)
                const Text('This device is supported')
              else
                const Text('This devices is not supported'),
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
                onTap: () {
                  _getAvaliableBiometrics(); // () async {
                  _authenticate();

                  showPopup(context, 'Touch ID activado',
                      SvgPicture.asset('assets/image/Icon_correcto.svg'));

                  showPopupSuccessfulregistration(context);
                  showPopupUnrecognizedfingerprint(context);
                },
                text: "Usar Touch ID",
              ),
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('Cancelar',
                      style: TextStyle(
                          fontFamily: 'RoundedMplus1c',
                          color: HexColor("#41398D"),
                          fontSize: 20,
                          fontWeight: FontWeight.bold)))
            ])));
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason:
            'Suscribe or you will never find any stack overflow answer',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      print('Authenticated : $authenticated');
    } on PlatformException catch (e) {
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
