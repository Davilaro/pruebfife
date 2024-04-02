import 'dart:convert';

MyPaymentsModel pedidoSugeridoFromJson(String str) =>
    MyPaymentsModel.fromJson(json.decode(str));

String pedidoSugeridoToJson(MyPaymentsModel data) => json.encode(data.toJson());

class MyPaymentsModel {
  MyPaymentsModel({
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

  factory MyPaymentsModel.fromJson(Map<String, dynamic> json) =>
      MyPaymentsModel(
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
