// ignore_for_file: import_of_legacy_library_into_null_safe, unnecessary_null_comparison

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:emart/_pideky/presentation/country_confirmation/view_model/country_confirmation_view_model.dart';
import 'package:emart/_pideky/presentation/suggested_order/view_model/suggested_order_view_model.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/shared/widgets/image_button.dart';
import 'package:emart/src/modelos/screen_arguments.dart';
import 'package:emart/src/modelos/validacion.dart';
import 'package:emart/src/notificaciones/push_notification.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/provider/servicios.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:emart/src/pages/login/widgets/bienvenido.dart';
import 'package:emart/src/utils/colores.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hms_gms_availability/flutter_hms_gms_availability.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:package_info/package_info.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

final TextEditingController _controllerUser = TextEditingController();

late ProgressDialog pr;
late ProgressDialog prValidar;
late ProgressDialog prEnviarCorreo;
late ProgressDialog prEnviarCodigo;
final prefs = new Preferencias();
late BuildContext contextPrincipal;
late bool isChecked = false;
late int codigoRespuesta;

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();

  static Future<List<String>> getDeviceDetails() async {
    String deviceName = '';
    String deviceVersion = '';
    String identifier = '';

    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.release.toString();
        identifier = build.id; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor!; //UUID for iOS
      } 
    } on PlatformException {
      print('Failed to get platform version');
    }

    return [deviceName, deviceVersion, identifier];
  }

  static Future<String> getDeviceOS() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    String operatingSystem = '';
    String vendor = '';
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      operatingSystem = build.manufacturer;
      vendor = build.version.toString().toUpperCase();
      if (vendor != 'HUAWEI') {
        operatingSystem = "Android";
      } else {
        bool isGmsAvailable = await FlutterHmsGmsAvailability.isGmsAvailable;
        if (isGmsAvailable == true) {
          operatingSystem = "Android|Huawei";
        } else {
          operatingSystem = "Huawei";
        }
      }
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      operatingSystem = data.systemVersion;
    }
    return operatingSystem;
  }
}

class _LoginState extends State<Login> {
  String version = '1.2.4';

  @override
  void initState() {
    //UXCAM: Se define el nombre de la interfaz
    FlutterUxcam.tagScreenName('LoginPage');
    _controllerUser.text = '';
    super.initState();
    _cargarVersion();
  }

