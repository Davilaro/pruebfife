import 'package:emart/_pideky/presentation/my_orders/view_model/mis_pedidos_view_model.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:get/get.dart';

class RepetirOrdenViewModel extends GetxController {
  final misPedidosViewModel = Get.find<MyOrdersViewModel>();
  validarFrecuenciaPedidoRapido(
    numeroDocumento,
    String fabricante,
    RxBool isFrecuencia,
    ProductViewModel productViewModel,
    RxString fabricanteFrecuencia,
  ) async {
    var res = await misPedidosViewModel.misPedidosService
        .consultarDetalleGrupo(numeroDocumento, fabricante);
    fabricanteFrecuencia.value = res[0].fabricante.toString();
    isFrecuencia.value =
        productViewModel.validarFrecuencia(res[0].fabricante.toString());
  }

  static RepetirOrdenViewModel get findOrInitialize {
    try {
      return Get.find<RepetirOrdenViewModel>();
    } catch (e) {
      Get.put(RepetirOrdenViewModel());
      return Get.find<RepetirOrdenViewModel>();
    }
  }
}
