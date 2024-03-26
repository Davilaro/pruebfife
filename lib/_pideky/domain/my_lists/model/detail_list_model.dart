import 'dart:convert';

DetailList listaDetalleFromJson(String str) =>
    DetailList.fromJson(json.decode(str));

String listaDetalleToJson(DetailList data) => json.encode(data.toJson());

class DetailList {
  final int id;
  final String nombreLista;
  final String nombreProducto;
  final String codigo;
  int cantidad;
  final double precio;
  final String nombreComercial;
  final String proveedor;
  bool? isSelected = false;

  DetailList({
    required this.id,
    required this.nombreLista,
    required this.codigo,
    required this.cantidad,
    required this.proveedor,
    required this.nombreProducto,
    required this.precio,
    required this.nombreComercial,
  });

  DetailList copyWith(
          {int? id,
          String? nombre,
          String? codigo,
          int? cantidad,
          String? proveedor,
          double? precio,
          String? nombreComercial,
          String? icon,
          String? nombreProducto}) =>
      DetailList(
        id: id ?? this.id,
        nombreLista: nombre ?? this.nombreLista,
        codigo: codigo ?? this.codigo,
        cantidad: cantidad ?? this.cantidad,
        proveedor: proveedor ?? this.proveedor,
        nombreProducto: nombreProducto ?? this.nombreProducto,
        precio: precio ?? this.precio,
        nombreComercial: nombreComercial ?? this.nombreComercial,
      );

  factory DetailList.fromJson(Map<String, dynamic> json) => DetailList(
        id: json["Id"],
        nombreLista: json["nombreLista"],
        codigo: json["codigo"],
        cantidad: json["Cantidad"],
        proveedor: json["proveedor"],
        nombreProducto: json["nombre"],
        precio: json['precio'],
        nombreComercial: json['nombreComercial'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombreLista,
        "codigo": codigo,
        "cantidad": cantidad,
        "proveedor": proveedor,
        "nombreProducto": nombreProducto,
      };
}
