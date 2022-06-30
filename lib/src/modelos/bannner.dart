import 'dart:convert';

Banners bannersFromJson(String str) => Banners.fromJson(json.decode(str));

String bannersToJson(Banners data) => json.encode(data.toJson());

class Banners {
  Banners(
      {this.fabricante,
      this.idBanner,
      this.link,
      this.empresa,
      this.nombrecomercial,
      this.tipofabricante,
      this.nombreBanner,
      this.seccion,
      this.subSeccion,
      this.tipoSeccion});

  String? fabricante;
  int? idBanner;
  String? link;
  String? empresa;
  String? tipofabricante;
  String? nombrecomercial;
  String? nombreBanner;
  String? seccion;
  String? subSeccion;
  String? tipoSeccion;

  factory Banners.fromJson(Map<String, dynamic> json) => Banners(
        fabricante: json["fabricante"],
        idBanner: json["Id"],
        link: json["Ico"],
        empresa: json["empresa"],
        tipofabricante: json["tipofabricante"],
        nombrecomercial: json["nombrecomercial"],
        nombreBanner: json["nombrebanner"],
        tipoSeccion: json["tipoSeccion"],
        seccion: json["seccion"],
        subSeccion: json["subSeccion"],
      );

  Map<String, dynamic> toJson() => {
        "fabricante": fabricante,
        "Id": idBanner,
        "Ico": link,
        "tipofabricante": tipofabricante,
        "empresa": empresa,
        "nombrecomercial": nombrecomercial,
        "nombrebanner": nombreBanner,
        "tipoSeccion": tipoSeccion,
        "seccion": seccion,
        "subSeccion": subSeccion
      };
}
