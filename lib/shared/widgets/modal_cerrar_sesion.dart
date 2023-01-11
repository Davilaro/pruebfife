import 'dart:async';

import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/crear_file.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/provider/servicios.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../_pideky/presentation/pedido_sugerido/view_model/pedido_sugerido_controller.dart';
import '../../generated/l10n.dart';

final prefs = new Preferencias();

modalCerrarSesion(context, size, provider) {
  String mensaje =
      "Estas apunto de salir de Pideky, deberás volver a ingresar los datos " +
          "de tu negocio para ver los productos y proveedores.";

  Widget _botonSeguirComprando(size) {
    return GestureDetector(
      onTap: () => {Navigator.pop(context)},
      child: Container(
        width: Get.width * 0.9,
        height: 45,
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: 30,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: ConstantesColores.azul_precio, width: 3.0),
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.contain,
              child: Text('Cancelar',
                  style: TextStyle(
                      color: ConstantesColores.azul_precio,
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _botonAceptar(size, provider) {
    return GestureDetector(
      onTap: () => {
        _showLoaderDialog(context),
        Future.delayed(Duration(milliseconds: 700)).then((value) async {
          await AppUtil.appUtil.eliminarCarpeta();
          prefs.usurioLogin = -1;
          PedidoSugeridoController.userLog.value = -1;
          provider.selectOptionMenu = 0;
          provider.setNumeroClickCarrito = 0;
          provider.setNumeroClickVerImpedibles = 0;
          provider.setNumeroClickVerPromos = 0;
          PedidoEmart.cantItems.value = '0';
          Navigator.pop(context);
          Navigator.of(context).pushNamedAndRemoveUntil(
              'splash', (Route<dynamic> route) => false);
        }),
      },
      child: Container(
        width: Get.width * 0.9,
        height: 45,
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: 10,
        ),
        decoration: BoxDecoration(
          color: ConstantesColores.agua_marina,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Cerrar sesión',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Column(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 70,
                    color: ConstantesColores.agua_marina,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 12),
                    child: Text(
                      "¿Deseas cerrar sesión?",
                      style: TextStyle(
                          color: ConstantesColores.azul_precio,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                    child: Text(
                      mensaje,
                      style: TextStyle(
                          color: ConstantesColores.azul_precio,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  _botonSeguirComprando(size),
                  _botonAceptar(size, provider),
                ],
              )
            ],
          ))
    ],
  );
}

modalEliminarUsuario(context, size, provider) {
  String mensaje = S.current.delete_account_mode +
      S.current.delete_account_mode_confirmation;

  Widget _botonSeguirComprando(size) {
    return GestureDetector(
      onTap: () => {Navigator.pop(context)},
      child: Container(
        width: Get.width * 0.9,
        height: 45,
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: 30,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: ConstantesColores.azul_precio, width: 3.0),
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.contain,
              child: Text('Cancelar',
                  style: TextStyle(
                      color: ConstantesColores.azul_precio,
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _botonAceptar(size, provider) {
    return GestureDetector(
      onTap: () => {
        Future.delayed(Duration(milliseconds: 700)).then((value) async {
          await Servicies().deleteAccount();
          await AppUtil.appUtil.eliminarCarpeta();
          prefs.usurioLogin = -1;
          provider.selectOptionMenu = 0;
          provider.setNumeroClickCarrito = 0;
          provider.setNumeroClickVerImpedibles = 0;
          provider.setNumeroClickVerPromos = 0;
          PedidoEmart.cantItems.value = '0';
          _showLoaderDialogDeleteAccount(context);
          Navigator.pop(context);
          Navigator.of(context).pushNamedAndRemoveUntil(
              'splash', (Route<dynamic> route) => false);
        }),
      },
      child: Container(
        width: Get.width * 0.9,
        height: 45,
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: 10,
        ),
        decoration: BoxDecoration(
          color: ConstantesColores.agua_marina,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Aceptar',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Column(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 70,
                    color: ConstantesColores.agua_marina,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 12),
                    child: Text(
                      "¿Deseas eliminar tu cuenta?",
                      style: TextStyle(
                          color: ConstantesColores.azul_precio,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                    child: Text(
                      mensaje,
                      style: TextStyle(
                          color: ConstantesColores.azul_precio,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  _botonSeguirComprando(size),
                  _botonAceptar(size, provider),
                ],
              )
            ],
          ))
    ],
  );
}

_showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      content: Container(
          height: Get.height * 0.26,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: Get.width * 0.9,
                  margin: EdgeInsets.only(top: 35),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.check_circle_outline_sharp,
                            size: 100,
                            color: ConstantesColores.agua_marina,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 18),
                            child: Text(
                              "!Has cerrado sesión exitosamente!",
                              style: TextStyle(
                                  color: ConstantesColores.azul_precio,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )
                    ],
                  ))
            ],
          )));
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

_showLoaderDialogDeleteAccount(BuildContext context) {
  AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      content: Container(
          height: Get.height * 0.26,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: Get.width * 0.9,
                  margin: EdgeInsets.only(top: 35),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.check_circle_outline_sharp,
                            size: 100,
                            color: ConstantesColores.agua_marina,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 18),
                            child: Text(
                              "!Has eliminado tu cuenta exitosamente!",
                              style: TextStyle(
                                  color: ConstantesColores.azul_precio,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )
                    ],
                  ))
            ],
          )));
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
