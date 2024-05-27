// ignore_for_file: unnecessary_statements

import 'package:emart/_pideky/presentation/customers_prospection/view_model/customers_prospect_view_model.dart';
import 'package:emart/_pideky/presentation/customers_prospections_sura/view/customer_prospection_sura_page.dart';
import 'package:emart/_pideky/presentation/my_lists/view_model/my_lists_view_model.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/src/controllers/validations_forms.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/servicios.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../widget/soporte.dart';

void mostrarAlert(
  BuildContext context,
  String mensaje,
  Widget? icon, {
  Function()? onTap,
}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final controllerForm = Get.find<ValidationForms>();
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
                            onTap: () => {
                              controllerForm.isClosePopup.value = true,
                              Get.back()
                            },
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
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Text(
                        '$mensaje',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: GestureDetector(
                        onTap: onTap ??
                            () {
                              Get.back();
                            },
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
                    child: Image.asset('assets/image/alerta_img.png'),
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
                          "assets/image/btn_aceptar.png",
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

void mostrarAlertCustomWidgetOld(
  BuildContext context,
  Widget mensaje,
  Widget? icon,
  Widget? iconClose,
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
            contentPadding: EdgeInsets.zero,
            content: Container(
              // color: Colors.amber,
              constraints: BoxConstraints(
                  minHeight: 200, minWidth: double.infinity, maxHeight: 350),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.cancel_outlined,
                            color: ConstantesColores.azul_precio,
                            size: 39,
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: iconClose == null ? false : true,
                      child: Container(
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
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      child: icon != null
                          ? icon
                          : Image.asset(
                              'assets/image/alerta_img.png',
                            ),
                    ),
                    Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: mensaje),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          // Get.off(() => Soporte(numEmpresa: 1));
                          Get.off(() => CustomersProspectionSuraPage());
                        },
                        label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Text(
                            'Solicitar ayuda',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                        backgroundColor: ConstantesColores.azul_precio,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(25), // Borde circular
                        ),
                      ),
                    ),
                    SizedBox(height: 25)
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

void mostrarAlertCartera(
  BuildContext context,
  String mensaje,
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
                  minHeight: 200, minWidth: double.infinity, maxHeight: 300),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    icon != null
                        ? icon
                        : Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.red,
                            size: 80.0,
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

Future<void> mostrarAlertCarteraEliminarLista(BuildContext context,
    String mensaje, Widget? icon, String nombreLista, idLista) async {
  final miListasViewModel = Get.find<MyListsViewModel>();
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  icon != null
                      ? icon
                      : Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red,
                          size: 80.0,
                        ),
                  Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: mensaje,
                          style: TextStyle(
                            color: ConstantesColores.gris_oscuro,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: " $nombreLista?",
                              style: TextStyle(
                                color: ConstantesColores.azul_precio,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: GestureDetector(
                      onTap: () async {
                        await miListasViewModel.deleteList(
                            context, nombreLista, idLista);
                        Get.back();
                        Get.back();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                        ),
                        height: 40,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            "assets/image/btn_aceptar.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ConstantesColores.gris_oscuro,
                            width: 1,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadiusDirectional.all(
                            Radius.circular(50),
                          ),
                        ),
                        child: Text(
                          "Cancelar",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ConstantesColores.gris_oscuro,
                            fontSize: 16,
                          ),
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

void mostrarAlertaPopUpVisto(
    BuildContext context, String proveedores, List<Map> listaProveedores) {
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: ConstantesColores.agua_marina,
                      size: 74.0,
                    ),
                    Container(
                      margin: const EdgeInsets.all(2),
                      width: Get.width * 0.7,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: new RichText(
                        textAlign: TextAlign.center,
                        text: new TextSpan(
                          text: "Ahora tienes disponibles los productos de ",
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                          children: <TextSpan>[
                            new TextSpan(
                              text: "$proveedores.",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            new TextSpan(
                              text: " Agrégalos en tu siguiente pedido.",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: BotonAgregarCarrito(
                        color: ConstantesColores.azul_aguamarina_botones,
                        height: 40,
                        onTap: () async {
                          await Servicies().sendOnPressInactivityByPortfolio(
                              listaProveedores);
                          Get.back();
                        },
                        text: 'Aceptar',
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
