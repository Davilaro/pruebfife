import 'dart:convert';

Sucursales sucursalesFromJson(String str) => Sucursales.fromJson(json.decode(str));

String sucursalesToJson(Sucursales data) => json.encode(data.toJson());

class Sucursales {
    Sucursales({
        required this.nombre,
        required this.codigo,
        required this.razonSocial,
        required this.telefono,
        required this.direccion,
        required this.ciudad,
        required this.vendedor,
    });

    String nombre;
    String codigo;
    String razonSocial;
    String telefono;
    String direccion;
    String ciudad;
    String vendedor;

    factory Sucursales.fromJson(Map<String, dynamic> json) => Sucursales(
        nombre: json["nombre"],
        codigo: json["codigo"],
        razonSocial: json["razon_social"],
        telefono: json["telefono"],
        direccion: json["direccion"],
        ciudad: json["ciudad"],
        vendedor: json["vendedor"],
    );

    Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "codigo": codigo,
        "razon_social": razonSocial,
        "telefono": telefono,
        "direccion": direccion,
        "ciudad": ciudad,
        "vendedor": vendedor,
    };
}