import 'dart:convert';

Fabricantes fabricantesFromJson(String str) =>
    Fabricantes.fromJson(json.decode(str));

String fabricantesToJson(Fabricantes data) => json.encode(data.toJson());

class Fabricantes {
  Fabricantes(
      {this.empresa,
      this.icono,
      this.codIndirecto,
      this.pedidominimo,
      this.tipofabricante,
      this.nombrecomercial,
      this.restrictivo,
      this.estado,
      this.topeMinimo,
      this.nitCliente,
      this.montoMinimoFrecuencia,
      this.montoMinimoNoFrecuencia,
      this.restrictivoFrecuencia,
      this.restrictivoNoFrecuencia,
      this.hora,
      required this.diaVisita,
      this.razonSocial});

  String? empresa;
  String? icono;
  String? tipofabricante;
  String? codIndirecto;
  double? pedidominimo;
  String? nombrecomercial;
  String? estado;
  String? hora;
  double? topeMinimo;
  int? montoMinimoFrecuencia;
  int? montoMinimoNoFrecuencia;
  int? restrictivoFrecuencia;
  int? restrictivoNoFrecuencia;
  String diaVisita;
  String? nitCliente;
  String? razonSocial;
  String? restrictivo;

  factory Fabricantes.fromJson(Map<String, dynamic> json) => Fabricantes(
        empresa: json["empresa"] == null ? '' : json["empresa"],
        icono: json["ico"] == null ? '' : json["ico"],
        tipofabricante:
            json["tipofabricante"] == null ? '' : json["tipofabricante"],
        codIndirecto: json["codIndirecto"] == null ? '' : json["codIndirecto"],
        pedidominimo: json["pedidominimo"] == null ? 0 : json["pedidominimo"],
        nombrecomercial:
            json["nombrecomercial"] == null ? '' : json["nombrecomercial"],
        estado: json["Estado"] == null ? '' : json["Estado"],
        topeMinimo: json["topeMinimo"] == null ? 0 : json["topeMinimo"],
        nitCliente: json["NitCliente"] == null ? '' : json["NitCliente"],
        razonSocial: json["RazonSocial"] == null ? '' : json["RazonSocial"],
        restrictivo: json['restrictivo'] == null ? '0' : json['restrictivo'],
        hora: json["hora"],
        montoMinimoFrecuencia: json["montominimofrecuencia"],
        montoMinimoNoFrecuencia: json["montominimonofrecuencia"],
        restrictivoFrecuencia: json["restrictivofrecuencia"],
        restrictivoNoFrecuencia: json["restrictivonofrecuencia"],
        diaVisita: json["diavisita"],
      );

  Map<String, dynamic> toJson() => {
        "empresa": empresa,
        "ico": icono,
        "tipofabricante": tipofabricante,
        "codIndirecto": codIndirecto,
        "pedidominimo": pedidominimo,
        "nombrecomercial": nombrecomercial,
        "Estado": estado,
        "topeMinimo": topeMinimo,
        "NitCliente": nitCliente,
        "montominimofrecuencia": montoMinimoFrecuencia,
        "montominimonofrecuencia": montoMinimoNoFrecuencia,
        "RazonSocial": razonSocial,
        "diavisita" : diaVisita,
        "restrictivonofrecuencia" : restrictivoNoFrecuencia,
        "restrictivofrecuencia" : restrictivoFrecuencia,
        "hora" : hora
      };
}
