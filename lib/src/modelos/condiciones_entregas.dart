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
    required this.texto1,
    required this.texto2,
    required this.diasEntrega,
    required this.diaVisita,
    this.montoMinimoFrecuencia,
    this.montoMinimoNoFrecuencia,
  });

  String fabricante;
  String tipo;
  String hora;
  String texto1;
  String texto2;
  int? montoMinimoFrecuencia;
  int? montoMinimoNoFrecuencia;
  String diaVisita;
  int diasEntrega;

  factory CondicionesEntrega.fromJson(Map<String, dynamic> json) =>
      CondicionesEntrega(
        fabricante: json["fabricante"],
        tipo: json["tipo"],
        hora: json["hora"],
        texto1: json["texto1"] == null ? '' : json["texto1"],
        texto2: json["texto2"] == null ? '' : json["texto2"],
        montoMinimoFrecuencia: json["montoMinimoFrecuencia"],
        montoMinimoNoFrecuencia: json["montoMinimoNoFrecuencia"],
        diaVisita: json["diaVisita"],
        diasEntrega: json["diasEntrega"],
      );

  Map<String, dynamic> toJson() => {
        "fabricante": fabricante,
        "tipo": tipo,
        "hora": hora,
        "Texto1": texto1,
        "Texto2": texto2,
        "montominimofrecuencia": montoMinimoFrecuencia,
        "montominimonofrecuencia": montoMinimoNoFrecuencia,
        "DiaVisita": diaVisita,
        "DiasEntrega": diasEntrega,
      };
}
