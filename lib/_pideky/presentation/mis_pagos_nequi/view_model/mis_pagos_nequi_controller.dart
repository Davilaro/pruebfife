import 'package:emart/_pideky/domain/pagos_nequi/service/pagos_nequi_service.dart';
import 'package:get/get.dart';

class MisPagosNequiController extends GetxController {
  PagosNequiService pagosNequiService;
  MisPagosNequiController(this.pagosNequiService);

  RxString numeroCelular = "".obs;
  RxList listaPagosRealizados = [].obs;
  RxList listaPagosPendientes = [].obs;
  var listaPagos = [];

  obtenerPagosNequi() async {
    listaPagos = await pagosNequiService.consultarPagosNequi();
    numeroCelular.value = listaPagos.first.celular!;
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

  @override
  void onInit() {
    initData();
    super.onInit();
  }
}
