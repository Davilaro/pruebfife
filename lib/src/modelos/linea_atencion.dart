import 'dart:convert';

LineaAtencion lineaAtencionFromJson(String str) =>
    LineaAtencion.fromJson(json.decode(str));

String lineaAtencionToJson(LineaAtencion data) => json.encode(data.toJson());

class LineaAtencion {
  LineaAtencion({
    this.tipo,
    this.descripcion,
    this.fabricante,
    this.telefono,
    this.vendedor1,
    this.telefonoVendedor1,
    this.vendedor2,
    this.telefonoVendedor2,
  });

  int? tipo;
  String? descripcion;
  String? fabricante;
  String? telefono;
  String? vendedor1;
  String? telefonoVendedor1;
  String? vendedor2;
  String? telefonoVendedor2;

  factory LineaAtencion.fromJson(Map<String, dynamic> json) => LineaAtencion(
        tipo: json["Tipo"] == null ? 0 : json["Tipo"],
        descripcion: json["Descripcion"] == null ? "" : json["Descripcion"],
        fabricante: json["Fabricante"] == null ? "" : json["Fabricante"],
        telefono: json["Telefono"] == null ? "" : json["Telefono"],
        vendedor1: json["nombrevendedor"] == null ? "" : json["nombrevendedor"],
        telefonoVendedor1:
            json["telefonovendedor"] == null ? "" : json["telefonovendedor"],
      );

  Map<String, dynamic> toJson() => {
        "tipo": tipo,
        "Descripcion": descripcion,
        "Fabricante": fabricante,
        "telefono": telefono,
        "nombrevendedor": vendedor1,
        "telefonovendedor": telefonoVendedor1,
      };
}
