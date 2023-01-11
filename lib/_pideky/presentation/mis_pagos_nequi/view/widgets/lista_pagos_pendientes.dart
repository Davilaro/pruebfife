import 'package:emart/src/pages/carrito/carrito_compras.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../view_model/mis_pagos_nequi_controller.dart';

List<Widget> listaPagosPendientesFecha(BuildContext context) {
  final controller = Get.find<MisPagosNequiController>();
  List<Widget> lista = [];
  var outputFormat = DateFormat("dd/MM/yy HH:mm");
  var inputFormat = DateFormat("yyyy-MM-dd HH:mm");

  if (controller.listaPagosPendientes.isNotEmpty) {
    controller.listaPagosPendientes.forEach((element) {
      var fecha = inputFormat.parse(element.fechaPago);
      String fechaFinal = outputFormat.format(fecha);
      lista.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Text(
          "${fechaFinal.replaceAll(" 00:00", "")}",
          style: TextStyle(color: ConstantesColores.gris_sku, fontSize: 13),
        ),
      ));
    });
  }

  return lista;
}

List<Widget> listaPagosPendientesValor(BuildContext context) {
  final controller = Get.find<MisPagosNequiController>();
  var locale = Intl().locale;
  var format = locale.toString() != 'es_CO'
      ? locale.toString() != 'es_CR'
          ? NumberFormat.currency(locale: locale.toString(), symbol: '\₡')
          : NumberFormat.simpleCurrency(locale: locale.toString())
      : NumberFormat.currency(locale: locale.toString(), symbol: '\$');
  NumberFormat formatNumber = new NumberFormat("#,##0.00", "es_AR");
  List<Widget> lista = [];

  if (controller.listaPagosPendientes.isNotEmpty) {
    controller.listaPagosPendientes.forEach((element) {
      lista.add(Padding(
        padding: const EdgeInsets.only(top: 7, bottom: 7, left: 25),
        child: Text(
          "${format.currencySymbol}" +
              formatNumber
                  .format(toInt(element.valorPago))
                  .replaceAll(",00", ""),
          style: TextStyle(color: ConstantesColores.gris_sku, fontSize: 13),
        ),
      ));
    });
  }

  return lista;
}
