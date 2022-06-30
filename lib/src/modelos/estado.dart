import 'dart:convert';

Estado estadoFromJson(String str) => Estado.fromJson(json.decode(str));

String estadoToJson(Estado data) => json.encode(data.toJson());

class Estado {
    Estado({
        required this.estado,
        required this.mensaje,
    });

    String estado;
    String mensaje;

    factory Estado.fromJson(Map<String, dynamic> json) => Estado(
        estado: json["Estado"],
        mensaje: json["Messaje"],
    );

    Map<String, dynamic> toJson() => {
      "Estado": estado,
      "Messaje": mensaje,
    };
}
