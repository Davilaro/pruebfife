import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';
import 'package:get/get.dart';

import '../../../provider/db_provider_helper.dart';

class RepetirOrdenViewModel extends GetxController {
  validarFrecuenciaPedidoRapido(
    numeroDocumento,
    String fabricante,
    RxBool isFrecuencia,
    ProductoViewModel productViewModel,
    RxString fabricanteFrecuencia,
  ) async {
    var res = await DBProviderHelper.db
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
