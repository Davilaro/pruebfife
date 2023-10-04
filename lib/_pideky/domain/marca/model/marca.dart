import 'dart:convert';

Marca marcasFromJson(String str) => Marca.fromJson(json.decode(str));

String marcasToJson(Marca data) => json.encode(data.toJson());

class Marca {
  Marca({
    required this.codigo,
    required this.nombre,
    required this.ico,
    required this.fabricante,
  });

  String codigo;
  String nombre;
  String ico;
  String fabricante;

  factory Marca.fromJson(Map<String, dynamic> json) => Marca(
        codigo: json["codigo"],
        nombre: json["descripcion"],
        ico: json["ico"],
        fabricante: json["fabricante"],
      );

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "descripcion": nombre,
        "ico": ico,
        "fabricante": fabricante,
      };
}
