import 'package:emart/_pideky/domain/decuentos_carrito/interface/i_descuento_carrito.dart';
import 'package:emart/_pideky/domain/decuentos_carrito/model/decuento_model.dart';

class DescuentoCarritoService {
  final IDescuentoCarrito iDescuentoCarrito;
  DescuentoCarritoService(this.iDescuentoCarrito);

  Future<List<DescuentoModel>> getDescuentosCarrito(String sku) =>
      iDescuentoCarrito.getDescuentosCarrito(sku);
}
