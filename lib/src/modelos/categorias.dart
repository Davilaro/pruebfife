import 'dart:convert';

Categorias categoriasFromJson(String str) =>
    Categorias.fromJson(json.decode(str));

String categoriasToJson(Categorias data) => json.encode(data.toJson());

class Categorias {
  Categorias({
    required this.codigo,
    required this.descripcion,
    required this.ico,
  });

  String codigo;
  String descripcion;
  String ico;

  factory Categorias.fromJson(Map<String, dynamic> json) => Categorias(
        codigo: json["codigo"],
        descripcion: json["descripcion"],
        ico: json["ico"],
      );

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "descripcion": descripcion,
        "ico": ico,
      };
}
