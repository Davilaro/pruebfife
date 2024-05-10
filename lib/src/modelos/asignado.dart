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
    this.isOferta,
    this.cantidadMaxima,
    this.cantidadSolicitada,
  });

  String? codigo;
  String? nombre;
  String? fabricante;
  double? precio;
  double? descuento;
  int? cantidad;
  Product? productos;
  int? isOferta;
  int? cantidadMaxima;
  int? cantidadSolicitada;

  @override
  String toString() {
    return '{$codigo, $nombre}';
  }
}
