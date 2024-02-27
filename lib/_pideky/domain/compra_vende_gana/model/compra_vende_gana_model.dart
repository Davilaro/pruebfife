// To parse this JSON data, do
//
//     final compraVendeGana = compraVendeGanaFromJson(jsonString);


class CompraVendeGanaModel {
  String? nombre;
  String? codigo;
  double? precio;
  double? vende;
  double? gana;
  int? chispa;
  double? valorChispa;
  String? colorCupon;
  String? proveedor;
  String? link;
  String? colorLetra1;
  String? colorLetra2;
  String? colorChispa;

  CompraVendeGanaModel({
    this.nombre,
    this.codigo,
    this.precio,
    this.vende,
    this.gana,
    this.chispa,
    this.valorChispa,
    this.colorCupon,
    this.proveedor,
    this.link,
    this.colorLetra1,
    this.colorLetra2,
    this.colorChispa,
  });

  CompraVendeGanaModel copyWith({
    String? nombre,
    String? codigo,
    double? precio,
    double? vende,
    double? gana,
    int? chispa,
    double? valorChispa,
    String? colorCupon,
    String? proveedor,
    String? link,
    String? colorLetra1,
    String? colorLetra2,
    String? colorChispa,
  }) =>
      CompraVendeGanaModel(
        nombre: nombre ?? this.nombre,
        codigo: codigo ?? this.codigo,
        precio: precio ?? this.precio,
        vende: vende ?? this.vende,
        gana: gana ?? this.gana,
        chispa: chispa ?? this.chispa,
        valorChispa: valorChispa ?? this.valorChispa,
        colorCupon: colorCupon ?? this.colorCupon,
        proveedor: proveedor ?? this.proveedor,
        link: link ?? this.link,
        colorLetra1: colorLetra1 ?? this.colorLetra1,
        colorLetra2: colorLetra2 ?? this.colorLetra2,
        colorChispa: colorChispa ?? this.colorChispa,
      );

  factory CompraVendeGanaModel.fromJson(Map<String, dynamic> json) =>
      CompraVendeGanaModel(
        nombre: json["nombre"] ?? '',
        codigo: json["codigo"] ?? '',
        precio: json["precio"]?.toDouble() ?? 0.0,
        vende: json["vende"]?.toDouble() ?? 0.0,
        gana: json["gana"]?.toDouble() ?? 0.0,
        chispa: json["chispa"] ?? 0,
        valorChispa: json["valorChispa"]?.toDouble() ?? 0.0,
        colorCupon: json["colorCupon"] ?? '',
        proveedor: json["proveedor"] ?? '',
        link: json["link"] ?? '',
        colorLetra1: json["colorLetra1"] ?? '',
        colorLetra2: json["colorLetra2"] ?? '',
        colorChispa: json["colorChispa"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "codigo": codigo,
        "precio": precio,
        "vende": vende,
        "gana": gana,
        "chispa": chispa,
        "valorChispa": valorChispa,
        "colorCupon": colorCupon,
        "proveedor": proveedor,
        "link": link,
        "colorLetra1": colorLetra1,
        "colorLetra2": colorLetra2,
        "colorChispa": colorChispa,
      };
}
