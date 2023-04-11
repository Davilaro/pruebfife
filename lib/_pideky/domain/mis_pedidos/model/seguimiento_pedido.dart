import 'dart:convert';

SeguimientoPedido seguimientoPedidoFromJson(String str) =>
    SeguimientoPedido.fromJson(json.decode(str));

String seguimientoPedidoToJson(SeguimientoPedido data) =>
    json.encode(data.toJson());

class SeguimientoPedido {
  SeguimientoPedido({
    this.numeroDoc,
    this.consecutivo,
    this.precio,
    this.fechaServidor,
    this.horaTrans,
    this.fabricante,
    this.icoFabricante,
    this.estado,
    this.nombreProducto,
    this.codigoProducto,
    this.cantidad,
  });

  String? numeroDoc;
  String? consecutivo;
  double? precio;
  String? fechaServidor;
  String? horaTrans;
  String? fabricante;
  String? icoFabricante;
  String? nombreProducto;
  String? codigoProducto;
  int? cantidad;

  int? estado;

  factory SeguimientoPedido.fromJson(Map<String, dynamic> json) =>
      SeguimientoPedido(
        numeroDoc: json["NumeroDoc"] == null ? "" : json["NumeroDoc"],
        consecutivo: json["consecutivo"] == null ? "" : json["consecutivo"],
        precio: json["precio"] == null ? 0 : json["precio"],
        fechaServidor:
            json["fechaServidor"] == null ? "" : json["fechaServidor"],
        horaTrans: json["horatrans"] == null ? "" : json["horatrans"],
        fabricante: json["fabricante"] == null ? "" : json["fabricante"],
        icoFabricante: json["ico"] == null ? "" : json["ico"],
        estado: json["estado"] == null ? 1 : json["estado"],
        nombreProducto: json["Nombre"] == null ? "" : json["Nombre"],
        codigoProducto:
            json["CodigoProducto"] == null ? "" : json["CodigoProducto"],
        cantidad: json["Cantidad"] == null ? 0 : json["Cantidad"],
      );

  Map<String, dynamic> toJson() => {
        "numero_doc": numeroDoc,
        "consecutivo": consecutivo,
        "precio": precio,
        "fechaServidor": fechaServidor,
        "horatrans": horaTrans,
        "fabricante": fabricante,
        "ico": icoFabricante,
        "estado": estado,
        "Nombre": nombreProducto,
        "Cantidad": cantidad,
      };
}
