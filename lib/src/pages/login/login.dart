import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:emart/src/modelos/validacion.dart';
import 'package:emart/src/notificaciones/push_notification.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:emart/src/provider/servicios.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:emart/src/pages/login/widgets/bienvenido.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:imagebutton/imagebutton.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

final TextEditingController _controllerUser = TextEditingController();
final TextEditingController _controllerCorreo = TextEditingController();

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
        deviceVersion = build.version.toString();
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

    //if (!mounted) return;
    return [deviceName, deviceVersion, identifier];
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
            'Versión ${Constantes().titulo}: $version',
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
            hintText: 'NIT sin dígito de verificación',
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
      mostrarAlert(context, 'Ingresa tu NIT', null);
    } else {
      //FIREBASE: Llamamos el evento login
      TagueoFirebase().sendAnalitytics(_controllerUser.text);

      final List<dynamic> divace = await Login.getDeviceDetails();

      String plataforma = Platform.isAndroid ? 'Android' : 'Ios';

      prValidar = ProgressDialog(context);
      prValidar.style(message: 'Validando información');
      prValidar = ProgressDialog(context,
          type: ProgressDialogType.Normal,
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
    pr.style(message: 'Iniciando sesión');
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);

    await pr.show();
    await loguin(context, _controllerUser.text);
    await pr.hide();
  }

  Future _login(BuildContext context, String nit) async {
    _diloagCargando(context);
  }

  Future loguin(BuildContext context, String nit) async {
    List<dynamic> respuesta = await Servicies().getListaSucursales(nit);
    respuesta.forEach((element) {
      if (element.bloqueado == "1") {
        Navigator.pushReplacementNamed(context, "inicio_compra");
        return mostrarAlert(
            context,
            "El NIT ingresado no se encuentra registrado en nuestra base de datos. Por favor revisa que esté bien escrito o contacta a soporte",
            null);
      }
    });
    prefs.codigoUnicoPideky = respuesta.first.codigoUnicoPideky;
    print(prefs.codigoUnicoPideky);
    prefs.codClienteLogueado = nit;

    if (respuesta.length > 0) {
      await pr.hide();

      Navigator.pushReplacementNamed(
        context,
        'listaSucursale',
        arguments: ScreenArguments(respuesta, _controllerUser.text),
      );
    } else {
      await pr.hide();
      mostrarAlert(context, 'Error al obtener información', null);
      return false;
    }
  }

  final border = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(
        color: Colors.black,
      ));

  _campoTextoCorreo(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: HexColor("#E4E3EC"),
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
          controller: _controllerCorreo,
          style: TextStyle(color: HexColor("#41398D"), fontSize: 15),
          decoration: InputDecoration(
            fillColor: HexColor("#41398D"),
            hintText: 'ejemplo@☼gmail.com',
            hintStyle: TextStyle(
              color: HexColor("#41398D"),
            ),
          )),
    );
  }

  Future _validarInformacion(
      BuildContext context, divace, String plataforma, String text) async {
    String? token = PushNotificationServer.token as String;
    Validacion respues =
        await Servicies().validarUsuariNuevo(text, divace, plataforma, token);

    if (respues == null) {
      await prValidar.hide();
      mostrarAlert(contextPrincipal, 'Error al validar el usuario', null);
      return;
    }

    if (respues.codigo == null) {
      await prValidar.hide();
      mostrarAlert(context, 'Error obteniendo información', null);
    } else if (respues.codigo == -1) {
      await prValidar.hide();
      mostrarAlert(
          context,
          'El NIT ingresado no se encuentra registrado en nuestra base de datos. Por favor revisa que esté bien escrito o contacta a soporte',
          null);
    } else if (respues.activo == -1) {
      await prValidar.hide();
      mostrarAlert(
          context,
          'El NIT ingresado no se encuentra registrado en nuestra base de datos. Por favor revisa que esté bien escrito o contacta a soporte',
          null);
    } else if (respues.codigo == 0) {
      mostrarAlert(context, 'No se pudo generar el código', null);
    } else if (respues.activo == 0) {
      await prValidar.hide();

      codigoRespuesta = respues.codigo;

      prefs.codActivacionLogin = respues.codigo;
      prefs.codClienteLogueado = _controllerUser.text;
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

  TextStyle diseno_dialog_titulos() =>
      TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]);

  void _cargarVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    setState(() {});
  }
}

class ScreenArguments {
  final List<dynamic> listaEmpresas;
  final String usuario;

  ScreenArguments(this.listaEmpresas, this.usuario);
}
