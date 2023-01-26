import 'dart:convert';

DatosCliente datosClienteFromJson(String str) =>
    DatosCliente.fromJson(json.decode(str));

String datosClienteToJson(DatosCliente data) => json.encode(data.toJson());

class DatosCliente {
  DatosCliente({
    this.codigo,
    this.nombre,
    this.razonsocial,
    this.nit,
    this.direccion,
    this.ciudad,
    this.telefono,
    this.telefonoWhatsapp,
    this.condicion_pago,
    this.pais,
  });

  String? codigo;
  String? nombre;
  String? razonsocial;
  String? nit;
  String? direccion;
  String? ciudad;
  String? telefono;
  String? telefonoWhatsapp;
  String? condicion_pago;
  String? pais;

  factory DatosCliente.fromJson(Map<String, dynamic> json) => DatosCliente(
        codigo: json["codigo"],
        nombre: json["nombre"],
        razonsocial: json["razonsocial"],
        nit: json["nit"],
        direccion: json["direccion"],
        ciudad: json["ciudad"],
        telefono: json["telefono"],
        telefonoWhatsapp: json["telefonowhatsapp"],
        condicion_pago: json["condicion_pago"],
        pais: json["Pais"]
      );

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "nombre": nombre,
        "razonsocial": razonsocial,
        "nit": nit,
        "direccion": direccion,
        "ciudad": ciudad,
        "telefono": telefono,
        "telefonowhatsapp": telefonoWhatsapp,
        "condicion_pago": condicion_pago,
        "Pais" : pais
      };
}
