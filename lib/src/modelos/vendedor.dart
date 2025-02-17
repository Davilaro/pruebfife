import 'dart:convert';

Vendedor vendedorFromJson(String str) => Vendedor.fromJson(json.decode(str));

String vendedorToJson(Vendedor data) => json.encode(data.toJson());

class Vendedor {
  Vendedor({
    this.nombre,
    this.telefono,
    this.nombreComercial,
    this.nombreEmpresa,
    this.icono,
    this.indicativo,
    this.codigoVendedor,
  });

  String? nombre;
  String? telefono;
  String? nombreComercial;
  String? nombreEmpresa;
  String? icono;
  String? indicativo;
  String? codigoVendedor;

  factory Vendedor.fromJson(Map<String, dynamic> json) => Vendedor(
        nombre: json["nombrevendedor"],
        telefono: json["telefonovendedor"],
        nombreComercial: json["nombrecomercial"],
        nombreEmpresa: json["empresa"],
        icono: json["ico"],
        indicativo: json["Indicativo"],
        codigoVendedor: json["codigovendedor"],
      );

  Map<String, dynamic> toJson() => {
        "nombrevendedor": nombre,
        "telefonovendedor": telefono,
        "nombrecomercial": nombreComercial,
        "empresa": nombreEmpresa,
        "Indicativo": indicativo,
        "codigovendedor": codigoVendedor,
      };
}
