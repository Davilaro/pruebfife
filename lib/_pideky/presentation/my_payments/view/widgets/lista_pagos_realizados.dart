import 'package:emart/_pideky/presentation/my_payments/view_model/my_payments_view_model.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

List<Widget> listaPagosRealizadosFecha(BuildContext context) {
  final controller = Get.find<MyPaymentsViewModel>();
  List<Widget> lista = [];
  var outputFormat = DateFormat("dd/MM/yy");

  if (controller.listaPagosRealizados.isNotEmpty) {
    controller.listaPagosRealizados.reversed.forEach((element) {
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
  final controller = Get.find<MyPaymentsViewModel>();
  ProductViewModel productViewModel = Get.find();

  List<Widget> lista = [];

  if (controller.listaPagosRealizados.isNotEmpty) {
    controller.listaPagosRealizados.reversed.forEach((element) {
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
