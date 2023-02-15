import 'dart:convert';

CondicionEntrega condicionEntregaFromJson(String str) =>
    CondicionEntrega.fromJson(json.decode(str));

String condicionEntregaToJson(CondicionEntrega data) =>
    json.encode(data.toJson());

class CondicionEntrega {
  CondicionEntrega(
      {this.fabricante,
      this.tipo,
      this.hora,
      this.mensaje1,
      this.mensaje2,
      this.pedidoMinimo,
      this.nombreComercial,
      this.topeminimo,
      this.restrictivo,
      this.montoMinimoFrecuencia,
      this.montoMinimoNoFrecuencia,
      this.restrictivoFrecuencia,
      this.restrictivoNoFrecuencia,
      this.diaVisita,
      this.diaEntrega,
      this.texto1,
      this.texto2,
      this.semana});

  String? fabricante;
  String? tipo;
  String? hora;
  String? mensaje1;
  String? mensaje2;
  double? pedidoMinimo;
  String? nombreComercial;
  int? topeminimo;
  String? restrictivo;
  int? montoMinimoFrecuencia;
  int? montoMinimoNoFrecuencia;
  int? restrictivoFrecuencia;
  int? restrictivoNoFrecuencia;
  String? diaVisita;
  int? diaEntrega;
  String? texto1;
  String? texto2;
  int? semana;

  factory CondicionEntrega.fromJson(Map<String, dynamic> json) =>
      CondicionEntrega(
        fabricante: json["fabricante"] == null ? '' : json["fabricante"],
        tipo: json["tipo"] == null ? '' : json["tipo"],
        hora: json["hora"] == null ? '' : json["hora"],
        mensaje1: json["mensaje1"] == null ? '' : json["mensaje1"],
        mensaje2: json["mensaje2"] == null ? '' : json["mensaje2"],
        pedidoMinimo: json["pedidoMinimo"] == null ? 0.0 : json["pedidoMinimo"],
        nombreComercial:
            json["nombreComercial"] == null ? '' : json["nombreComercial"],
        topeminimo: json["topeminimo"] == null ? 0 : json["topeminimo"],
        restrictivo: json["restrictivo"] == null ? '' : json["restrictivo"],
        montoMinimoFrecuencia: json["montoMinimoFrecuencia"] == null
            ? 0
            : json["montoMinimoFrecuencia"],
        montoMinimoNoFrecuencia: json["montoMinimoNoFrecuencia"] == null
            ? 0
            : json["montoMinimoNoFrecuencia"],
        restrictivoFrecuencia: json["restrictivoFrecuencia"] == null
            ? 0
            : json["restrictivoFrecuencia"],
        restrictivoNoFrecuencia: json["restrictivoNoFrecuencia"] == null
            ? 0
            : json["restrictivoNoFrecuencia"],
        diaVisita: json["DiaVisita"] == null ? '' : json["DiaVisita"],
        diaEntrega: json["diaEntrega"] == null ? 0 : json["diaEntrega"],
        texto1: json["texto1"] == null ? '' : json["texto1"],
        texto2: json["texto2"] == null ? '' : json["texto2"],
        semana: json["Semana"] == null ? 0 : json["Semana"],
      );

  Map<String, dynamic> toJson() => {
        "fabricante": fabricante,
        "tipo": tipo,
        "hora": hora,
        "mensaje1": mensaje1,
        "mensaje2": mensaje2,
        "pedidoMinimo": pedidoMinimo,
        "nombreComercial": nombreComercial,
        "topeminimo": topeminimo,
        "restrictivo": restrictivo,
        "montoMinimoFrecuencia": montoMinimoFrecuencia,
        "montoMinimoNoFrecuencia": montoMinimoNoFrecuencia,
        "restrictivoFrecuencia": restrictivoFrecuencia,
        "restrictivoNoFrecuencia": restrictivoNoFrecuencia,
        "DiaVisita": diaVisita,
        "diaEntrega": diaEntrega,
        "texto1": texto1,
        "texto2": texto2,
        "Semana": semana,
      };
}
