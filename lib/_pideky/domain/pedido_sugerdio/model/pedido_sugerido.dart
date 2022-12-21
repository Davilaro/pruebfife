import 'dart:convert';

PedidoSugeridoModel pedidoSugeridoFromJson(String str) =>
    PedidoSugeridoModel.fromJson(json.decode(str));

String pedidoSugeridoToJson(PedidoSugeridoModel data) =>
    json.encode(data.toJson());

class PedidoSugeridoModel {
  PedidoSugeridoModel({
    this.negocio,
    this.codigo,
    this.nombre,
    this.precio,
    this.cantidad,
  });

  String? negocio;
  String? codigo;
  String? nombre;
  String? nombreComercial;
  String? icono;
  double? precio;
  int? cantidad;
  bool isExpanded = false;

  factory PedidoSugeridoModel.fromJson(Map<String, dynamic> json) =>
      PedidoSugeridoModel(
        negocio: json["Negocio"],
        codigo: json["Codigo"],
        nombre: json["nombre"],
        precio: json["precio"],
        cantidad: json["Cantidad"],
      );

  get length => null;

  Map<String, dynamic> toJson() => {
        "negocio": negocio,
        "codigo": codigo,
        "nombre": nombre,
        "precio": precio,
        "cantidad": cantidad,
      };

  setNombreComercial(nombrecomercial) {
    this.nombreComercial = nombreComercial;
  }
}
