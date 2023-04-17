import 'package:emart/_pideky/presentation/mis_pedidos/view_model/mis_pedidos_view_model.dart';
import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';
import 'package:get/get.dart';

class RepetirOrdenViewModel extends GetxController {
  final misPedidosViewModel = Get.find<MisPedidosViewModel>();
  validarFrecuenciaPedidoRapido(
    numeroDocumento,
    String fabricante,
    RxBool isFrecuencia,
    ProductoViewModel productViewModel,
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
