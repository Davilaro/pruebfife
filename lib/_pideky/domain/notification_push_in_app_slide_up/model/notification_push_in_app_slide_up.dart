// To parse this JSON data, do
//
//     final notificationPushInAppSlideUpp = notificationPushInAppSlideUppFromJson(jsonString);

import 'dart:convert';

NotificationPushInAppSlideUpModel notificationPushInAppSlideUppFromJson(
        String str) =>
    NotificationPushInAppSlideUpModel.fromJson(json.decode(str));

String notificationPushInAppSlideUppToJson(
        NotificationPushInAppSlideUpModel data) =>
    json.encode(data.toJson());

class NotificationPushInAppSlideUpModel {
  String? fabricante;
  String? nombreComercial;
  String? imageUrl;
  String? descripcion;
  String? ubicacion;
  String? categoriaUbicacion;
  String? subCategoriaUbicacion;
  String? redireccion;
  String? categoriaRedireccion;
  String? subCategoriaRedireccion;

  NotificationPushInAppSlideUpModel({
    this.fabricante,
    this.nombreComercial,
    this.imageUrl,
    this.descripcion,
    this.ubicacion,
    this.categoriaUbicacion,
    this.subCategoriaUbicacion,
    this.redireccion,
    this.categoriaRedireccion,
    this.subCategoriaRedireccion,
  });

  factory NotificationPushInAppSlideUpModel.fromJson(
          Map<String, dynamic> json) =>
      NotificationPushInAppSlideUpModel(
        fabricante: json["empresa"] == null ? "" : json["empresa"],
        nombreComercial:
            json["nombreComercial"] == null ? "" : json["nombreComercial"],
        imageUrl: json["imageUrl"] == null ? "" : json["imageUrl"],
        descripcion: json["descripcion"] == null ? "" : json["descripcion"],
        ubicacion: json["ubicacion"] == null ? "" : json["ubicacion"],
        categoriaUbicacion: json["categoriaUbicacion"] == null
            ? ""
            : json["categoriaUbicacion"],
        subCategoriaUbicacion: json["subCategoriaUbicacion"] == null
            ? ""
            : json["subCategoriaUbicacion"],
        redireccion: json["redireccion"] == null ? "" : json["redireccion"],
        categoriaRedireccion: json["categoriaRedireccion"] == null
            ? ""
            : json["categoriaRedireccion"],
        subCategoriaRedireccion: json["subCategoriaRedireccion"] == null
            ? ""
            : json["subCategoriaRedireccion"],
      );

  Map<String, dynamic> toJson() => {
        "empresa": fabricante,
        "nombreComercial": nombreComercial,
        "imageUrl": imageUrl,
        "descripcion": descripcion,
        "ubicacion": ubicacion,
        "categoriaUbicacion": categoriaUbicacion,
        "subCategoriaUbicacion": subCategoriaUbicacion,
        "redireccion": redireccion,
        "categoriaRedireccion": categoriaRedireccion,
        "subCategoriaRedireccion": subCategoriaRedireccion,
      };
}
