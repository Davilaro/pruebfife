import 'package:emart/_pideky/domain/statistics/use_cases/statistics_use_cases.dart';
import 'package:emart/_pideky/infrastructure/statistics/statistics_service.dart';
import 'package:get/get.dart';

class MyStatisticsViewModel extends GetxController {
  StatisticsUseCases misEstadisticasService =
      StatisticsUseCases(EstadisticasRepositorySqlite());

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

  static MyStatisticsViewModel get findOrInitialize {
    try {
      return Get.find<MyStatisticsViewModel>();
    } catch (e) {
      Get.put(MyStatisticsViewModel());
      return Get.find<MyStatisticsViewModel>();
    }
  }
}
