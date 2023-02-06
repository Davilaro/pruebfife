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
