// To parse this JSON data, do
//
//     final imagenPremios = imagenPremiosFromJson(jsonString);

import 'dart:convert';

ImagenPremios imagenPremiosFromJson(String str) =>
    ImagenPremios.fromJson(json.decode(str));

String imagenPremiosToJson(ImagenPremios data) => json.encode(data.toJson());

class ImagenPremios {
  ImagenPremios({
    this.url,
    this.orden,
  });

  String? url;
  int? orden;

  factory ImagenPremios.fromJson(Map<String, dynamic> json) => ImagenPremios(
        url: json["URL"],
        orden: json["orden"],
      );

  Map<String, dynamic> toJson() => {
        "URL": url,
        "orden": orden,
      };
}
