import 'dart:convert';

Marcas marcasFromJson(String str) => Marcas.fromJson(json.decode(str));

String marcasToJson(Marcas data) => json.encode(data.toJson());

class Marcas {
  Marcas({
    required this.codigo,
    required this.titulo,
    required this.ico,
  });

  String codigo;
  String titulo;
  String ico;

  factory Marcas.fromJson(Map<String, dynamic> json) => Marcas(
        codigo: json["codigo"],
        titulo: json["descripcion"],
        ico: json["ico"],
      );

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "descripcion": titulo,
        "ico": ico,
      };
}
