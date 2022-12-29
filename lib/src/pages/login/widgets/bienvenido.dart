import 'package:email_validator/email_validator.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/src/modelos/estado.dart';
import 'package:emart/src/modelos/validacion.dart';
import 'package:emart/src/modelos/validar.dart';
import 'package:emart/src/pages/login/widgets/activacion_manual_maestro.dart';
import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/servicios.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:emart/src/utils/colores.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/politicas.dart';
import 'package:emart/src/widget/terminos.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:imagebutton/imagebutton.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_html/flutter_html.dart';

final TextEditingController _controllerCorreoMsm = TextEditingController();
final TextEditingController _controllerCodigo = TextEditingController();

late ProgressDialog prEnviarCorreo;
late int codigoRespuesta;

final TextEditingController _controllerUser = TextEditingController();

late ProgressDialog pr;
late ProgressDialog prValidar;
late ProgressDialog prEnviarCodigo;
final prefs = new Preferencias();
late BuildContext contextPrincipal;
late bool isChecked = false;

var htmlNumeroCel = """ 
 <FONT SIZE=4>${S.current.get_active_with_your} </FONT><FONT SIZE=4 COLOR="#43398E"><b>${S.current.cell_phone_number}</b></FONT><FONT SIZE=4>${S.current.or_via_text_message}</FONT><FONT SIZE=4 COLOR="#43398E"><b>${S.current.text_message}</b></FONT> 
""";

var htmlNumeroMensaje = """ 
<FONT SIZE=4> ${S.current.text_your_email_address} </FONT><FONT SIZE=4 COLOR="#43398E"><b>${S.current.email_address}</b></FONT> 
""";

class Bienvenido extends StatefulWidget {
  final Validacion respues;
  final String usuario;

  const Bienvenido({
    Key? key,
    required this.respues,
    required this.usuario,
  }) : super(key: key);

  @override
  State<Bienvenido> createState() => _BienvenidoState();
}

TextStyle diseno_dialog_titulos() => TextStyle(
    fontWeight: FontWeight.bold,
    color: ConstantesColores.azul_precio,
    fontSize: 18);

