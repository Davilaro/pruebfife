// To parse this JSON data, do
//
//     final listaSucursalesData = listaSucursalesDataFromJson(jsonString);

import 'dart:convert';

import 'package:emart/src/modelos/fabricantes.dart';

Notificaciones listaSucursalesDataFromJson(String str) =>
    Notificaciones.fromJson(json.decode(str));

String listaSucursalesDataToJson(Notificaciones data) =>
    json.encode(data.toJson());

class Notificaciones {
  Notificaciones({
    this.titulo,
    this.descripcion,
    this.fecha,
    this.sucursal,
  });

  String? titulo;
  String? descripcion;
  String? fecha;
  String? sucursal;

  factory Notificaciones.fromJson(Map<String, dynamic> json) => Notificaciones(
        titulo: json["Titulo"],
        descripcion: json["Descripcion"],
        fecha: json["Fecha"],
        sucursal: json["Sucursal"],
      );

  Map<String, dynamic> toJson() => {
        "titulo": titulo,
        "descripcion": descripcion,
        "fecha": fecha,
        "sucursal": sucursal,
      };
}
