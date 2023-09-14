// To parse this JSON data, do
//
//     final securityQuestionModel = securityQuestionModelFromJson(jsonString);

import 'dart:convert';

SecurityQuestionModel securityQuestionModelFromJson(String str) =>
    SecurityQuestionModel.fromJson(json.decode(str));

String securityQuestionModelToJson(SecurityQuestionModel data) =>
    json.encode(data.toJson());

class SecurityQuestionModel {
  String? codigoCorrecto;
  List<String>? codigoIncorrecto;
  String? negocio;

  SecurityQuestionModel({
    this.codigoCorrecto,
    this.codigoIncorrecto,
    this.negocio,
  });

  factory SecurityQuestionModel.fromJson(Map<String, dynamic> json) =>
      SecurityQuestionModel(
        codigoCorrecto:
            json["CodigoCorrecto"] == null ? '' : json["CodigoCorrecto"],
        codigoIncorrecto: json["CodigoIncorrecto"] == null
            ? []
            : List<String>.from(json["CodigoIncorrecto"]!.map((x) => x)),
        negocio: json["Negocio"] == null ? '' : json["Negocio"],
      );

  Map<String, dynamic> toJson() => {
        "CodigoCorrecto": codigoCorrecto,
        "CodigoIncorrecto": codigoIncorrecto == null
            ? []
            : List<dynamic>.from(codigoIncorrecto!.map((x) => x)),
        "Negocio": negocio,
      };
}