class _BienvenidoState extends State<Bienvenido> {
  bool _value = false;
  late int val = -1;
  int _selectedIndex = -1;
  BuildContext? context2;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    context2 = context;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: HexColor('#F7F7F7'),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: size.height * 0.9,
                  child: _cuerpoComponentes(context, widget.respues.telefonos!,
                      widget.respues.email!),
                ),
                _btnActivarPorCorreo(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _cuerpoComponentes(
      BuildContext context, List<String> listaTelefono, String email) {
    final size = MediaQuery.of(context).size;
    codigoRespuesta = widget.respues.codigo;

    return Stack(
      children: [
        Positioned(
          top: 50,
          left: 7,
          child: IconButton(
              iconSize: 35,
              color: Color(0XFF30C3A3),
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios_new_outlined)),
        ),
        Positioned(
            top: 115,
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
                    S.current.welcome_pideky,
                    style: diseno_dialog_titulos(),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      S.current.secod_welcome_pideky,
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
                          child: Column(
                            children: List<RadioListTile<int>>.generate(
                              listaTelefono.length,
                              (int index) {
                                return new RadioListTile(
                                    value: index,
                                    activeColor: ConstantesColores.azul_precio,
                                    groupValue: _selectedIndex,
                                    title: Container(
                                        child: Text(
                                            '*****${listaTelefono[index].substring(listaTelefono[index].length - 4)}')),
                                    onChanged: (dynamic value) {
                                      setState(() {
                                        _selectedIndex = value;
                                        _controllerCorreoMsm.text =
                                            listaTelefono[index];
                                      });
                                    });
                              },
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: widget.respues.email! != 'Sin Correo',
                        child: ListTile(
                          title: Html(
                            data: htmlNumeroMensaje,
                          ),
                          leading: Radio(
                            value: 2,
                            groupValue: val,
                            onChanged: (dynamic value) {
                              setState(() {
                                val = value;
                              });
                            },
                            activeColor: ConstantesColores.azul_precio,
                          ),
                        ),
                      ),
                      Visibility(
                        visible:
                            val == 2 && widget.respues.email! != 'Sin Correo',
                        child: Container(
                          width: 240,
                          decoration: BoxDecoration(
                            color: HexColor("#E4E3EC"),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: List<RadioListTile<int>>.generate(
                              1,
                              (int index) {
                                return new RadioListTile(
                                    value: index,
                                    activeColor: ConstantesColores.azul_precio,
                                    groupValue: _selectedIndex,
                                    title: Text(widget.respues.email!),
                                    onChanged: (dynamic value) {
                                      setState(() {
                                        _selectedIndex = value;
                                        _controllerCorreoMsm.text =
                                            widget.respues.email!;
                                      });
                                    });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
        Positioned(
          top: 87,
          right: 10,
          child: Container(
            height: 70,
            width: 70,
            child: _btnActivarManual(context),
          ),
        ),
      ],
    );
  }

  _campoTextoCorreo(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: HexColor("#E4E3EC"),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
          controller: _controllerCorreoMsm,
          style: TextStyle(color: HexColor("#41398D"), fontSize: 15),
          decoration: InputDecoration(
              fillColor: HexColor("#41398D"),
              hintText: 'ejemplo@gmail.com',
              hintStyle: TextStyle(
                color: HexColor("#41398D"),
              ),
              border: InputBorder.none)),
    );
  }

  _btnActivarPorCorreo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 15, 0),
      child: ImageButton(
        children: <Widget>[],
        width: 310,
        height: 45,
        paddingTop: 5,
        pressedImage: Image.asset(
          "assets/image/registar_cuenta_btn.png",
        ),
        unpressedImage: Image.asset("assets/image/registar_cuenta_btn.png"),
        onTap: () => _enviarCorreoElectronico(context),
      ),
    );
  }

  _btnActivarManual(BuildContext context) {
    return ImageButton(
      children: <Widget>[],
      width: 55,
      height: 55,
      pressedImage: Image.asset(
        "assets/image/activacion_manual_btn.png",
      ),
      unpressedImage: Image.asset("assets/image/activacion_manual_btn.png"),
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConfiguracionMamualMaestr()),
        )
      },
    );
  }

  void _enviarMensajeTelefono(String dropdownValue) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            content: Container(
              height: 300,
              width: double.infinity,
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
                        '¿Quieres enviar el mensaje a este número: ******${dropdownValue.substring(dropdownValue.length - 4)}?'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: GestureDetector(
                      onTap: () =>
                          _enviarMensajeDeTexto(context, dropdownValue),
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        child: Image.asset(
                          "assets/image/btn_aceptar.png",
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: SingleChildScrollView(
                      child: Column(children: <Widget>[
                        Text(
                          'O deseas ir al',
                          style: TextStyle(fontSize: 10),
                        ),
                        GestureDetector(
                          onTap: () => {
                            Navigator.of(context).pop(),
                            Navigator.push(
                              context2!,
                              MaterialPageRoute(
                                  builder: (context2) =>
                                      ConfiguracionMamualMaestr()),
                            )
                          },
                          child: Text(
                            ' registro manual',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 10),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _enviarMensajeDeTexto(BuildContext context, String numero) {
    _enviarMensajeServicio(numero);
  }

  void _enviarMensajeServicio(String dropdownValue) async {
    prEnviarCorreo = ProgressDialog(context2!);
    prEnviarCorreo.style(message: 'Enviando MS');
    prEnviarCorreo = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);

    await prEnviarCorreo.show();
    await enviarCodigoActivacion(context2!, 'TELEFONO', dropdownValue);
    //await prEnviarCorreo.hide();
  }

  _enviarCorreoElectronico(BuildContext context) {
    if (_controllerCorreoMsm.text != 'Sin Correo') {
      _enviarMensajeDeTexto(context2!, _controllerCorreoMsm.text);
    } else {
      if (_controllerCorreoMsm.text == '') {
      } else if (!EmailValidator.validate(_controllerCorreoMsm.text)) {
        mostrarAlert(context2!, 'El email no cumple con el formato', null);
      } else {
        showDialog(
            context: context2!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                content: Container(
                  height: 300,
                  width: double.infinity,
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
                              '¿Quieres enviar el mensaje a este correo: ${_controllerCorreoMsm.text}?'),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: GestureDetector(
                            onTap: () => _enviarMensajeServicioCorreo(),
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              child: Image.asset(
                                "assets/image/btn_aceptar.png",
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: SingleChildScrollView(
                            child: Column(children: <Widget>[
                              Text('O deseas ir al '),
                              GestureDetector(
                                onTap: () => {
                                  Navigator.of(context).pop(),
                                  Navigator.push(
                                    context2!,
                                    MaterialPageRoute(
                                        builder: (context2) =>
                                            ConfiguracionMamualMaestr()),
                                  )
                                },
                                child: Text(
                                  ' registro manual',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      }
    }
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
    await enviarCodigoActivacion(
        context2!, 'CORREO', _controllerCorreoMsm.text);
    await prEnviarCorreo.hide();
  }

  enviarCodigoActivacion(
      BuildContext context2, String tipo, String dropdownValue) async {
    late Estado estado;

    try {
      if (val == 1) {
        estado = await Servicies().enviarMS(dropdownValue, codigoRespuesta);
      } else if (val == 2) {
        estado = await Servicies().enviarCorreo(dropdownValue, codigoRespuesta);
      }

      if (estado.estado == 'OK') {
        await prEnviarCorreo.hide().then((value) => {});
        //UXCam: Llamamos el evento sendActivationCode
        UxcamTagueo()
            .sendActivationCode(val == 1 ? 'sms' : 'correo', 'Exitoso');
        _mostrarDilogActivarCuenta(context2);
      } else {
        //UXCam: Llamamos el evento sendActivationCode
        UxcamTagueo().sendActivationCode(val == 1 ? 'sms' : 'correo', 'Error');
        await prEnviarCorreo.hide();
        mostrarAlert(
            context2,
            'No fue posible enviar el mensaje, por favor intente nuevamente ${estado.mensaje}',
            null);
      }
    } catch (e) {
      await prEnviarCorreo.hide();
      mostrarAlert(
          context2, 'No fue posible enviar el mensaje de texto $e', null);
    }
  }

  void _mostrarDilogActivarCuenta(BuildContext context2) {
    showDialog(
      context: context2,
      barrierDismissible: false,
      builder: (BuildContext context) {
        bool isChequet = false;
        bool isChequet1 = false;
        var destino = this.val == 1 ? "SMS" : "correo electrónico";
        return AlertDialog(
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
                          'Por favor ingresa el código de activacion, enviado por $destino a tu número seleccionado:',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: _controllerCodigo,
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          decoration: InputDecoration(
                              fillColor: Colors.black,
                              hintStyle: TextStyle(color: Colors.black),
                              hintText: 'Codigo',
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.fromLTRB(10, 0, 10, 0)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: HexColor("#E4E3EC"),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isChequet,
                              shape: CircleBorder(),
                              checkColor: Colors.purple,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChequet = value!;
                                });
                              },
                            ),
                            Expanded(
                                child: Text(
                              'Acepto política de privacidad',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: HexColor(Colores().color_azul_letra)),
                            )),
                          ],
                        ),
                      ),
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
                                    'Acepto política de tratamiento de datos',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: HexColor(
                                            Colores().color_azul_letra)))),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
                        onTap: () => _btnEnviarCodigo(context, isChequet),
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
        );
      },
    );
  }

  _btnEnviarCodigo(BuildContext context, bool estado) {
    if (_controllerCodigo.text == '') {
      // mostrarAlert(context, 'El Codigo de Verificación no puede estar vacio', 'Alerta');
    } else {
      //FIREBASE: Llamamos el evento code_received
      TagueoFirebase()
          .sendAnalityticsActivationCodeReceived(_controllerCodigo.text);
      _cargandoCodigoVerificacion(codigoRespuesta, _controllerCodigo.text);
    }
  }

  void _cargandoCodigoVerificacion(int codigo, String codVerificado) async {
    prEnviarCodigo = ProgressDialog(context);
    prEnviarCodigo.style(
        message: 'Estamos validando el código para activar tu cuenta.');
    prEnviarCodigo = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);

    await prEnviarCodigo.show();
    await enviarCodigoVerificacion(context, codigo, codVerificado);
    await prEnviarCodigo.hide();
  }

  enviarCodigoVerificacion(
      BuildContext context, int codigo, String codigoVerificacion) async {
    Validar validar =
        await Servicies().enviarCodigoVerificacion(codigo, codigoVerificacion);

    if (validar.activado == 'OK') {
      //FIREBASE: Llamamos el evento code_succes
      TagueoFirebase().sendAnalityticsActivationCodeSucces("OK");
      await prEnviarCodigo.hide();
      _mensajeDeBienvenida(context2!);
    } else {
      //FIREBASE: Llamamos el evento activation_code_error
      TagueoFirebase().sendAnalityticsActivationCodeError("ERROR");
      await prEnviarCodigo.hide();
      mostrarAlert(
          context2!,
          'El código de verificación es incorrecto,\npor favor compruébelo e intente nuevamente. ',
          null);
    }
  }

  void _mensajeDeBienvenida(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
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
                        onTap: () => _pasarSucursales(),
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
      //Se inicializa la variable

      Navigator.pushReplacementNamed(
        context,
        'listaSucursale',
        arguments: ScreenArguments(respuesta, widget.usuario),
      );
    } else {
      await pr.hide();
      mostrarAlert(context, 'Error al obtener información', null);
      return false;
    }

    return true;
  }
}
