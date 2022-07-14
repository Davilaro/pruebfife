import 'package:get/get.dart';

class ControllerHistorico extends GetxController {
  RxString dia = '-1'.obs;
  RxString mes = '-1'.obs;
  RxString ano = '-1'.obs;

  RxString fechaInicial = '-1'.obs;
  RxString fechaFinal = '-1'.obs;
  RxString filtro = '-1'.obs;

  void setFechaInicial(String val) {
    fechaInicial.value = val;
  }

  void setFechaFinal(String val) {
    fechaFinal.value = val;
  }

  void setFiltro(String val) {
    filtro.value = val;
  }
}
