// ignore_for_file: import_of_legacy_library_into_null_safe, non_constant_identifier_names

import 'package:emart/generated/l10n.dart';
import 'package:emart/src/pages/login/widgets/activacion_manual_novedad.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/servicios.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:imagebutton/imagebutton.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class ConfiguracionMamualMaestr extends StatefulWidget {
  @override
  State<ConfiguracionMamualMaestr> createState() =>
      _ConfiguracionMamualMaestrState();
}

class _ConfiguracionMamualMaestrState extends State<ConfiguracionMamualMaestr> {
  final TextEditingController _controllerCorreo = TextEditingController();
  TextStyle diseno_dialog_titulos() => TextStyle(
      fontWeight: FontWeight.bold,
      color: ConstantesColores.azul_precio,
      fontSize: 18);
  late BuildContext _contex_dos;
  late ProgressDialog prEnviarCorreo;
  late List<dynamic> listaMotivos = [];
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      _cargarMotivos();
    });
  }

  @override
  Widget build(BuildContext context) {
    _contex_dos = context;
    bool _correo = false;
    final size = MediaQuery.of(context).size;

    return Scaffold(
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
    );
  }

  _cuerpoComponentes(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
            top: 105,
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
                    S.current.manual_activation,
                    style: diseno_dialog_titulos(),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Text(
                      S.current.enter_your_master_code,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  _campoTextoCorreo(context),
                ],
              ),
            )),
      ],
    );
  }

  _campoTextoCorreo(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        //color: HexColor("#E4E3EC"),
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
          obscureText: !_passwordVisible,
          controller: _controllerCorreo,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          style: TextStyle(color: HexColor("#41398D"), fontSize: 15),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            fillColor: HexColor("#41398D"),
            hintText: S.current.master_code,
            hintStyle: TextStyle(
              color: HexColor("#41398D"),
            ),
            border: InputBorder.none,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
              icon: Icon(
                // Based on passwordVisible state choose the icon
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: ConstantesColores.azul_precio,
              ),
            ),
          )),
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
      onTap: () => _enviarMensajeServicio(),
    );
  }

  void _enviarMensajeServicio() async {
    if (_controllerCorreo.text == '') {
      mostrarAlert(_contex_dos, 'Ingresa el código maestro', null);
    } else {
      prEnviarCorreo = ProgressDialog(_contex_dos);
      prEnviarCorreo.style(message: 'Verificando cuenta');
      prEnviarCorreo = ProgressDialog(_contex_dos,
          type: ProgressDialogType.normal,
          isDismissible: false,
          showLogs: true);

      await prEnviarCorreo.show();
      await enviarCodigoActivacion(_contex_dos);
      await prEnviarCorreo.hide();
    }
  }

  enviarCodigoActivacion(BuildContext contex_dos) async {
    List<dynamic> respuesta =
        await Servicies().varificarCodigoMaestro(_controllerCorreo.text);

    if (respuesta[0].respuesta == 'OK') {
      //UXCam: Llamamos el evento sendActivationCode
      UxcamTagueo().manualActivation(_controllerCorreo.text, 'satisfactorio');
      prEnviarCorreo.hide();
      _controllerCorreo.text = '';
      Navigator.push(
        contex_dos,
        MaterialPageRoute(
            builder: (context) => ActivacionManualNovedad(
                  listaMotivos: listaMotivos,
                )),
      );
    } else {
      //UXCam: Llamamos el evento sendActivationCode
      UxcamTagueo().manualActivation(_controllerCorreo.text, 'erróneo');
      prEnviarCorreo.hide();
      mostrarAlert(contex_dos, S.current.error_code, null);
    }
  }

  void _cargarMotivos() async {
    listaMotivos = await Servicies().novedadesRegistro();
  }
}
