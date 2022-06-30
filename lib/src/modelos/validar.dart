import 'dart:convert';

Validar validarFromJson(String str) => Validar.fromJson(json.decode(str));

String validarToJson(Validar data) => json.encode(data.toJson());

class Validar {
    Validar({
        required this.activado,
        required this.mensaje,
    });

    String activado;
    String mensaje;

    factory Validar.fromJson(Map<String, dynamic> json) => Validar(
        activado: json["Activado"],
        mensaje: json["Mensaje"],
    );

    Map<String, dynamic> toJson() => {
        "Activado": activado,
        "Mensaje": mensaje,
    };
}