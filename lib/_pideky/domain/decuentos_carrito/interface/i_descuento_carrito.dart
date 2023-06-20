import 'package:emart/_pideky/domain/decuentos_carrito/model/decuento_model.dart';

abstract class IDescuentoCarrito {
  Future<List<DescuentoModel>> getDescuentosCarrito(String sku);
}
