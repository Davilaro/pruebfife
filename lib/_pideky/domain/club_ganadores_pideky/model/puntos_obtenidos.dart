// To parse this JSON data, do
//
//     final puntosObtenidos = puntosObtenidosFromJson(jsonString);

import 'dart:convert';

PuntosObtenidos puntosObtenidosFromJson(String str) =>
    PuntosObtenidos.fromJson(json.decode(str));

String puntosObtenidosToJson(PuntosObtenidos data) =>
    json.encode(data.toJson());

class PuntosObtenidos {
  PuntosObtenidos({
    this.puntosDisponibles,
  });

  String? puntosDisponibles;

  factory PuntosObtenidos.fromJson(Map<String, dynamic> json) =>
      PuntosObtenidos(
          puntosDisponibles: json["PuntosDisponibles"] == null
              ? "0"
              : json["PuntosDisponibles"]);

  Map<String, dynamic> toJson() => {
        "PuntosDisponibles": puntosDisponibles,
      };
}
