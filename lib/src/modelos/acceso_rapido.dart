import 'dart:convert';

AccesosRapido accesosRapidoFromJson(String str) => AccesosRapido.fromJson(json.decode(str));

String accesosRapidoToJson(AccesosRapido data) => json.encode(data.toJson());

class AccesosRapido {
    AccesosRapido({
        this.codigo,
        this.descripcion,
        this.fabricante,
        this.ico,
    });

    String? codigo;
    String? descripcion;
    String? fabricante;
    String? ico;

    factory AccesosRapido.fromJson(Map<String, dynamic> json) => AccesosRapido(
        codigo: json["codigo"],
        descripcion: json["descripcion"],
        fabricante: json["fabricante"],
        ico: json["ico"],
    );

    Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "descripcion": descripcion,
        "fabricante": fabricante,
        "ico": ico,
    };
}
