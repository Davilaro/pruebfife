import 'package:emart/_pideky/domain/pagos_nequi/service/pagos_nequi_service.dart';
import 'package:emart/_pideky/infrastructure/mis_pagos_nequi/mis_pagos_nequi_sqlite.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:get/get.dart';

class MisPagosNequiController extends GetxController {
  PagosNequiService pagosNequiService;
  MisPagosNequiController(this.pagosNequiService);

  RxString numeroCelular = "".obs;
  RxList listaPagosRealizados = [].obs;
  RxList listaPagosPendientes = [].obs;
  var listaPagos = [];
  final prefs = new Preferencias();

  obtenerPagosNequi() async {
    listaPagos = await pagosNequiService.consultarPagosNequi();
    numeroCelular.value =
        listaPagos.first.celular != "" ? listaPagos.first.celular : "";
    agruparListas(listaPagos);

    print(numeroCelular);
  }

  agruparListas(lista) {
    listaPagos.forEach((element) {
      if (element.tipoPago == 1) {
        listaPagosRealizados.add(element);
      } else {
        listaPagosPendientes.add(element);
      }
    });
  }

  initData() {
    listaPagosPendientes.clear();
    listaPagosRealizados.clear();
    obtenerPagosNequi();
  }

  static MisPagosNequiController get findOrInitialize {
    try {
      return Get.find<MisPagosNequiController>();
    } catch (e) {
      Get.put(
          MisPagosNequiController(PagosNequiService(MisPagosNequiSqlite())));
      return Get.find<MisPagosNequiController>();
    }
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
