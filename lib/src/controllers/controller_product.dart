import 'package:emart/src/provider/db_provider.dart';
import 'package:get/get.dart';

class ControllerProductos extends GetxController {
  RxList<dynamic> listAgotados = [].obs;
  RxDouble precioMinimo = 0.0.obs;
  RxDouble precioMaximo = 1000000.0.obs;
  bool isFilter = false;

  @override
  void dispose() {
    precioMinimo.value = 0.0;
    precioMaximo.value = 1000000.0;
    super.dispose();
  }

  void getAgotados() async {
    var res = await DBProvider.db.consultarAgotados();
    listAgotados.value = res;
  }

  void setIsFilter(bool val) {
    isFilter = val;
  }

  void setPrecioMinimo(double val) {
    precioMinimo.value = val;
  }

  void setPrecioMaximo(double val) {
    precioMaximo.value = val;
  }

  bool validarAgotado(product) {
    var isAgotado = false;
    for (var element in listAgotados) {
      if (element.respuesta == product.codigo) {
        isAgotado = true;
        break;
      }
    }
    return isAgotado;
  }
}
