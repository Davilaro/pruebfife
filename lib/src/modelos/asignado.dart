

import 'package:emart/src/modelos/productos.dart';

class ProductoAsignado {

  ProductoAsignado({
         this.codigo,
         this.nombre,
         this.fabricante,
         this.cantidad,
         this.precio,
         this.productos,
    });


  String? codigo;
  String? nombre;
  String? fabricante;
  double? precio;
  int? cantidad;
  Productos? productos;


   @override
  String toString() {
    return '{$codigo, $nombre}' ;
  }

}