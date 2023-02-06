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
        empresa: json["empresa"],
        icono: json["ico"],
        tipofabricante: json["tipofabricante"],
        codIndirecto: json["codIndirecto"],
        pedidominimo: json["pedidominimo"],
        nombrecomercial: json["nombrecomercial"],
        estado: json["Estado"],
        hora: json["hora"],
        montoMinimoFrecuencia: json["montominimofrecuencia"],
        montoMinimoNoFrecuencia: json["montominimonofrecuencia"],
        topeMinimo: json["topeMinimo"],
        nitCliente: json["NitCliente"],
        razonSocial: json["RazonSocial"],
        restrictivoFrecuencia: json["restrictivofrecuencia"],
        restrictivoNoFrecuencia: json["restrictivonofrecuencia"],
        diaVisita: json["diavisita"],
        restrictivo: json['restrictivo'] == null ? '0' : json['restrictivo'],
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
        "RazonSocial": razonSocial
      };
}
