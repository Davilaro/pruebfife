// To parse this JSON data, do
//
//     final pedidoSugerido = pedidoSugeridoFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

PagosNequiModel pedidoSugeridoFromJson(String str) =>
    PagosNequiModel.fromJson(json.decode(str));

String pedidoSugeridoToJson(PagosNequiModel data) => json.encode(data.toJson());

class PagosNequiModel {
  PagosNequiModel({
    this.ccup,
    this.celular,
    this.fechaPago,
    this.valorPago,
    this.tipoPago,
  });

  String? ccup;
  String? celular;
  String? fechaPago;
  String? valorPago;
  int? tipoPago;

  factory PagosNequiModel.fromJson(Map<String, dynamic> json) =>
      PagosNequiModel(
        ccup: json["CCUP"],
        celular: json["celular"],
        fechaPago: json["fechaPago"],
        valorPago: json["valorPago"],
        tipoPago: json["tipoPago"],
      );

  Map<String, dynamic> toJson() => {
        "CCUP": ccup,
        "celular": celular,
        "fechaPago": fechaPago,
        "valorPago": valorPago,
        "tipoPago": tipoPago,
      };
}
