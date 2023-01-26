import 'package:emart/_pideky/domain/estadistica/service/estadistica_service.dart';
import 'package:emart/_pideky/infrastructure/mis_estadisticas/mis_estadisticas_sqlite.dart';
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
  }

  void cargarTopMarcas() async {
    listTopMarcas.value = await misEstadisticasService.consultarTopMarcas();
    print('respuesta top marca ${listTopMarcas.length}');
  }

  void cargarTopSubCategorias() async {
    listTopSubCategorias.value =
        await misEstadisticasService.consultarTopSubCategorias();
    print('respuesta top subcategoria ${listTopSubCategorias.length}');
  }

  void cargarTopProductos() async {
    listTopProductos.value =
        await misEstadisticasService.consultarTopProductos();
    print('respuesta top producto ${listTopProductos.length}');
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
