import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/servicios.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:emart/src/utils/colores.dart';
import 'package:emart/src/pages/login/widgets/configuracion_manual.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:imagebutton/imagebutton.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

final TextEditingController _controllerCorreo = TextEditingController();
TextStyle diseno_dialog_titulos() =>
    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]);
late BuildContext _contex_dos;
late ProgressDialog prEnviarCorreo;

class ActivacionManualNovedad extends StatefulWidget {
  final List<dynamic> listaMotivos;

  const ActivacionManualNovedad({Key? key, required this.listaMotivos})
      : super(key: key);

  @override
  State<ActivacionManualNovedad> createState() =>
      _ActivacionManualNovedadState();
}

class _ActivacionManualNovedadState extends State<ActivacionManualNovedad> {
  int _selectedIndex = -1;
  final prefs = new Preferencias();
  late int _motivo = -1;
  bool _otra = false;
  @override
  Widget build(BuildContext context) {
    _contex_dos = context;
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        return _resetearCampo();
      },
      child: Scaffold(
        backgroundColor: HexColor(Colores().color_fondo_app),
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
                    'Registro de novedad',
                    style: diseno_dialog_titulos(),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      'Ingrese el motivo de la novedad',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Column(
                    children: List<RadioListTile<int>>.generate(
                      widget.listaMotivos.length,
                      (int index) {
                        return new RadioListTile(
                            value: index,
                            groupValue: _selectedIndex,
                            title: Text(widget.listaMotivos[index].descripcion),
                            onChanged: (dynamic value) {
                              setState(() {
                                _selectedIndex = value;
                                _motivo = widget.listaMotivos[index].codigo;
                                _controllerCorreo.text = '';
                                _otra = value == 0
                                    ? false
                                    : value == 1
                                        ? false
                                        : true;
                              });
                            });
                      },
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
    return this._otra
        ? Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
              //color: HexColor("#E4E3EC"),
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
                controller: _controllerCorreo,
                minLines: 5,
                maxLines: 5,
                textAlign: TextAlign.start,
                enabled: _motivo == 2 ? false : true,
                style: TextStyle(color: HexColor("#41398D"), fontSize: 15),
                decoration: InputDecoration(
                    fillColor: HexColor("#41398D"),
                    hintStyle: TextStyle(
                      color: HexColor("#41398D"),
                    ),
                    hintText: 'Ingrese la novedad',
                    border: InputBorder.none)),
          )
        : Container();
  }

  _btnActivarPorCorreo(BuildContext context) {
    return ImageButton(
      children: <Widget>[],
      width: 310,
      height: 45,
      paddingTop: 5,
      pressedImage: Image.asset(
        "assets/image/activar_cuenta_btn.png",
      ),
      unpressedImage: Image.asset("assets/image/activar_cuenta_btn.png"),
      onTap: () => _enviarMensajeServicio(),
    );
  }

  void _enviarMensajeServicio() async {
    if (_selectedIndex == -1) {
      mostrarAlert(_contex_dos, 'Por favor seleccione un motivo', null);
    } else {
      await enviarCodigoActivacion();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ConfiguracionManual(
                  usuario: prefs.codCliente,
                  codigoRespuesta: prefs.codActivacionLogin,
                )),
      );
    }
  }

  enviarCodigoActivacion() async {
    await Servicies().enviarNovedadRegistro(
        widget.listaMotivos[_selectedIndex].codigo, _controllerCorreo.text);
  }

  Future<bool> _resetearCampo() async {
    _controllerCorreo.text = "";
    return true;
  }
}
