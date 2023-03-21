import 'package:emart/_pideky/presentation/mis_pagos_nequi/view_model/mis_pagos_nequi_controller.dart';
import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

List<Widget> listaPagosRealizadosFecha(BuildContext context) {
  final controller = Get.find<MisPagosNequiController>();
  List<Widget> lista = [];
  var outputFormat = DateFormat("dd/MM/yy");

  if (controller.listaPagosRealizados.isNotEmpty) {
    controller.listaPagosRealizados.forEach((element) {
      var fecha = outputFormat.parse(element.fechaPago);

      String fechaFinal = outputFormat.format(fecha);
      lista.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Text(
          "$fechaFinal",
          style: TextStyle(color: ConstantesColores.gris_sku, fontSize: 13),
        ),
      ));
    });
  }

  return lista;
}

List<Widget> listaPagosRealizadosValor(BuildContext context) {
  final controller = Get.find<MisPagosNequiController>();
  ProductoViewModel productViewModel = Get.find();

  List<Widget> lista = [];

  if (controller.listaPagosRealizados.isNotEmpty) {
    controller.listaPagosRealizados.forEach((element) {
      lista.add(Padding(
        padding: const EdgeInsets.only(top: 7, bottom: 7, left: 25),
        child: Text(
          productViewModel.getCurrency(toInt(element.valorPago)),
          style: TextStyle(color: ConstantesColores.gris_sku, fontSize: 13),
        ),
      ));
    });
  }

  return lista;
}
