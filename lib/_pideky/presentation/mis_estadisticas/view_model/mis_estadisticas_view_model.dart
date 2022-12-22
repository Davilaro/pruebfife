import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/domain/estadistica/model/estadistica.dart';
import 'package:emart/_pideky/domain/estadistica/service/estadistica_service.dart';
import 'package:emart/_pideky/infrastructure/mis_estadisticas/mis_estadisticas_sqlite.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MisEstadisticasViewModel extends GetxController {
  EstadisticaService misEstadisticasService =
      EstadisticaService(EstadisticasRepositorySqlite());

  RxList listTopMarcas = [].obs;
  RxList listTopSubCategorias = [].obs;
  RxList listTopProductos = [].obs;

  initData() {
    cargarTopMarcas();
    cargarTopSubCategorias();
    cargarTopProductos();
    print('top 1 --- ${listTopMarcas.toList()}');
    print('top 2 --- ${listTopSubCategorias.toList()}');
    print('top 3 --- ${listTopProductos.toList()}');
  }

  void cargarTopMarcas() async {
    listTopMarcas.value = await misEstadisticasService.consultarTopMarcas();
  }

  void cargarTopSubCategorias() async {
    listTopSubCategorias.value =
        await misEstadisticasService.consultarTopSubCategorias();
  }

  void cargarTopProductos() async {
    listTopProductos.value =
        await misEstadisticasService.consultarTopProductos();
  }

  static MisEstadisticasViewModel get findOrInitialize {
    try {
      return Get.find<MisEstadisticasViewModel>();
    } catch (e) {
      Get.put(MisEstadisticasViewModel());
      return Get.find<MisEstadisticasViewModel>();
    }
  }
}
