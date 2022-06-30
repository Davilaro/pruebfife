import 'package:emart/src/pages/notificaciones/notificaciones_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccionNotificacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 0),
      child: IconButton(
        icon: Image.asset('assets/notificacion_btn.png'),
        tooltip: 'Show Snackbar',
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NotificacionesPage()));
        },
      ),
    );
  }
}

showLoaderDialog(BuildContext context, Widget widget) {
  AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0))),
      content: Container(
          height: Get.height * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white,
          ),
          child: widget));
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
