import 'dart:convert';

Seccion bannersFromJson(String str) => Seccion.fromJson(json.decode(str));

String bannersToJson(Seccion data) => json.encode(data.toJson());

class Seccion {
  Seccion({
    this.idSeccion,
    this.descripcion,
    this.orden,
  });

  int? idSeccion;
  String? descripcion;
  int? orden;

  factory Seccion.fromJson(Map<String, dynamic> json) => Seccion(
        idSeccion: json["Id"],
        descripcion: json["Descripcion"],
        orden: json["Orden"],
      );

  Map<String, dynamic> toJson() => {
        "Id": idSeccion,
        "Descripcion": descripcion,
        "Orden": orden,
      };
}
