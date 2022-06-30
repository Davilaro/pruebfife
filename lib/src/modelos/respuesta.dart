import 'dart:convert';

Respuesta respuestaFromJson(String str) => Respuesta.fromJson(json.decode(str));

String respuestaToJson(Respuesta data) => json.encode(data.toJson());

class Respuesta {
    Respuesta({
        this.respuesta,
    });

    String? respuesta;

    factory Respuesta.fromJson(Map<String, dynamic> json) => Respuesta(
        respuesta: json["respuesta"],
    );

    Map<String, dynamic> toJson() => {
        "respuesta": respuesta,
    };
}
