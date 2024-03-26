import 'package:emart/_pideky/domain/product/model/product_model.dart';

class ProductoAsignado {
  ProductoAsignado({
    this.codigo,
    this.nombre,
    this.fabricante,
    this.cantidad,
    this.precio,
    this.descuento,
    this.productos,
  });

  String? codigo;
  String? nombre;
  String? fabricante;
  double? precio;
  double? descuento;
  int? cantidad;
  Product? productos;

  @override
  String toString() {
    return '{$codigo, $nombre}';
  }
}
