import 'dart:convert';

PedidoSugeridoModel pedidoSugeridoFromJson(String str) =>
    PedidoSugeridoModel.fromJson(json.decode(str));

String pedidoSugeridoToJson(PedidoSugeridoModel data) =>
    json.encode(data.toJson());

class PedidoSugeridoModel {
  PedidoSugeridoModel(
      {this.negocio,
      this.codigo,
      this.nombre,
      this.precio,
      this.cantidad,
      this.bloqueoCartera});

  String? negocio;
  String? codigo;
  String? nombre;
  String? nombreComercial;
  String? icono;
  double? precio;
  int? cantidad;
  bool isExpanded = false;
  int? bloqueoCartera;
  bool? isSelected = false;

  factory PedidoSugeridoModel.fromJson(Map<String, dynamic> json) =>
      PedidoSugeridoModel(
          negocio: json["Negocio"] == null ? '' : json["Negocio"],
          codigo: json["Codigo"] == null ? '' : json["Codigo"],
          nombre: json["nombre"] == null ? '' : json["nombre"],
          precio: json["precio"] == null ? 0 : json["precio"],
          cantidad: json["Cantidad"] == null ? 0 : json["Cantidad"],
          bloqueoCartera: json["bloqueoCartera"] == null
              ? 0
              : json["bloqueoCartera"] == 0
                  ? 0
                  : json["bloqueoCartera"]);

  get length => null;

  Map<String, dynamic> toJson() => {
        "negocio": negocio,
        "codigo": codigo,
        "nombre": nombre,
        "precio": precio,
        "cantidad": cantidad,
        "bloqueoCartera": bloqueoCartera
      };

  setNombreComercial(nombrecomercial) {
    nombreComercial = nombreComercial;
  }
}
