import 'dart:convert';

Multimedia multimediaFromJson(String str) =>
    Multimedia.fromJson(json.decode(str));

String multimediaToJson(Multimedia data) => json.encode(data.toJson());

class Multimedia {
  Multimedia({
    required this.link,
    required this.orientacion,
  });

  String link;
  String orientacion;

  factory Multimedia.fromJson(Map<String, dynamic> json) => Multimedia(
        link: json["Link"],
        orientacion: json["Orientacion"],
      );

  Map<String, dynamic> toJson() => {
        "Link": link,
        "Orientacion": orientacion,
      };
}
