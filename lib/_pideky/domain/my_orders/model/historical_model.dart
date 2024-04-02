import 'dart:convert';

HistoricalModel historicoFromJson(String str) => HistoricalModel.fromJson(json.decode(str));

String historicoToJson(HistoricalModel data) => json.encode(data.toJson());

class HistoricalModel {
  HistoricalModel({
    this.numeroDoc,
    this.codigoRef,
    this.nombreProducto,
    this.cantidad,
    this.precio,
    this.fechaTrans,
    this.horaTrans,
    this.fabricante,
    this.icoFabricante,
    this.ordenCompra,
    this.estado,
  });

  String? numeroDoc;
  String? codigoRef;
  String? nombreProducto;
  int? cantidad;
  double? precio;
  String? fechaTrans;
  String? horaTrans;
  String? fabricante;
  String? icoFabricante;
  String? ordenCompra;
  bool? estado;

  factory HistoricalModel.fromJson(Map<String, dynamic> json) => HistoricalModel(
      numeroDoc: json["NumeroDoc"] == null ? "" : json["NumeroDoc"],
      codigoRef: json["codigoref"] == null ? "" : json["codigoref"],
      nombreProducto:
          json["nombreproducto"] == null ? "" : json["nombreproducto"],
      cantidad: json["Cantidad"] == null ? 0 : json["Cantidad"],
      precio: json["precio"] == null ? 0.0 : json["precio"],
      fechaTrans: json["fechatrans"] == null ? "" : json["fechatrans"],
      horaTrans: json["horatrans"] == null ? "" : json["horatrans"],
      fabricante: json["fabricante"] == null ? "" : json["fabricante"],
      icoFabricante: json["ico"] == null ? "" : json["ico"],
      ordenCompra: json["ordencompra"] == null ? '0' : json["ordencompra"],
      estado: true);

  Map<String, dynamic> toJson() => {
        "numero_doc": numeroDoc,
        "codigoRef": codigoRef,
        "nombreProducto": nombreProducto,
        "cantidad": cantidad,
        "precio": precio,
        "fechaTrans": fechaTrans,
        "horatrans": horaTrans,
        "fabricante": fabricante,
        "ico": icoFabricante,
        "ordenCompra": ordenCompra,
        "estado": estado,
      };
}
