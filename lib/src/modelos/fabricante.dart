import 'dart:convert';

Fabricante fabricantesFromJson(String str) =>
    Fabricante.fromJson(json.decode(str));

String fabricantesToJson(Fabricante data) => json.encode(data.toJson());

class Fabricante {
  Fabricante(
      {this.empresa,
      this.icono,
      this.codigo,
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
      this.itinerario,
      this.hora,
      this.texto1,
      this.texto2,
      this.diaVisita,
      this.verPopUp,
      this.bloqueoCartera,
      required this.diasEntrega,
      this.prospectoHelados,
      this.razonSocial,
      this.diasEntregaExtraRuta
      });

  String? empresa;
  String? icono;
  String? tipofabricante;
  // String? codIndirecto;
  String? nombrecomercial;
  String? estado;
  String? codigo;
  String? hora;
  double? topeMinimo;
  int? montoMinimoFrecuencia;
  int? montoMinimoNoFrecuencia;
  int? restrictivoFrecuencia;
  int? restrictivoNoFrecuencia;
  int? itinerario;
  int? bloqueoCartera;
  int? verPopUp;
  String? texto1;
  String? texto2;
  String? diaVisita;
  int diasEntrega;
  int? diasEntregaExtraRuta;
  String? nitCliente;
  String? razonSocial;
  int? prospectoHelados;


  factory Fabricante.fromJson(Map<String, dynamic> json) => Fabricante(
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
      hora: json["hora"] == null ? '' : json["hora"],
      montoMinimoFrecuencia: json["montominimofrecuencia"] == null
          ? 0
          : json["montominimofrecuencia"],
      montoMinimoNoFrecuencia: json["montominimonofrecuencia"] == null
          ? 0
          : json["montominimonofrecuencia"],
      restrictivoFrecuencia: json["restrictivofrecuencia"] == null
          ? 0
          : json["restrictivofrecuencia"],
      restrictivoNoFrecuencia: json["restrictivonofrecuencia"] == null
          ? 0
          : json["restrictivonofrecuencia"],
      diaVisita: json["diavisita"] == null ? "" : json["diavisita"],
      texto1: json["texto1"] == null ? "" : json["texto1"],
      texto2: json["texto2"] == null ? "" : json["texto2"],
      itinerario: json["itinerario"] == null ? 0 : json["itinerario"],
      bloqueoCartera:
          json["bloqueoCartera"] == null ? 0 : json["bloqueoCartera"],
      verPopUp: json["verPopUp"] == null ? 0 : json["verPopUp"],
      diasEntrega: json["diasEntrega"] == null ? 0 : json["diasEntrega"],
      codigo: json["codigo"] == null ? '' : json["codigo"],
      prospectoHelados: json["prospectoHelados"] ?? 0,
      diasEntregaExtraRuta: json["diasEntregaExtraRuta"] == null ? 0 : json["diasEntregaExtraRuta"]
      );

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
        "texto2": texto2,
        "itinerario": itinerario,
        "diaEntrega": diasEntrega,
        "vePopUp": verPopUp,
        "codigo" : codigo,
        "prospectoHelados": prospectoHelados,
        "diasEntregaExtraRuta": diasEntregaExtraRuta
      };
}
