import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:emart/src/widget/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void mostrarAlert(BuildContext context, String mensaje, Widget? icon) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            content: Container(
              constraints: BoxConstraints(
                  minHeight: 200, minWidth: double.infinity, maxHeight: 300),
              child: SingleChildScrollView(
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
                    Container(
                      height: 50,
                      width: 50,
                      child: icon != null
                          ? icon
                          : Image.asset('assets/alerta_img.png'),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text(
                        '$mensaje',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: GestureDetector(
                        onTap: () => {Navigator.of(context).pop()},
                        child: Container(
                          height: 40,
                          width: double.infinity,
                          child: Image.asset(
                            "assets/btn_aceptar.png",
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

void mostrarAlertaUtilsError(BuildContext context, String mensaje) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          content: Container(
            constraints: BoxConstraints(
                minHeight: 200, minWidth: double.infinity, maxHeight: 300),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    child: Image.asset('assets/alerta_img.png'),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Text(
                      '¡Lo sentimos! No hemos podido procesar tu orden. Por favor comunícate con nuestro equipo de ayuda.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: GestureDetector(
                      onTap: () => {Navigator.of(context).pop()},
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        child: Image.asset(
                          "assets/btn_aceptar.png",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

void alertCustom(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: CustomDialog(
            title: Container(
                margin: EdgeInsets.only(top: 40),
                child: Text(
                  'Activa tu cuenta!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      color: ConstantesColores.azul_precio,
                      fontWeight: FontWeight.bold),
                )),
            isVertical: true,
            hasLeftButton: true,
            hasRightButton: true,
            onRightPressed: () {
              Provider.of<OpcionesBard>(context, listen: false)
                  .selectOptionMenu = 0;
              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  'tab_opciones', (Route<dynamic> route) => false);
            },
            onLeftPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Login())),
            content: Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'para comprar en Pideky y ver los datos de tu negocio debes activar tu cuenta',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                )),
          ),
        );
      });
}
