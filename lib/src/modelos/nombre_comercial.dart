import 'dart:convert';

NombreComercial nombreComercialFromJson(String str) => NombreComercial.fromJson(json.decode(str));

String nombreComercialToJson(NombreComercial data) => json.encode(data.toJson());

class NombreComercial {
    NombreComercial({
        required this.nombreComercial,
    });

    String nombreComercial;


    factory NombreComercial.fromJson(Map<String, dynamic> json) => NombreComercial(
        nombreComercial: json["nombrecomercial"],

    );

    Map<String, dynamic> toJson() => {
        "nombreComercial": nombreComercial,
    };
}