  @override
  Widget build(BuildContext context) {
    contextPrincipal = context;

    final provider = Provider.of<DatosListas>(context);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: [
            _crearFondo(context),
            _loginForm(context, provider),
          ],
        ),
      ),
    );
  }

  _crearFondo(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: new AssetImage('assets/image/fondo.png'), fit: BoxFit.fill),
      ),
    );
  }

  _loginForm(BuildContext context, DatosListas provider) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 60.0,
            ),
          ),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
            child: Column(
              children: [
                Image(image: AssetImage('assets/image/logo_login.png')),
                SizedBox(
                  height: 80,
                ),
                _campoTexto(context),
                SizedBox(
                  height: 20,
                ),
                _botonLogin(context, provider),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
          Text(
            '${S.current.version} ${Constantes().titulo}: $version',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  _campoTexto(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: HexColor("#E4E3EC"),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _controllerUser,
        keyboardType: TextInputType.number,
        style: TextStyle(color: HexColor("#41398D"), fontSize: 15),
        decoration: InputDecoration(
            fillColor: HexColor("#41398D"),
            hintText: S.current.login_placeholder,
            hintStyle: TextStyle(
              color: HexColor("#41398D"),
            ),
            icon: Icon(
              Icons.perm_identity,
              color: HexColor("#41398D"),
            ),
            border: InputBorder.none),
      ),
    );
  }

  _botonLogin(BuildContext context, DatosListas provider) {
    return ImageButton(
      children: <Widget>[],
      width: 340,
      height: 45,
      paddingTop: 5,
      pressedImage: Image.asset(
        "assets/image/registrar_btn.png",
      ),
      unpressedImage: Image.asset("assets/image/registrar_btn.png"),
      onTap: () => _logicaBoton(context, provider),
    );
  }

  _logicaBoton(BuildContext context, DatosListas provider) async {
    if (_controllerUser.text == '') {
      mostrarAlert(context, S.current.enter_your_nit, null);
    } else {
      //FIREBASE: Llamamos el evento login
      TagueoFirebase().sendAnalitytics(_controllerUser.text);

      final List<dynamic> divace = await Login.getDeviceDetails();

      String plataforma = Platform.isAndroid ? 'Android' : 'Ios';

      prValidar = ProgressDialog(context);
      //message: Validando información
      prValidar.style(message: S.current.validating_information);
      prValidar = ProgressDialog(context,
          type: ProgressDialogType.normal,
          isDismissible: false,
          showLogs: true);

      await prValidar.show();
      await _validarInformacion(
          context, divace[2], plataforma, _controllerUser.text);
      await prValidar.hide();
    }
  }

  _diloagCargando(BuildContext context) async {
    pr = ProgressDialog(context);
    //message: Iniciando sesión
    pr.style(message: S.current.logging_in);
    pr = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: false, showLogs: true);

    await pr.show();
    await loguin(context, _controllerUser.text);
    await pr.hide();
  }

  Future loguin(BuildContext context, String nit) async {
    try {
      List<dynamic> respuesta = await Servicies().getListaSucursales(false);
      respuesta.forEach((element) {
        if (element.bloqueado == "1") {
          Navigator.pushReplacementNamed(context, "inicio_compra");
          return mostrarAlertCustomWidgetOld(
              context, cargarLinkWhatssap(context), null, null);
        }
      });
      prefs.codigoUnicoPideky = respuesta.first.codigoUnicoPideky;

      prefs.codClienteLogueado = nit;
      // ignore: unnecessary_statements
      SuggestedOrderViewModel.userLog.value = 1;

      if (respuesta.length > 0) {
        await pr.hide();
        Navigator.pushReplacementNamed(
          context,
          'listaSucursale',
          arguments: ScreenArguments(
            respuesta,
          ),
        );
      } else {
        await pr.hide();
        mostrarAlertCustomWidgetOld(
            context, cargarLinkWhatssap(context), null, null);
        return false;
      }
    } catch (e) {
      print('Error retorno login $e');
      await pr.hide();
      //message: Error al obtener información
      mostrarAlert(context, S.current.error_information, null);
      return false;
    }
  }

  Widget cargarLinkWhatssap(context) {
    return Column(
      children: [
        //message: El NIT ingresado no se encuentra registrado en nuestra base de datos. Por favor revisa que esté bien escrito o contáctanos en
        Text(
          S.current.the_nit_entered_is_not_registered,
          textAlign: TextAlign.center,
        ),
        GestureDetector(
          onTap: () => lanzarWhatssap(context),
          child: Text(
            S.current.whatsApp, //message: WhatsApp
            textAlign: TextAlign.center,
            style: TextStyle(
              color: HexColor(Colores().color_azul_letra),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  final border = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(
        color: Colors.black,
      ));

  Future _validarInformacion(
      BuildContext context, divace, String plataforma, String text) async {
    final confirmacionViewModel = Get.find<CountryConfirmationViewModel>();
    String? token = PushNotificationServer.token as String;
    Validacion respues =
        await Servicies().validarUsuariNuevo(text, divace, plataforma, token);

    if (respues == null) {
      await prValidar.hide();
      //message: Error al validar el usuario
      mostrarAlert(contextPrincipal, S.current.error_validating_the_user, null);
      return;
    }

    if (respues.codigo == null) {
      await prValidar.hide();
      mostrarAlertCustomWidgetOld(
          context, cargarLinkWhatssap(context), null, null);
    } else if (respues.codigo == -1) {
      await prValidar.hide();
      mostrarAlertCustomWidgetOld(
          context, cargarLinkWhatssap(context), null, null);
    } else if (respues.activo == -1) {
      await prValidar.hide();

      mostrarAlertCustomWidgetOld(
          context, cargarLinkWhatssap(context), null, null);
    } else if (respues.codigo == 0) {
      //message: No se pudo generar el código
      mostrarAlert(context, S.current.code_could_not_be_generated, null);
    } else if (respues.activo == 0) {
      await prValidar.hide();

      codigoRespuesta = respues.codigo;
      prefs.codActivacionLogin = respues.codigo;
      prefs.codClienteLogueado = _controllerUser.text;
      prefs.paisUsuario = respues.pais;
      confirmacionViewModel.confirmarPais(prefs.paisUsuario, true);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Bienvenido(
                  respues: respues,
                  usuario: _controllerUser.text,
                )),
      );
    } else {
      await prValidar.hide();
      _diloagCargando(context);
    }
  }

  void _cargarVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    setState(() {});
  }
}

Future<void> lanzarWhatssap(context) async {
  var lineaSoporte = await DBProviderHelper.db.cargarTelefotosSoporte(3);
  var whatappurlIos =
      "https://wa.me/+${lineaSoporte[1].telefono}?text=${Uri.parse("Hola")}";

  //UXCam: Llamamos el evento selectSoport
  UxcamTagueo().selectSoport('Soporte Whatssap');
  try {
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappurlIos)) {
        await launch(whatappurlIos, forceSafariVC: false);
      } else {
        //message: whatsapp no instalado
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text(S.current.whatsApp_not_installed)));
      }
    } else {
      // android , web
      await launch(
          'https://api.whatsapp.com/send?phone=+${lineaSoporte[1].telefono}');
    }
  } catch (e) {
    print(e);
  }
}
