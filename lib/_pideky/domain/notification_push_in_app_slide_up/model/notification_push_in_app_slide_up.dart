import 'dart:convert';

NotificationPushInAppSlideUpp notificationPushInAppSlideUpFromJson(String str) => NotificationPushInAppSlideUpp.fromJson(json.decode(str));

String notificationPushInAppSlideUpToJson(NotificationPushInAppSlideUpp data) => json.encode(data.toJson());

class NotificationPushInAppSlideUpp {
  NotificationPushInAppSlideUpp(
      {this.fabricante,
      this.idNotification,
      this.link,
      this.empresa,
      this.nombrecomercial,
      this.tipofabricante,
      this.notificationName,
      this.seccion,
      this.subSeccion,
      this.tipoSeccion});

  String? fabricante;
  int? idNotification;
  String? link;
  String? empresa;
  String? tipofabricante;
  String? nombrecomercial;
  String? notificationName;
  String? seccion;
  String? subSeccion;
  String? tipoSeccion;

  factory NotificationPushInAppSlideUpp.fromJson(Map<String, dynamic> json) => NotificationPushInAppSlideUpp(
        fabricante: json["fabricante"],
        idNotification: json["Id"],
        link: json["Ico"],
        empresa: json["empresa"],
        tipofabricante: json["tipofabricante"],
        nombrecomercial: json["nombrecomercial"],
        notificationName: json["nombrenotificacion"],
        tipoSeccion: json["tipoSeccion"],
        seccion: json["seccion"],
        subSeccion: json["subSeccion"],
      );

  Map<String, dynamic> toJson() => {
        "fabricante": fabricante,
        "Id": idNotification,
        "Ico": link,
        "tipofabricante": tipofabricante,
        "empresa": empresa,
        "nombrecomercial": nombrecomercial,
        "nombrenotificacion": notificationName,
        "tipoSeccion": tipoSeccion,
        "seccion": seccion,
        "subSeccion": subSeccion
      };
}
