import 'dart:convert';

Brand marcasFromJson(String str) => Brand.fromJson(json.decode(str));

String marcasToJson(Brand data) => json.encode(data.toJson());

class Brand {
  Brand({
    required this.codigo,
    required this.nombre,
    required this.ico,
    this.fabricante,
  });

  String codigo;
  String nombre;
  String ico;
  String? fabricante;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        codigo: json["codigo"],
        nombre: json["descripcion"],
        ico: json["ico"],
        fabricante: json["fabricante"] == null ? "" : json["fabricante"],
      );

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "descripcion": nombre,
        "ico": ico,
        "fabricante": fabricante,
      };
}
