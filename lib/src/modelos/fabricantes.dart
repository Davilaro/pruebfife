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
      this.estado,
      this.topeMinimo,
      this.nitCliente});

  String? empresa;
  String? icono;
  String? tipofabricante;
  String? codIndirecto;
  double? pedidominimo;
  String? nombrecomercial;
  String? estado;
  double? topeMinimo;
  String? nitCliente;

  factory Fabricantes.fromJson(Map<String, dynamic> json) => Fabricantes(
        empresa: json["empresa"],
        icono: json["ico"],
        tipofabricante: json["tipofabricante"],
        codIndirecto: json["codIndirecto"],
        pedidominimo: json["pedidominimo"],
        nombrecomercial: json["nombrecomercial"],
        estado: json["Estado"],
        topeMinimo: json["topeMinimo"],
        nitCliente: json["NitCliente"],
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
        "NitCliente": nitCliente
      };
}
