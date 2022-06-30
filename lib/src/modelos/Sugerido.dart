import 'dart:convert';

Sugerido sugeridoFromJson(String str) => Sugerido.fromJson(json.decode(str));

String sugeridoToJson(Sugerido data) => json.encode(data.toJson());

class Sugerido {
  Sugerido(
      {this.codigo,
      this.codigoBarras,
      this.descripcion,
      this.precio,
      this.iva,
      this.cantidad,
      this.unidadMedida,
      this.unidadVenta,
      this.indice,
      this.estado});

  String? codigo;
  String? codigoBarras;
  String? descripcion;
  double? precio;
  int? iva;
  int? cantidad;
  int? unidadMedida;
  String? unidadVenta;
  int? indice;
  bool? estado;

  factory Sugerido.fromJson(Map<String, dynamic> json) => Sugerido(
        codigo: json["Codigo"] == null ? "" : json["Codigo"],
        codigoBarras: json["codigoBarras"] == null ? "" : json["codigoBarras"],
        descripcion: json["Descripcion"] == null ? "" : json["Descripcion"],
        precio: json["precio"] == null ? 0 : json["precio"],
        iva: json["IVA"] == null ? 0 : json["IVA"],
        cantidad: json["Cantidad"] == null ? 0 : json["Cantidad"],
        unidadMedida: json["unidadMedida"] == null ? 0 : json["unidadMedida"],
        unidadVenta: json["unidadVenta"] == null ? "" : json["unidadVenta"],
        indice: json["indice"] == null ? 0 : json["indice"],
        estado: true,
      );

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "codigoBarras": codigoBarras,
        "descripcion": descripcion,
        "precio": precio,
        "iva": iva,
        "cantidad": cantidad,
        "unidadMedida": unidadMedida,
        "unidadVenta": unidadVenta,
        "indice": indice,
        "estado": estado
      };
}
