import 'package:email_validator/email_validator.dart';
import 'package:emart/src/modelos/estado.dart';
import 'package:emart/src/modelos/validar.dart';
import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/servicios.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:emart/src/utils/colores.dart';
import 'package:emart/src/pages/login/widgets/bienvenido.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/politicas.dart';
import 'package:emart/src/widget/terminos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:imagebutton/imagebutton.dart';
import 'package:progress_dialog/progress_dialog.dart';

final TextEditingController _controllerCorreo = TextEditingController();
final TextEditingController _controllerCodigo = TextEditingController();
final TextEditingController _controllerNumero = TextEditingController();

late ProgressDialog pr;
late ProgressDialog prValidar;
late ProgressDialog prEnviarCorreo;
late ProgressDialog prEnviarCodigo;
final prefs = new Preferencias();
late BuildContext contextPrincipal;
late bool isChecked = false;

class ConfiguracionManual extends StatefulWidget {
  final String usuario;
  final int codigoRespuesta;
  const ConfiguracionManual(
      {Key? key, required this.usuario, required this.codigoRespuesta})
      : super(key: key);

  @override
  State<ConfiguracionManual> createState() => _ConfiguracionManualState();
}

class _ConfiguracionManualState extends State<ConfiguracionManual> {
  BuildContext? context2;
  late int val = -1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    context2 = context;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: HexColor('F7F7F7'),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: size.height * 0.9,
                  child: _cuerpoComponentes(context),
                ),
                _btnActivarPorCorreo(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _btnActivarPorCorreo(BuildContext context) {
    return ImageButton(
        children: <Widget>[],
        width: 310,
        height: 45,
        paddingTop: 5,
        pressedImage: Image.asset(
          "assets/image/registar_cuenta_btn.png",
        ),
        unpressedImage: Image.asset("assets/image/registar_cuenta_btn.png"),
        onTap: () => {_enviarCorreoElectronico(context)});
  }

  _cuerpoComponentes(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned(
            top: 80,
            left: 25,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              height: size.height * 0.75,
              width: size.width * 0.85,
              child: ListView(
                children: [
                  Text(
                    'Activación manual',
                    style: diseno_dialog_titulos(),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      'Selecciona el método para realizar la activación manual.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Column(
                    children: [
                      ListTile(
                        title: Html(
                          data: htmlNumeroCel,
                        ),
                        leading: Radio(
                          value: 1,
                          groupValue: val,
                          onChanged: (dynamic value) {
                            setState(() {
                              val = value;
                              _controllerNumero.text = '';
                              _controllerCorreo.text = '';
                            });
                          },
                          activeColor: ConstantesColores.azul_precio,
                        ),
                      ),
                      Visibility(
                        visible: val == 1,
                        child: Container(
                          width: 240,
                          decoration: BoxDecoration(
                            color: HexColor("#E4E3EC"),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: _campoTextoNumero(context),
                        ),
                      ),
                      ListTile(
                        title: Html(
                          data: htmlNumeroMensaje,
                        ),
                        leading: Radio(
                          value: 2,
                          groupValue: val,
                          onChanged: (dynamic value) {
                            setState(() {
                              val = value;
                              _controllerNumero.text = '';
                              _controllerCorreo.text = '';
                            });
                          },
                          activeColor: ConstantesColores.azul_precio,
                        ),
                      ),
                      Visibility(
                        visible: val == 2,
                        child: Container(
                          width: 240,
                          decoration: BoxDecoration(
                            color: HexColor("#E4E3EC"),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: _campoTextoCorreo(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }

  _campoTextoCorreo(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: HexColor("#E4E3EC"),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
          controller: _controllerCorreo,
          style: TextStyle(color: HexColor("#41398D"), fontSize: 15),
          decoration: InputDecoration(
              fillColor: HexColor("#41398D"),
              hintText: 'Correo electrónico',
              hintStyle: TextStyle(
                color: HexColor("#41398D"),
              ),
              border: InputBorder.none)),
    );
  }

  _campoTextoNumero(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: HexColor("#E4E3EC"),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
          controller: _controllerNumero,
          keyboardType: TextInputType.number,
          style: TextStyle(color: HexColor("#41398D"), fontSize: 15),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
              fillColor: HexColor("#41398D"),
              hintText: 'Número Celular',
              hintStyle: TextStyle(
                color: HexColor("#41398D"),
              ),
              border: InputBorder.none)),
    );
  }

  _enviarCorreoElectronico(BuildContext context) {
    if (_controllerCorreo.text == '' && _controllerNumero.text == '') {
      mostrarAlert(context, 'Los campos no deben estas vacios', null);
    } else if (_controllerCorreo.text != '' &&
        !EmailValidator.validate(
            _controllerCorreo.text.toString().replaceAll(' ', ''))) {
      mostrarAlert(context, 'El formato de correo no es correcto', null);
    } else if (_controllerCorreo.text != '') {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              content: Container(
                height: 250,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        child: Image.asset('assets/image/alerta_img.png'),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text(
                            'Deseas enviar el mensaje a este correo: ${_controllerCorreo.text}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: GestureDetector(
                          onTap: () => {
                            _controllerCodigo.text = '',
                            Navigator.pop(context),
                            //FIREBASE: Llamamos el evento condeSubmission
                            TagueoFirebase()
                                .sendAnalityticsActivationCodeSubmission(
                                    _controllerCorreo.text),
                            _enviarMensajeServicioCorreo(),
                          },
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            child: Image.asset(
                              "assets/image/btn_aceptar.png",
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    } else {
      if (_controllerNumero.text.length != 10) {
        mostrarAlert(context,
            'El numero esta incompleto o supera los 10 caracteres', null);
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                content: Container(
                  height: 250,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        child: Image.asset('assets/image/alerta_img.png'),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text(
                            'Deseas enviar el mensaje a este número: ******${_controllerNumero.text.substring(_controllerNumero.text.length - 4)}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: GestureDetector(
                          onTap: () => {
                            //FIREBASE: Llamamos el evento select_content
                            TagueoFirebase()
                                .sendAnalityticsActivationCodeSubmission(
                                    _controllerCorreo.text),
                            _enviarMensajeDeTexto(
                                context, _controllerNumero.text),
                          },
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            child: Image.asset(
                              "assets/image/btn_aceptar.png",
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
      }
    }
  }

  _enviarMensajeDeTexto(BuildContext context, String numero) {
    Navigator.of(context).pop();
    _enviarMensajeServicio(numero);
  }

  void _enviarMensajeServicio(String dropdownValue) async {
    prEnviarCorreo = ProgressDialog(context2!);
    prEnviarCorreo.style(message: 'Enviando SMS');
    prEnviarCorreo = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);

    await prEnviarCorreo.show();
    await enviarCodigoActivacion(context2!, 'TELEFONO', dropdownValue);
    await prEnviarCorreo.hide();
  }

  _enviarMnesajePorCorreo(BuildContext context) {
    Navigator.pop(context);
    _enviarMensajeServicioCorreo();
  }

  void _enviarMensajeServicioCorreo() async {
    prEnviarCorreo = ProgressDialog(context2!);
    prEnviarCorreo.style(message: 'Enviando Correo');
    prEnviarCorreo = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);

    await prEnviarCorreo.show();
    await enviarCodigoActivacion(context2!, 'CORREO',
        _controllerCorreo.text.toString().replaceAll(' ', ''));
    await prEnviarCorreo.hide();
  }

  enviarCodigoActivacion(
      BuildContext context2, String tipo, String dropdownValue) async {
    late Estado estado;

    if (tipo == 'TELEFONO') {
      estado =
          await Servicies().enviarMS(dropdownValue, widget.codigoRespuesta);
    } else {
      estado = await Servicies().enviarCorreo(
          _controllerCorreo.text.toString().replaceAll(' ', ''),
          widget.codigoRespuesta);
    }

    try {
      if (estado.estado == 'OK') {
        await prEnviarCorreo.hide().then((value) => {
              _controllerCorreo.text = "",
            });

        _mostrarDilogActivarCuenta(context2);
      } else {
        await prEnviarCorreo.hide();
      }
    } catch (e) {}
  }

  void _mostrarDilogActivarCuenta(BuildContext context2) {
    showDialog(
      context: context2,
      barrierDismissible: false,
      builder: (BuildContext context) {
        bool isChequet = true;
        bool isChequet1 = false;
        var destino = this.val == 1 ? "SMS" : "correo electrónico";
        return WillPopScope(
          onWillPop: () async => false,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              content: Container(
                width: double.infinity,
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Icon(
                                    Icons.cancel,
                                    color: ConstantesColores.verde,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                            child: Text(
                              'Activar Cuenta',
                              style: diseno_dialog_titulos(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Text(
                              'Por favor ingresa el código de activación, enviado por $destino',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              controller: _controllerCodigo,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                  fillColor: Colors.black,
                                  hintStyle: TextStyle(color: Colors.black),
                                  hintText: 'Código',
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10, 0, 10, 0)),
                            ),
                          ),
                          // Container(
                          //   margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(20),
                          //     color: HexColor("#E4E3EC"),
                          //   ),
                          //   child: Row(
                          //     children: [
                          //       Checkbox(
                          //         value: isChequet,
                          //         shape: CircleBorder(),
                          //         checkColor: Colors.purple,
                          //         onChanged: (bool? value) {
                          //           setState(() {
                          //             isChequet = value!;
                          //           });
                          //         },
                          //       ),
                          //       Expanded(
                          //           child: Text(
                          //         'Acepto política de privacidad',
                          //         textAlign: TextAlign.left,
                          //         style: TextStyle(
                          //             fontSize: 12,
                          //             color:
                          //                 HexColor(Colores().color_azul_letra)),
                          //       )),
                          //     ],
                          //   ),
                          // ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: HexColor("#E4E3EC"),
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isChequet1,
                                  shape: CircleBorder(),
                                  checkColor: Colors.purple,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChequet1 = value!;
                                    });
                                  },
                                ),
                                Expanded(
                                    child: Text(
                                        // 'Acepto política de tratamiento de datos',
                                        'Acepto los términos y condiciones y autorizo el tratamiento de mis datos personales',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: HexColor(
                                                Colores().color_azul_letra)))),
                              ],
                            ),
                          ),
                          Terminos(),
                          SizedBox(
                            height: 10,
                          ),
                          Politicas(),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () => _btnEnviarCodigo(
                                context, isChequet, isChequet1),
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              child: Image.asset(
                                "assets/image/activar_cuenta_btn.png",
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _btnEnviarCodigo(BuildContext context, bool estado, bool estado2) {
    if (_controllerCodigo.text == '') {
      mostrarAlert(
          context, 'El Codigo de Verificación no puede estar vacio', null);
    } else {
      if (estado && estado2) {
        //FIREBASE: Llamamos el evento code_received
        TagueoFirebase()
            .sendAnalityticsActivationCodeReceived(_controllerCodigo.text);
        _cargandoCodigoVerificacion(
            widget.codigoRespuesta, _controllerCodigo.text, estado, estado2);
      } else {
        mostrarAlert(context, 'Se debe aceptar las politicas', null);
      }
    }
  }

  /*_btnEnviarCodigo(BuildContext context, bool estado) {
    if (_controllerCodigo.text == '') {
      mostrarAlert(
          context, 'El Codigo de Verificación no puede estar vacio');
    } else {
      _cargandoCodigoVerificacion(
          widget.codigoRespuesta, _controllerCodigo.text);
    }
  }*/

  void _cargandoCodigoVerificacion(
      int codigo, String codVerificado, bool estado, bool estado2) async {
    prEnviarCodigo = ProgressDialog(context);
    prEnviarCodigo.style(
        message: 'Estamos validando el código para activar tu cuenta.');
    prEnviarCodigo = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);

    await prEnviarCodigo.show();
    await enviarCodigoVerificacion(
        context, codigo, codVerificado, estado, estado2);
    await prEnviarCodigo.hide();
  }

  enviarCodigoVerificacion(BuildContext context, int codigo,
      String codigoVerificacion, bool estado, bool estado2) async {
    Validar validar =
        await Servicies().enviarCodigoVerificacion(codigo, codigoVerificacion);

    if (validar.activado == 'OK') {
      //FIREBASE: Llamamos el evento activation_code_succes
      TagueoFirebase().sendAnalityticsActivationCodeSucces("OK");
      //UXCam: Llamamos el evento activationCode
      UxcamTagueo()
          .activationCode(codigoVerificacion, 'satisfactorio', estado, estado2);

      await prEnviarCodigo.hide();
      await Servicies().loadDataTermsAndConditions();
      _mensajeDeBienvenida(context2!);
    } else {
      //FIREBASE: Llamamos el evento activation_code_error
      TagueoFirebase().sendAnalityticsActivationCodeError("ERROR");
      //UXCam: Llamamos el evento activationCode
      UxcamTagueo()
          .activationCode(codigoVerificacion, 'erróneo', estado, estado2);
      await prEnviarCodigo.hide();
      mostrarAlert(
          context,
          'El código de verificación es incorrecto,\npor favor compruébelo e intente nuevamente. ',
          null);
    }
  }

  void _mensajeDeBienvenida(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                content: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          child: Image.asset('assets/image/checked.png'),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Text('¡Registro Exitoso!'),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text(
                            'Se ha realizado correctamente el registro de tu cuenta pideky a continuación selecciona una sucursal para comenzar a realizar todos pedidos.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                          child: GestureDetector(
                            onTap: () =>
                                {Navigator.of(context).pop, _pasarSucursales()},
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              child: Image.asset(
                                "assets/image/btn_aceptar.png",
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
        });
  }

  _pasarSucursales() {
    _diloagCargando(context2!);
  }

  _diloagCargando(BuildContext context) async {
    pr = ProgressDialog(context);
    pr.style(message: 'Cargando sucursales');
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);

    await pr.show();
    await loguin(context);
    await pr.hide();
  }

  Future _login(BuildContext context, String nit) async {
    _diloagCargando(context);
  }

  Future loguin(BuildContext context) async {
    List<dynamic> respuesta =
        await Servicies().getListaSucursales(prefs.codClienteLogueado);

    if (respuesta.length > 0) {
      pr.hide();

      /*Navigator.pushNamedAndRemoveUntil(
        context,
        'listaSucursale',
        arguments:,
      );*/

      Navigator.of(context).pushNamedAndRemoveUntil(
          'listaSucursale', (Route<dynamic> route) => false,
          arguments: ScreenArguments(respuesta, prefs.codClienteLogueado));
    } else {
      await pr.hide();
      mostrarAlert(context, 'Error al obtener información', null);
      return false;
    }

    return true;
  }
}
