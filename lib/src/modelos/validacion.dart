import 'dart:convert';

Validacion validacionFromJson(String str) =>
    Validacion.fromJson(json.decode(str));

String validacionToJson(Validacion data) => json.encode(data.toJson());

class Validacion {
  Validacion({
    required this.codigo,
    required this.activo,
    required this.codTienda,
    required this.tieneDomicilio,
    this.telefonos,
    this.email,
    this.pais,
  });

  int codigo;
  int activo;
  int codTienda;
  int tieneDomicilio;
  List<String>? telefonos;
  String? email;
  String? pais;

  factory Validacion.fromJson(Map<String, dynamic> json) => Validacion(
        codigo: json["Codigo"] == null ? 0 : json["Codigo"],
        activo: json["Activo"] == null ? 0 : json["Activo"],
        codTienda: json["CodTienda"] == null ? 0 : json["CodTienda"],
        tieneDomicilio: json["TieneDomicilio"] == null
            ? 0
            : json["TieneDomicilio"],
        telefonos: json["Telefonos"] == null || json["Telefonos"] == 0
            ? ['sin informacion']
            : List<String>.from(json["Telefonos"].map((x) => x)),
        pais: json["Pais"] == null ? "CO" : json["Pais"],
        email: json["Email"],
      );

  Map<String, dynamic> toJson() => {
        "Codigo": codigo,
        "Activo": activo,
        "CodTienda": codTienda,
        "TieneDomicilio": tieneDomicilio,
        "Telefonos": List<dynamic>.from(telefonos!.map((x) => x)),
        "Pais": pais,
        "Email": email,
      };
}
