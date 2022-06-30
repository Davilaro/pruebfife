import 'dart:convert';

NovedadesRegistro novedadesRegistroFromJson(String str) => NovedadesRegistro.fromJson(json.decode(str));

String novedadesRegistroToJson(NovedadesRegistro data) => json.encode(data.toJson());

class NovedadesRegistro {
    NovedadesRegistro({
        this.codigo,
        this.descripcion,
    });

    int? codigo;
    String? descripcion;

    factory NovedadesRegistro.fromJson(Map<String, dynamic> json) => NovedadesRegistro(
        codigo: json["Codigo"],
        descripcion: json["Descripcion"],
    );

    Map<String, dynamic> toJson() => {
        "Codigo": codigo,
        "Descripcion": descripcion,
    };
}