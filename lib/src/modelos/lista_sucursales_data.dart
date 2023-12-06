// To parse this JSON data, do
//
//     final listaSucursalesData = listaSucursalesDataFromJson(jsonString);

import 'dart:convert';

import 'package:emart/src/modelos/fabricante.dart';

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
      this.codigopozuelo,
      this.codigoalpina,
      this.pais,
      this.codigoUnicoPideky,
      this.bloqueado,
      this.barrio,
      this.sucursal});

  String? codigo;
  String? barrio;
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
  String? codigopozuelo;
  String? codigoalpina;
  String? pais;
  String? bloqueado;
  String? codigoUnicoPideky;
  String? sucursal;

  factory ListaSucursalesData.fromJson(Map<String, dynamic> json) =>
      ListaSucursalesData(
        codigo: json["Codigo"] == null ? "" : json["Codigo"],
        nombre: json["Nombre"] == null ? "" : json["Nombre"],
        razonsocial: json["RazonSocial"] == null ? "" : json["RazonSocial"],
        nit: json["Nit"] == null ? "" : json["Nit"],
        direccion: json["Direccion"] == null ? "" : json["Direccion"],
        ciudad: json["Ciudad"] == null ? "" : json["Ciudad"],
        telefono: json["Telefono"] == null ? "" : json["Telefono"],
        codigomeals: json["CodigoMeals"] == null ? "" : json["CodigoMeals"],
        codigonutresa:
            json["CodigoNutresa"] == null ? "" : json["CodigoNutresa"],
        codigozenu: json["CodigoZenu"] == null ? "" : json["CodigoZenu"],
        codigopozuelo:
            json["CodigoPozuelo"] == null ? "" : json["CodigoPozuelo"],
        codigoalpina: json["CodigoAlpina"] == null ? "" : json["CodigoAlpina"],
        codigoUnicoPideky:
            json["CodigoUnicoPideky"] == null ? "" : json["CodigoUnicoPideky"],
        bloqueado: json["Bloqueado"] == null ? "" : json["Bloqueado"],
        pais: json["Pais"] == null ? "" : json["Pais"],
        barrio: json["Barrio"] == null ? "" : json["Barrio"],
        fabricantes: json["Fabricantes"] == null
            ? []
            : List<Fabricante>.from(
                json["Fabricantes"].map((x) => Fabricante.fromJson(x))),
        sucursal: json["Sucursal"] == null ? "" : json["Sucursal"],
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
        "codigopozuelo": codigopozuelo,
        "codigoalpina": codigoalpina,
        "Pais": pais,
        "CodigoUnicoPideky": codigoUnicoPideky,
        "Bloqueado": bloqueado,
        "Sucursal": sucursal,
        "Barrio": barrio
      };
}
