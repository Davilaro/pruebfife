import 'package:emart/_pideky/presentation/mi_negocio/view_model/mi_negocio_view_model.dart';
import 'package:emart/shared/widgets/modal_cerrar_sesion.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/widget/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

editarNumero(BuildContext context) {
  final MiNegocioViewModel viewModel = Get.find();
  var telefonoDefecto = '${prefs.paisUsuario == 'CR' ? '+506' : '+57'}';

  viewModel.controllerInput.text = '$telefonoDefecto ';

  print(telefonoDefecto + '${prefs.paisUsuario}');
  return showDialog(
      context: context,
      builder: (context) => CustomDialog(
            title: Icon(
              Icons.info_outlined,
              size: 60,
              color: ConstantesColores.agua_marina,
            ),
            content: Column(children: [
              Text(
                'Por favor ingrese su número de WhatsApp',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10, top: 15),
                decoration: BoxDecoration(
                  color: HexColor("#E4E3EC"),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.number,
                  textAlignVertical: TextAlignVertical.top,
                  controller: viewModel.controllerInput,
                  style: TextStyle(color: Colors.black, fontSize: 15),
                  decoration: InputDecoration(
                    fillColor: Colors.black,
                    hintText: '$telefonoDefecto . . .',
                    hintStyle: TextStyle(
                      color: ConstantesColores.agua_marina,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                  ),
                ),
              ),
              Obx(() => Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      viewModel.validarInputNumero.value,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  )),
            ]),
            hasRightButton: true,
            onLeftPressed: () =>
                viewModel.validarNumero(context, telefonoDefecto),
          ));
}
