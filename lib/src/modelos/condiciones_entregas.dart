import 'dart:convert';

CondicionesEntrega condicionesEntregaFromJson(String str) => CondicionesEntrega.fromJson(json.decode(str));

String condicionesEntregaToJson(CondicionesEntrega data) => json.encode(data.toJson());

class CondicionesEntrega {
    CondicionesEntrega({
        required this.fabricante,
        required this.tipo,
        required this.hora,
        required this.mensaje1,
        required this.mensaje2,
        required this.pedidominimo,
    });

    String fabricante;
    String tipo;
    String hora;
    String mensaje1;
    String mensaje2;
    double pedidominimo;

    factory CondicionesEntrega.fromJson(Map<String, dynamic> json) => CondicionesEntrega(
        fabricante: json["codigo"],
        tipo: json["descripcion"],
        hora: json["hora"],
        mensaje1: json["mensaje1"],
        mensaje2: json["mensaje2"],
        pedidominimo: json["pedidominimo"],
    );

    Map<String, dynamic> toJson() => {
        "fabricante": fabricante,
        "tipo": tipo,
        "hora": hora,
        "mensaje1": mensaje1,
        "mensaje2": mensaje2,
        "pedidominimo": pedidominimo,
    };
}
