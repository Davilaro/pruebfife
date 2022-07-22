// To parse this JSON data, do
//
//     final marcaFiltro = marcaFiltroFromJson(jsonString);

import 'dart:convert';

MarcaFiltro marcaFiltroFromJson(String str) =>
    MarcaFiltro.fromJson(json.decode(str));

String marcaFiltroToJson(MarcaFiltro data) => json.encode(data.toJson());

class MarcaFiltro {
  MarcaFiltro({
    this.nombreMarca,
  });

  String? nombreMarca;

  factory MarcaFiltro.fromJson(Map<String, dynamic> json) => MarcaFiltro(
        nombreMarca: json["nombreMarca"] == null ? null : json["nombreMarca"],
      );

  Map<String, dynamic> toJson() => {
        "nombreMarca": nombreMarca == null ? null : nombreMarca,
      };
}
