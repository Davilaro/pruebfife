// To parse this JSON data, do
//
//     final listaSucursalesData = listaSucursalesDataFromJson(jsonString);

import 'dart:convert';

import 'package:emart/src/modelos/fabricantes.dart';

ListaSucursalesData listaSucursalesDataFromJson(String str) =>
    ListaSucursalesData.fromJson(json.decode(str));

String listaSucursalesDataToJson(ListaSucursalesData data) =>
    json.encode(data.toJson());

class ListaSucursalesData {
  ListaSucursalesData(
      {this.codigo,
      this.nombre,
      this.razonsocial,
      this.nit,
      this.direccion,
      this.ciudad,
      this.telefono,
      this.fabricantes,
      this.codigomeals,
      this.codigonutresa,
      this.codigozenu,
      this.codigopadrepideky});

  String? codigo;
  String? nombre;
  String? razonsocial;
  String? nit;
  String? direccion;
  String? ciudad;
  String? telefono;
  List<dynamic>? fabricantes;
  String? codigonutresa;
  String? codigozenu;
  String? codigomeals;
  String? codigopadrepideky;

  factory ListaSucursalesData.fromJson(Map<String, dynamic> json) =>
      ListaSucursalesData(
        codigo: json["codigo"],
        nombre: json["nombre"],
        razonsocial: json["razonsocial"],
        nit: json["nit"],
        direccion: json["direccion"],
        ciudad: json["ciudad"],
        telefono: json["telefono"],
        codigomeals: json["codigomeals"],
        codigonutresa: json["codigonutresa"],
        codigozenu: json["codigozenu"],
        codigopadrepideky:
            json["CodigoPadrePideky"] == null ? "" : json["CodigoPadrePideky"],
        fabricantes: List<Fabricantes>.from(
            json["fabricantes"].map((x) => Fabricantes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "nombre": nombre,
        "razonsocial": razonsocial,
        "nit": nit,
        "direccion": direccion,
        "ciudad": ciudad,
        "telefono": telefono,
        "fabricantes": List<dynamic>.from(fabricantes!.map((x) => x.toJson())),
        "codigomeals": codigomeals,
        "codigonutresa": codigonutresa,
        "codigozenu": codigozenu,
        "CodigoPadrePideky": codigopadrepideky,
      };
}
