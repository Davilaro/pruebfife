import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:get/get.dart';

class CambioEstadoProductos extends GetxController {
  RxBool isAgotado = false.obs;
  RxInt cambioEstado = 1.obs;
  var dato = new ProductoCambiante().obs;
  var cambiarEscala = 0.5.obs;
  var controllerCantidadProducto = '1'.obs;
  RxMap mapaHistoricos = {}.obs;
  void cargarProductoNuevo(ProductoCambiante productos, int vantana) {
    this.cambioEstado.value = vantana;
    this.dato.value = productos;
  }

  void cambioEscala(double escala) {
    this.cambiarEscala.value = escala;
  }

  void cambiarValoresEditex(String escala) {
    this.controllerCantidadProducto.value = escala;
  }
}
