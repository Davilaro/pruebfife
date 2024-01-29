// To parse this JSON data, do
//
//     final compraVendeGana = compraVendeGanaFromJson(jsonString);

import 'dart:convert';

CompraVendeGanaModel compraVendeGanaFromJson(String str) =>
    CompraVendeGanaModel.fromJson(json.decode(str));

String compraVendeGanaToJson(CompraVendeGanaModel data) =>
    json.encode(data.toJson());

class CompraVendeGanaModel {
  String nombre;
  double compra;
  double vende;
  double gana;
  int chispa;
  double valorChispa;
  String? codProducto1;
  String? codProducto2;
  String colorCupon;
  String proveedor;
  String link;
  String colorLetraGran;
  String colorLetraPequ;
  String colorChispa;
  int? cantidadProd1;
  int? cantidadProd2;

  CompraVendeGanaModel({
    required this.nombre,
    required this.compra,
    required this.vende,
    required this.gana,
    required this.chispa,
    required this.valorChispa,
    this.codProducto1,
    this.codProducto2,
    required this.colorCupon,
    required this.proveedor,
    required this.link,
    required this.colorLetraGran,
    required this.colorLetraPequ,
    required this.colorChispa,
    this.cantidadProd1,
    this.cantidadProd2,
  });

  CompraVendeGanaModel copyWith({
    String? nombre,
    double? compra,
    double? vende,
    double? gana,
    int? chispa,
    double? valorChispa,
    String? codProducto1,
    String? codProducto2,
    String? colorCupon,
    String? proveedor,
    String? link,
    String? colorLetraGran,
    String? colorLetraPequ,
    String? colorChispa,
    int? cantidadProd1,
    int? cantidadProd2,
  }) =>
      CompraVendeGanaModel(
        nombre: nombre ?? this.nombre,
        compra: compra ?? this.compra,
        vende: vende ?? this.vende,
        gana: gana ?? this.gana,
        chispa: chispa ?? this.chispa,
        valorChispa: valorChispa ?? this.valorChispa,
        codProducto1: codProducto1 ?? this.codProducto1,
        codProducto2: codProducto2 ?? this.codProducto2,
        colorCupon: colorCupon ?? this.colorCupon,
        proveedor: proveedor ?? this.proveedor,
        link: link ?? this.link,
        colorLetraGran: colorLetraGran ?? this.colorLetraGran,
        colorLetraPequ: colorLetraPequ ?? this.colorLetraPequ,
        colorChispa: colorChispa ?? this.colorChispa,
        cantidadProd1: cantidadProd1 ?? this.cantidadProd1,
        cantidadProd2: cantidadProd2 ?? this.cantidadProd2,
      );

  factory CompraVendeGanaModel.fromJson(Map<String, dynamic> json) =>
      CompraVendeGanaModel(
        nombre: json["nombre"],
        compra: json["compra"]?.toDouble(),
        vende: json["vende"]?.toDouble(),
        gana: json["gana"]?.toDouble(),
        chispa: json["chispa"],
        valorChispa: json["valorChispa"]?.toDouble(),
        codProducto1:
            json["codProducto1"] == null ? null : json["codProducto1"],
        codProducto2:
            json["codProducto2"] == null ? null : json["codProducto2"],
        colorCupon: json["colorCupon"],
        proveedor: json["proveedor"],
        link: json["link"],
        colorLetraGran: json["colorLetraGran"],
        colorLetraPequ: json["colorLetraPequ"],
        colorChispa: json["colorChispa"],
        cantidadProd1:
            json["cantidadProd1"] == null ? null : json["cantidadProd1"],
        cantidadProd2:
            json["cantidadProd2"] == null ? null : json["cantidadProd2"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "compra": compra,
        "vende": vende,
        "gana": gana,
        "chispa": chispa,
        "valorChispa": valorChispa,
        "codProducto1": codProducto1,
        "codProducto2": codProducto2,
        "colorCupon": colorCupon,
        "proveedor": proveedor,
        "link": link,
        "colorLetraGran": colorLetraGran,
        "colorLetraPequ": colorLetraPequ,
        "colorChispa": colorChispa,
        "cantidadProd1": cantidadProd1,
        "cantidadProd2": cantidadProd2,
      };
}
