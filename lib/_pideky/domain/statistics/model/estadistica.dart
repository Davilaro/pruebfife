import 'dart:convert';

Estadistica estadisticaFromJson(String str) =>
    Estadistica.fromJson(json.decode(str));

String estadisticaToJson(Estadistica data) => json.encode(data.toJson());

class Estadistica {
  Estadistica(
      {required this.codigo,
      required this.posicion,
      required this.imagen,
      required this.descripcion,
      required this.cantidad});

  String codigo;
  int posicion;
  String imagen;
  String descripcion;
  int cantidad;

  factory Estadistica.fromJson(Map<String, dynamic> json) => Estadistica(
        codigo: json["codigo"] == null ? '' : json["codigo"],
        posicion: json["posicion"] == null ? 0 : json["posicion"],
        imagen: json["imagen"] == null ? '' : json["imagen"],
        descripcion: json["descripcion"] == null ? '' : json["descripcion"],
        cantidad: json["cantidad"] == null ? 0 : json["cantidad"],
      );

  Map<String, dynamic> toJson() => {
        "codigoSku": codigo,
        "nombre": posicion,
        "precio": imagen,
        "unidad": descripcion,
        "linea": cantidad,
      };
}
