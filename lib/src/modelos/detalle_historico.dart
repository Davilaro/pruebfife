
import 'dart:convert';

DetalleHistorico detalleHistoricoFromJson(String str) => DetalleHistorico.fromJson(json.decode(str));

String detalleHistoricoToJson(DetalleHistorico data) => json.encode(data.toJson());

class DetalleHistorico {
    DetalleHistorico({
        this.codigo,
        this.nombre,
        this.cantidad,
        this.precio,
        this.iva,
    });

    String? codigo;
    String? nombre;
    String? cantidad;
    String? precio;
    int? iva;

    factory DetalleHistorico.fromJson(Map<String, dynamic> json) => DetalleHistorico(
        codigo: json["codigo"],
        nombre: json["nombre"],
        cantidad: json["cantidad"],
        precio: json["precio"],
        iva: json["iva"],
    );

    Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "nombre": nombre,
        "cantidad": cantidad,
        "precio": precio,
        "iva": iva,
    };
}
