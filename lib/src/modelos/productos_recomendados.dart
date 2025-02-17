import 'dart:convert';

ProductosRecomendados productosFromJson(String str) =>
    ProductosRecomendados.fromJson(json.decode(str));

String productosToJson(ProductosRecomendados data) =>
    json.encode(data.toJson());

class ProductosRecomendados {
  ProductosRecomendados({
    this.codigo,
    this.nombre,
    this.precio,
    // this.longitud,
    // this.ancho,
    // this.volumen,
    this.iva,
    this.cantidad,
    // this.largo,
    // this.unidad,
    // this.peso,
    this.fabricante,
    this.nombrecomercial,
    this.codigocliente,
    this.descuento,
    this.preciodescuento,
  });

  String? codigo;
  String? nombre;
  String? cantidad;
  double? precio;
  // int? longitud;
  // String? largo;
  // int? ancho;
  // int? volumen;
  // String? unidad;
  int? iva;
  String? peso;
  String? fabricante;
  String? nombrecomercial;
  String? codigocliente;
  double? descuento;
  double? preciodescuento;

  factory ProductosRecomendados.fromJson(Map<String, dynamic> json) =>
      ProductosRecomendados(
        codigo: json["codigo"] == null ? '' : json["codigo"],
        nombre: json["Descripcion"] == null ? '' : json["Descripcion"],
        precio: json["precio"] == null ? 0 : json["precio"],
        // longitud: json["longitud"] == null ? '' : json["longitud"],
        // ancho: json["ancho"] == null ? '' : json["ancho"],
        // volumen: json["volumen"] == null ? '' : json["volumen"],
        iva: json["iva"] == null ? 0 : json["iva"],
        cantidad: json["cantidad"] == null ? '' : json["cantidad"],
        // largo: json["largo"] == null ? '' : json["largo"],
        // unidad: json["unidad"],
        // peso: json["peso"] == 0 ? '0' : json["peso"],
        fabricante: json["fabricante"] == null ? '' : json["fabricante"],
        nombrecomercial: json["nombrecomercial"] == null
            ? ''
            : json["nombrecomercial"],
        codigocliente: json["codigocliente"] == null ? '' : json["codigocliente"],
        descuento: json["descuento"] == null ? 0 : json["descuento"],
        preciodescuento: json["preciodescuento"] == null
            ? 0
            : json["preciodescuento"],
      );

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "nombre": nombre,
        "precio": precio,
        // "unidad": unidad,
        // "longitud": longitud,
        // "ancho": ancho,
        // "volumen": volumen,
        "iva": iva,
        "cantidad": cantidad,
        // "largo": largo,
        "peso": peso,
        "fabricante": fabricante,
        "nombrecomercial": nombrecomercial,
        "codigocliente": codigocliente,
        "descuento": descuento,
        "preciodescuento": preciodescuento,
      };
}
