import 'dart:convert';

Historico historicoFromJson(String str) => Historico.fromJson(json.decode(str));

String historicoToJson(Historico data) => json.encode(data.toJson());

class Historico {
  Historico({
    this.numeroDoc,
    this.codigoRef,
    this.nombreProducto,
    this.cantidad,
    this.precio,
    this.fechaTrans,
    this.fabricante,
    this.ordenCompra,
    this.estado,
  });

  String? numeroDoc;
  String? codigoRef;
  String? nombreProducto;
  int? cantidad;
  double? precio;
  String? fechaTrans;
  String? fabricante;
  String? ordenCompra;
  bool? estado;

  factory Historico.fromJson(Map<String, dynamic> json) => Historico(
      numeroDoc: json["NumeroDoc"] == null ? "" : json["NumeroDoc"],
      codigoRef: json["codigoref"] == null ? "" : json["codigoref"],
      nombreProducto:
          json["nombreproducto"] == null ? "" : json["nombreproducto"],
      cantidad: json["Cantidad"] == null ? 0 : json["Cantidad"],
      precio: json["Precio"] == null ? 0 : json["Precio"],
      fechaTrans: json["fechatrans"] == null ? "" : json["fechatrans"],
      fabricante: json["fabricante"] == null ? "" : json["fabricante"],
      ordenCompra: json["ordencompra"] == null ? '0' : json["ordencompra"],
      estado: true);

  Map<String, dynamic> toJson() => {
        "numero_doc": numeroDoc,
        "codigoRef": codigoRef,
        "nombreProducto": nombreProducto,
        "cantidad": cantidad,
        "precio": precio,
        "fechaTrans": fechaTrans,
        "fabricante": fabricante,
        "ordenCompra": ordenCompra,
        "estado": estado,
      };
}
