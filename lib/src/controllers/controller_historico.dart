import 'package:auto_size_text/auto_size_text.dart';
import 'package:emart/_pideky/presentation/my_orders/view_model/mis_pedidos_view_model.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControllerHistorico extends GetxController {
  RxString fechaInicial = '-1'.obs;
  RxString fechaFinal = '-1'.obs;
  final misPedidosViewModel = Get.find<MyOrdersViewModel>();

  void setFechaInicial(String val) {
    fechaInicial.value = val;
  }

  void setFechaFinal(String val) {
    fechaFinal.value = val;
  }

  void inicializarController() {
    fechaInicial = '-1'.obs;
    fechaFinal = '-1'.obs;
  }

  ///CARGAR ITEMS DORPDOWN
  List<DropdownMenuItem<String>> getDropdownItemsDia(String mes, String ano) {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.add(DropdownMenuItem(
        child: Text(
          'Dia            ',
          style: TextStyle(
              color: ConstantesColores.azul_precio,
              fontSize: 13,
              fontWeight: FontWeight.bold),
        ),
        value: ''));

    if (mes == '2' && ano == '2024' ||
        ano == '2028' ||
        ano == '2032' ||
        ano == '2036' ||
        ano == '2040' ||
        ano == '2044' ||
        ano == '2048') {
      for (int i = 1; i <= 29; i++) {
        menuItems.add(DropdownMenuItem(
            child: Text('$i',
                style: TextStyle(
                    color: ConstantesColores.azul_precio,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
            value: '$i'));
      }
    } else if (mes == '2') {
      for (int i = 1; i <= 28; i++) {
        menuItems.add(DropdownMenuItem(
            child: Text('$i',
                style: TextStyle(
                    color: ConstantesColores.azul_precio,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
            value: '$i'));
      }
    } else if (mes == '4' || mes == '6' || mes == '9' || mes == '11') {
      for (int i = 1; i <= 30; i++) {
        menuItems.add(DropdownMenuItem(
            child: Text('$i',
                style: TextStyle(
                    color: ConstantesColores.azul_precio,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
            value: '$i'));
      }
    } else {
      for (int i = 1; i <= 31; i++) {
        menuItems.add(DropdownMenuItem(
            child: Text('$i',
                style: TextStyle(
                    color: ConstantesColores.azul_precio,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
            value: '$i'));
      }
    }

    return menuItems;
  }

  validarFiltro(
      BuildContext context, String fechaInicial, String fechaFin) async {
    var res =
        await misPedidosViewModel.getHistorico('-1', fechaInicial, fechaFin);
    if (res.length > 0) {
      return true;
    } else {
      String mensaje = 'No encontramos registros para esas fechas';
      mostrarAlert(context, mensaje, null);
      return false;
    }
  }

  ///CARGAR ITEMS DORPDOWN
  List<DropdownMenuItem<String>> getDropdownItemsMes() {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.add(DropdownMenuItem(child: textCustomation('Mes'), value: ''));
    menuItems.add(DropdownMenuItem(
      child: textCustomation('Enero'),
      value: '1',
    ));
    menuItems
        .add(DropdownMenuItem(child: textCustomation('Febrero'), value: '2'));
    menuItems
        .add(DropdownMenuItem(child: textCustomation('Marzo'), value: '3'));
    menuItems
        .add(DropdownMenuItem(child: textCustomation('Abril'), value: '4'));
    menuItems.add(DropdownMenuItem(child: textCustomation('Mayo'), value: '5'));
    menuItems
        .add(DropdownMenuItem(child: textCustomation('Junio'), value: '6'));
    menuItems
        .add(DropdownMenuItem(child: textCustomation('Julio'), value: '7'));
    menuItems
        .add(DropdownMenuItem(child: textCustomation('Agosto'), value: '8'));
    menuItems.add(
        DropdownMenuItem(child: textCustomation('Septiembre'), value: '9'));
    menuItems
        .add(DropdownMenuItem(child: textCustomation('Octubre'), value: '10'));
    menuItems.add(
        DropdownMenuItem(child: textCustomation('Noviembre'), value: '11'));
    menuItems.add(
        DropdownMenuItem(child: textCustomation('Diciembre'), value: '12'));

    return menuItems;
  }

  ///CARGAR ITEMS DORPDOWN
  List<DropdownMenuItem<String>> getDropdownItemsAno() {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.add(DropdownMenuItem(
        child: Text(
          'Año            ',
          style: TextStyle(
              color: ConstantesColores.azul_precio,
              fontSize: 13,
              fontWeight: FontWeight.bold),
        ),
        value: ''));
    for (int i = 2021; i <= 2050; i++) {
      menuItems.add(DropdownMenuItem(
          child: AutoSizeText('$i',
              maxLines: 1,
              style: TextStyle(
                  color: ConstantesColores.azul_precio,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          value: '$i'));
    }

    return menuItems;
  }

  textCustomation(String texto) {
    return AutoSizeText(
      texto.substring(0, 3),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: ConstantesColores.azul_precio,
          fontSize: 13,
          fontWeight: FontWeight.bold),
    );
  }
}
