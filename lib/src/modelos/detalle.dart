import 'dart:convert';

Detalle detalleFromJson(String str) => Detalle.fromJson(json.decode(str));

String detalleToJson(Detalle data) => json.encode(data.toJson());

class Detalle {
  Detalle({
    required this.nombreProducto,
    required this.Cantidad,
  });

  String nombreProducto;
  int Cantidad;

  factory Detalle.fromJson(Map<String, dynamic> json) => Detalle(
        nombreProducto: json["nombreProducto"],
        Cantidad: json["Cantidad"],
      );

  Map<String, dynamic> toJson() => {
        "nombreProducto": nombreProducto,
        "Cantidad": Cantidad,
      };
}
