import 'dart:typed_data';
import 'package:emart/shared/widgets/modal_cerrar_sesion.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/provider/servicios.dart';
import 'package:emart/src/utils/util.dart';
import 'package:emart/src/utils/alertas.dart' as alert;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MiNegocioViewModel extends GetxController {
  TextEditingController controllerInput = TextEditingController();
  Uint8List? politicasDatosPdf;
  Uint8List? terminosDatosPdf;
  RxString validarInputNumero = ''.obs;
  RxString version = ''.obs;

  iniciarModalCerrarSesion(context, size, provider) {
    showLoaderDialog(context, modalCerrarSesion(context, size, provider));
  }

  iniciarModalEliminarUsuario(context, size, provider) {
    showLoaderDialog(context, modalEliminarUsuario(context, size, provider));
  }

  void validarVersion() async {
    version.value = await cargarVersion();
  }

  showLoaderDialog(BuildContext context, Widget widget) {
    AlertDialog alert = AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        content: widget);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  validarNumero(context, String telefonoDefecto) async {
    var telefono = controllerInput.text.split(telefonoDefecto);
    if (telefono[telefono.length > 1 ? 1 : 0].length - 1 == 10) {
      validarInputNumero.value = '';
      var res = await Servicies().editarTelefonoWhatsapp(
          '$telefonoDefecto ${telefono[telefono.length > 1 ? 1 : 0]}');
      if (res == 200) {
        await DBProvider.db.editarTelefonoWhatsapp(
            '$telefonoDefecto${telefono[telefono.length > 1 ? 1 : 0]}');
        Navigator.pop(context);
        alert.mostrarAlert(
            context,
            'Guardamos tu número de WhatsApp con éxito!',
            Icon(
              Icons.check_circle_outline_outlined,
              size: 65,
              color: ConstantesColores.agua_marina,
            ));
      } else {
        alert.mostrarAlert(context, 'Se a generado un error', null);
      }
    } else {
      validarInputNumero.value =
          'La cantidad de caracteres debe ser igual a 10, sin contar el $telefonoDefecto';
    }
  }

  cargarArchivos(Preferencias prefs) async {
    try {
      if (prefs.usurioLogin == 1) {
        politicasDatosPdf = await Servicies().cargarArchivo(
            await DBProvider.db.consultarDocumentoLegal('Políticas'));
        terminosDatosPdf = await Servicies().cargarArchivo(
            await DBProvider.db.consultarDocumentoLegal('Términos'));
        update();
      }
    } catch (e) {
      print('Error al cagar archivos $e');
    }
  }

  static MiNegocioViewModel get findOrInitialize {
    try {
      return Get.find<MiNegocioViewModel>();
    } catch (e) {
      Get.put(MiNegocioViewModel());
      return Get.find<MiNegocioViewModel>();
    }
  }
}
