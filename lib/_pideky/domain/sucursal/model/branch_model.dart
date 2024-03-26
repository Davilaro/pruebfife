import 'dart:convert';

BranchModel sucursalesFromJson(String str) => BranchModel.fromJson(json.decode(str));

String sucursalesToJson(BranchModel data) => json.encode(data.toJson());

class BranchModel {
  BranchModel({
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

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
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
