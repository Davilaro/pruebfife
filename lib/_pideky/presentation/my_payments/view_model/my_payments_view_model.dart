import 'package:emart/_pideky/domain/my_payments/use_cases/my_payments_use_cases.dart';
import 'package:emart/_pideky/infrastructure/my_payments/my_payments_service.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyPaymentsViewModel extends GetxController {
  MyPaymentsUseCases pagosNequiService;
  MyPaymentsViewModel(this.pagosNequiService);

  RxString numeroCelular = "".obs;
  RxList listaPagosRealizados = [].obs;
  RxList listaPagosPendientes = [].obs;
  var listaPagos = [];
  final prefs = new Preferencias();

  obtenerPagosNequi() async {
    listaPagos = await pagosNequiService.consultarPagosNequi();

    agruparListas(listaPagos);
    listaPagos.sort((a, b) {
      DateTime fechaA = DateFormat('dd/MM/yyyy').parse(a.fechaPago);
      DateTime fechaB = DateFormat('dd/MM/yyyy').parse(b.fechaPago);
      return fechaA.compareTo(fechaB);
    });

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
    //ordena los la liste de manera descendente
    listaPagosRealizados.sort((a, b) {
      DateTime fechaA = DateFormat('dd/MM/yyyy').parse(a.fechaPago);
      DateTime fechaB = DateFormat('dd/MM/yyyy').parse(b.fechaPago);
      return fechaA.compareTo(fechaB);
    });
    listaPagosPendientes.sort((a, b) {
      DateTime fechaA = DateFormat('dd/MM/yyyy').parse(a.fechaPago);
      DateTime fechaB = DateFormat('dd/MM/yyyy').parse(b.fechaPago);
      return fechaA.compareTo(fechaB);
    });
    if (lista.length != 0) {
      numeroCelular.value =
          listaPagos.first.celular != "" ? listaPagos.first.celular : "";
    }
  }

  initData() {
    listaPagosPendientes.clear();
    listaPagosRealizados.clear();
    obtenerPagosNequi();
  }

  static MyPaymentsViewModel get findOrInitialize {
    try {
      return Get.find<MyPaymentsViewModel>();
    } catch (e) {
      Get.put(MyPaymentsViewModel(MyPaymentsUseCases(MisPagosNequiSqlite())));
      return Get.find<MyPaymentsViewModel>();
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
