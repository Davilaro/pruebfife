import 'package:emart/_pideky/domain/producto/model/producto.dart';

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
  Producto? productos;

  @override
  String toString() {
    return '{$codigo, $nombre}';
  }
}
