import 'dart:convert';

CondicionesEntrega condicionesEntregaFromJson(String str) =>
    CondicionesEntrega.fromJson(json.decode(str));

String condicionesEntregaToJson(CondicionesEntrega data) =>
    json.encode(data.toJson());

class CondicionesEntrega {
  CondicionesEntrega({
    required this.fabricante,
    required this.tipo,
    required this.hora,
    required this.mensaje1,
    required this.mensaje2,
    required this.texto1,
    required this.texto2,
    required this.pedidominimo,
    required this.diasEntrega,
    required this.diaVisita,
    this.montoMinimoFrecuencia,
    this.montoMinimoNoFrecuencia,
  });

  String fabricante;
  String tipo;
  String hora;
  String mensaje1;
  String mensaje2;
  String texto1;
  String texto2;
  double pedidominimo;
  int? montoMinimoFrecuencia;
  int? montoMinimoNoFrecuencia;
  String diaVisita;
  int diasEntrega;

  factory CondicionesEntrega.fromJson(Map<String, dynamic> json) =>
      CondicionesEntrega(
        fabricante: json["codigo"],
        tipo: json["descripcion"],
        hora: json["hora"],
        mensaje1: json["mensaje1"],
        mensaje2: json["mensaje2"],
        pedidominimo: json["pedidominimo"],
        texto1: json["Texto1"],
        texto2: json["Texto2"],
        montoMinimoFrecuencia: json["montominimofrecuencia"],
        montoMinimoNoFrecuencia: json["montominimonofrecuencia"],
        diaVisita: json["DiaVisita"],
        diasEntrega: json["DiasEntrega"],
      );

  Map<String, dynamic> toJson() => {
        "fabricante": fabricante,
        "tipo": tipo,
        "hora": hora,
        "mensaje1": mensaje1,
        "mensaje2": mensaje2,
        "pedidominimo": pedidominimo,
        "Texto1": texto1,
        "Texto2": texto2,
        "montominimofrecuencia": montoMinimoFrecuencia,
        "montominimonofrecuencia": montoMinimoNoFrecuencia,
        "DiaVisita": diaVisita,
        "DiasEntrega": diasEntrega,
      };
}
