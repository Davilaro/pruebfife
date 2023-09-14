import 'package:emart/generated/l10n.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:emart/src/widget/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

Future<void> showPopup(
  BuildContext context,
  String mensaje,
  Widget? icon,
) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          contentPadding: EdgeInsets.only(top: 5, right: 7, bottom: 30),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  //color: Colors.red,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.cancel_outlined,
                          color: ConstantesColores.azul_precio,
                          size: 39,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  //color: Colors.amber,
                  padding: EdgeInsets.only(top: 30),
                  height: 100,
                  width: 100,
                  child: icon != null
                      ? icon
                      : Image.asset('assets/image/alerta_img.png'),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 55),
                  child: Text(
                    mensaje,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: 1,
                        color: HexColor("#41398D"),
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

void showPopupFindClientCode(
  BuildContext context,
  // String mensaje,
  Widget? icon,
) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          contentPadding: EdgeInsets.only(top: 5, right: 7, bottom: 30),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  //color: Colors.red,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(
                          Icons.cancel_outlined,
                          color: ConstantesColores.azul_precio,
                          size: 39,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Text(
                    'Encuentra tu código cliente de \n Comercial Nutresa cerca de la esquina \n superior derecha de tu factura',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: 1,
                        color: HexColor("#41398D"),
                        fontSize: 15.0,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                Container(
                  color: Colors.amber,
                  // padding: EdgeInsets.only(top:15),
                  // height: 150,
                  // width: 280,
                  child: icon != null
                      ? icon
                      : Image.asset(
                          'assets/image/factura_imagen.png',
                          fit: BoxFit.contain,
                        ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Text(
                    'Es un código de 12 números \n junto a tu nombre',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: 1,
                        color: HexColor("#41398D"),
                        fontSize: 15.0,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

void showPopupUnrecognizedfingerprint(
  BuildContext context,
  String mensaje,
  Widget? icon,
) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          contentPadding:
              EdgeInsets.only(top: 55, left: 30, right: 30, bottom: 30),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    child: icon != null
                        ? icon
                        : Image(
                            image: AssetImage('assets/image/Icon_touch_ID.png'),
                            fit: BoxFit.contain,
                          )),
                SizedBox(height: 20),
                Text(mensaje,
                    style: TextStyle(
                        color: HexColor("#41398D"),
                        fontSize: 20,
                        fontWeight: FontWeight.w900)),
                SizedBox(height: 15.0),
                BotonAgregarCarrito(
                  borderRadio: 35,
                  height: Get.height * 0.06,
                  color: ConstantesColores.empodio_verde,
                  onTap: () {
                    Get.back();
                  },
                  text: "Probar de nuevo",
                ),
                TextButton(
                  child: Text(
                    "Cancelar",
                    style: TextStyle(
                        color: HexColor("#41398D"),
                        fontSize: 18,
                        fontWeight: FontWeight.w900),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        );
      });
}

Future<void> showPopupSuccessfulregistration(
  BuildContext context,
  // String mensaje,
  // Widget? icon,
) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          contentPadding:
              EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 15),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    child: Image(
                  image: AssetImage('assets/image/Icon_correcto.png'),
                  fit: BoxFit.contain,
                )),
                SizedBox(height: 20),
                Text('¡Perfecto!',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w900)),
                SizedBox(height: 15.0),
                Container(
                  // color: Colors.amber,
                  width: double.infinity,
                  child: Text(
                      'Se ha realizado correctamente la petición para ser cliente Pideky, pronto nos pondremos en contacto contigo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,

                        //fontWeight: FontWeight.w500
                      )),
                ),
                BotonAgregarCarrito(
                  borderRadio: 35,
                  height: Get.height * 0.05,
                  color: ConstantesColores.azul_precio,
                  onTap: () {
                    Get.back();
                  },
                  text: "Aceptar",
                ),
              ],
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
                  S.current.activate_your_user,
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
                  S.current.activate_user_for_buy,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                )),
          ),
        );
      });
}

void mostrarAlertCustomWidget(
  BuildContext context,
  Widget mensaje,
  Widget? icon,
) {
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
                  minHeight: 200, minWidth: double.infinity, maxHeight: 350),
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
                            onTap: () => Get.back(),
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
                          : Image.asset('assets/image/alerta_img.png'),
                    ),
                    Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: mensaje),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: GestureDetector(
                        onTap: () => Get.back(),
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
          ),
        );
      });
}
