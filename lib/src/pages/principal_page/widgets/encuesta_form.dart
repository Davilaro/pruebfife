import 'dart:convert';

import 'package:emart/shared/widgets/custom_textFormField.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/src/controllers/encuesta_controller.dart';
import 'package:emart/src/modelos/encuesta.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/provider/servicios.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:emart/src/widget/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';

import '../../../controllers/validations_forms.dart';

class EncuestaForm extends StatefulWidget {
  final Encuesta encuesta;

  const EncuestaForm(this.encuesta);

  @override
  State<EncuestaForm> createState() => _EncuestaFormState();
}

class _EncuestaFormState extends State<EncuestaForm> {
  TextEditingController controllerText = TextEditingController();
  RxString mensajeValid = ''.obs;
  String _seleccion = '';
  late Map<String, bool> _opcionesMultiple = {};

  final controllerProducto = Get.find<ControllerProductos>();
  final controllerEncuesta = Get.find<EncuestaControllers>();
  final _validationForms = Get.put(ValidationForms());
  final prefs = Preferencias();

  String? _errorText;

  @override
  void initState() {
    widget.encuesta.tipoPreguntaId == 4
        ? checkButtons(widget.encuesta.parametro)
        : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30), color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 15, top: 20),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '${widget.encuesta.pregunta}',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //pregunta abierta
                  Visibility(
                    visible: widget.encuesta.tipoPreguntaId == 1
                        ? true
                        : false || widget.encuesta.tipoPreguntaId == 2
                            ? true
                            : false,
                    child: Container(
                      width: Get.width * 1,
                      decoration: BoxDecoration(
                        color: HexColor("#E4E3EC"),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.zero,
                      child: TextField(
                        keyboardType: widget.encuesta.tipoPreguntaId == 2
                            ? TextInputType.number
                            : TextInputType.text,
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.top,
                        controller: controllerText,
                        style: TextStyle(color: Colors.black, fontSize: 15),
                        decoration: InputDecoration(
                          fillColor: HexColor("#41398D"),
                          hintText: '. . .',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                        ),
                      ),
                    ),
                  ),
                  //Pregunta seleccion multiple unica respuesta
                  widget.encuesta.tipoPreguntaId == 3
                      ? Visibility(
                          visible: widget.encuesta.tipoPreguntaId == 3,
                          child: Container(
                              width: Get.width * 0.68,
                              decoration: BoxDecoration(
                                color: HexColor("#E4E3EC"),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.zero,
                              child: Column(
                                children:
                                    radioButtons(widget.encuesta.parametro),
                              )),
                        )
                      : Container(),
                  //Pregunta seleccion multiple mutiples respuesta
                  widget.encuesta.tipoPreguntaId == 4
                      ? Visibility(
                          visible: widget.encuesta.tipoPreguntaId == 4,
                          child: Container(
                            width: Get.width * 0.68,
                            decoration: BoxDecoration(
                              color: HexColor("#E4E3EC"),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.zero,
                            child: Column(children: [
                              for (var i = 0;
                                  i < widget.encuesta.parametro!.length;
                                  i++)
                                Row(
                                  children: [
                                    Checkbox(
                                        checkColor: Colors.white,
                                        activeColor:
                                            ConstantesColores.azul_precio,
                                        value: _opcionesMultiple[
                                            widget.encuesta.parametro![i]],
                                        onChanged: (bool? value) {
                                          onChangeOpcionesCheckBox(value!,
                                              widget.encuesta.parametro![i]);
                                        }),
                                    Expanded(
                                        child: Text(
                                            widget.encuesta.parametro![i])),
                                  ],
                                ),
                            ]),
                          ),
                        )
                      : Container(),
                      
                      // Pregunta teléfono y correo

                  Visibility(           
                    visible: widget.encuesta.tipoPreguntaId == 13 || widget.encuesta.tipoPreguntaId == 14, 
                    child: Column(
                      children: [
                        if (widget.encuesta.tipoPreguntaId == 13)
                          CustomTextFormField(
                            keyboardType: TextInputType.text,
                            hintText: 'Ingresa tu correo electrónico',
                            backgroundColor: HexColor("#E4E3EC"),
                            controller: controllerText,
                            onChanged: (value) {
                              String? validationError =
                                  _validationForms.validateEmail(value);
                              setState(() {
                                _errorText =
                                    validationError; 
                              });
                            },
                            errorMessage: _errorText,
                          ),
                        if (widget.encuesta.tipoPreguntaId == 14)
                          CustomTextFormField(
                            keyboardType: TextInputType.number,
                            hintText: 'Ingresa tu número de  celular',
                            backgroundColor: HexColor("#E4E3EC"),
                            controller: controllerText,
                            onChanged: (value) {
                              String? validationError =
                                  _validationForms.validateTelephone(value);
                              setState(() {
                                _errorText =
                                    validationError; 
                              });
                            },
                            errorMessage: _errorText,
                          ),
                      ],
                    ),
                  ),
               
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: Get.width * 0.5,
                    height: Get.height * 0.04,
                    child: CustomButton(
                      onPressed: () =>
                          _validarInformacion(context, widget.encuesta),
                      text: 'Enviar',
                      sizeText: 15,
                      backgroundColor: ConstantesColores.agua_marina,
                      borderRadio: 20,
                    ),
                  ),
                ],
              ),
              Obx(() => Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    child: Text(
                      '${mensajeValid.value}',
                      style: TextStyle(fontSize: 15, color: Colors.red),
                    ),
                  ))
            ],
          ),
        ),
        Positioned(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: SvgPicture.asset('assets/icon/prueba1.svg'),
          ),
          top: 0,
          right: 10,
        )
      ],
    );
  }

  void onChangeOpcionesRadioButton(String? value) {
    setState(() {
      _seleccion = value!;
    });
  }

  void onChangeOpcionesCheckBox(bool value, String key) {
    setState(() {
      _opcionesMultiple[key] = value;
    });
  }

  List<Widget> radioButtons(List<dynamic>? parametro) {
    List<Widget> listOpciones = [];
    listOpciones = parametro!.map((item) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Radio(
                value: item.toString(),
                activeColor: ConstantesColores.azul_precio,
                groupValue: _seleccion,
                onChanged: (String? value) =>
                    onChangeOpcionesRadioButton(value)),
            Expanded(child: Text(item.toString())),
          ],
        ),
      );
    }).toList();
    return listOpciones;
  }

  void checkButtons(List<dynamic>? parametro) {
    for (var i = 0; i < parametro!.length; i++) {
      _opcionesMultiple.addAll({parametro[i].toString(): false});
    }
  }

  Future _validarInformacion(BuildContext context, Encuesta encuesta) async {
    if (encuesta.tipoPreguntaId == 1 && controllerText.text.isNotEmpty ||
        encuesta.tipoPreguntaId == 2 && controllerText.text.isNotEmpty || 
        encuesta.tipoPreguntaId == 13 && controllerText.text.isNotEmpty ||
        encuesta.tipoPreguntaId == 14 && controllerText.text.isNotEmpty) {
      mensajeValid.value = '';
      var respues =
          await Servicies().enviarEncuesta(encuesta, controllerText.text);
      var res = await DBProviderHelper.db.guardarRespuesta(encuesta);
      if (!respues) {
        mostrarAlert(
            context, 'Lo sentimos, no se ha logrado enviar su respuesta', null);
        return;
      } else {
        controllerText.text = '';
        alertaFinEncuesta();
        return;
      }
    } else if (encuesta.tipoPreguntaId == 3) {
      if (_seleccion.isNotEmpty) {
        mensajeValid.value = '';
        var respues = await Servicies().enviarEncuesta(encuesta, _seleccion);
        var res = await DBProviderHelper.db.guardarRespuesta(encuesta);
        if (!respues) {
          mostrarAlert(context,
              'Lo sentimos, no se ha logrado enviar su respuesta', null);
          return;
        } else {
          _seleccion = '';
          alertaFinEncuesta();
          return;
        }
      } else {
        mensajeValid.value = 'Por favor seleccione una respuesta';
      }
    } else if (encuesta.tipoPreguntaId == 4) {
      if (_opcionesMultiple.containsValue(true)) {
        mensajeValid.value = '';
        var valores = [];
        _opcionesMultiple.forEach((key, value) {
          if (value) {
            valores.add(key);
          }
        });
        var opciones = jsonEncode(valores);
        var transforOpciones = opciones
            .replaceAll('"', "")
            .replaceAll('[', '')
            .replaceAll(']', '');

        var respues =
            await Servicies().enviarEncuesta(encuesta, transforOpciones);
        var res = await DBProviderHelper.db.guardarRespuesta(encuesta);
        if (!respues) {
          mostrarAlert(context,
              'Lo sentimos, no se ha logrado enviar su respuesta', null);
          return;
        } else {
          alertaFinEncuesta();
          _opcionesMultiple.updateAll((key, value) => value = false);
          return;
        }
      } else {
        mensajeValid.value = 'Por favor seleccione una respuesta';
      }
    } else {
      mensajeValid.value = 'Por favor ingrese una respuesta';
    }
     

  }

  alertaFinEncuesta() {
    mostrarAlert(
        context,
        'Gracias por contestar nuestra encuesta',
        Icon(
          Icons.check,
          color: ConstantesColores.verde,
          size: 50,
        ));
    controllerEncuesta.setIsVisibleEncuesta(false);
  }
}
