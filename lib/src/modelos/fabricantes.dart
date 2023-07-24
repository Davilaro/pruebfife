import 'dart:convert';

Fabricantes fabricantesFromJson(String str) =>
    Fabricantes.fromJson(json.decode(str));

String fabricantesToJson(Fabricantes data) => json.encode(data.toJson());

class Fabricantes {
  Fabricantes(
      {this.empresa,
      this.icono,
      // this.codIndirecto,
      this.tipofabricante,
      this.nombrecomercial,
      this.estado,
      this.topeMinimo,
      this.nitCliente,
      this.montoMinimoFrecuencia,
      this.montoMinimoNoFrecuencia,
      this.restrictivoFrecuencia,
      this.restrictivoNoFrecuencia,
      this.hora,
      this.texto1,
      required this.diaVisita,
      this.razonSocial});

  String? empresa;
  String? icono;
  String? tipofabricante;
  // String? codIndirecto;
  String? nombrecomercial;
  String? estado;
  String? hora;
  double? topeMinimo;
  int? montoMinimoFrecuencia;
  int? montoMinimoNoFrecuencia;
  int? restrictivoFrecuencia;
  int? restrictivoNoFrecuencia;
  String? texto1;
  String diaVisita;
  String? nitCliente;
  String? razonSocial;

  factory Fabricantes.fromJson(Map<String, dynamic> json) => Fabricantes(
      empresa: json["empresa"] == null ? '' : json["empresa"],
      icono: json["ico"] == null ? '' : json["ico"],
      tipofabricante:
          json["tipofabricante"] == null ? '' : json["tipofabricante"],
      // codIndirecto: json["codIndirecto"] == null ? '' : json["codIndirecto"],
      nombrecomercial:
          json["nombrecomercial"] == null ? '' : json["nombrecomercial"],
      estado: json["Estado"] == null ? '' : json["Estado"],
      topeMinimo: json["topeMinimo"] == null ? 0 : json["topeMinimo"],
      nitCliente: json["NitCliente"] == null ? '' : json["NitCliente"],
      razonSocial: json["RazonSocial"] == null ? '' : json["RazonSocial"],
      hora: json["hora"],
      montoMinimoFrecuencia: json["montominimofrecuencia"],
      montoMinimoNoFrecuencia: json["montominimonofrecuencia"],
      restrictivoFrecuencia: json["restrictivofrecuencia"],
      restrictivoNoFrecuencia: json["restrictivonofrecuencia"],
      diaVisita: json["diavisita"],
      texto1: json["texto1"]);

  Map<String, dynamic> toJson() => {
        "empresa": empresa,
        "ico": icono,
        "tipofabricante": tipofabricante,
        // "codIndirecto": codIndirecto,
        "nombrecomercial": nombrecomercial,
        "Estado": estado,
        "topeMinimo": topeMinimo,
        "NitCliente": nitCliente,
        "montominimofrecuencia": montoMinimoFrecuencia,
        "montominimonofrecuencia": montoMinimoNoFrecuencia,
        "RazonSocial": razonSocial,
        "diavisita": diaVisita,
        "restrictivonofrecuencia": restrictivoNoFrecuencia,
        "restrictivofrecuencia": restrictivoFrecuencia,
        "hora": hora,
        "texto1": texto1,
      };
}
