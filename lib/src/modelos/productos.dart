import 'dart:convert';

Productos productosFromJson(String str) => Productos.fromJson(json.decode(str));

String productosToJson(Productos data) => json.encode(data.toJson());

class Productos {
  Productos({
    required this.codigo,
    required this.nombre,
    required this.precio,
    required this.unidad,
    required this.linea,
    required this.marca,
    required this.categoria,
    required this.ean,
    required this.peso,
    required this.longitud,
    required this.altura,
    required this.ancho,
    required this.volumen,
    required this.iva,
    this.fabricante,
    this.cantidad = 0,
    required this.nombrecomercial,
    this.codigocliente,
    this.descuento,
    this.preciodescuento,
    this.precioinicial,
  });

  String codigo;
  String nombre;
  double precio;
  String unidad;
  String linea;
  String marca;
  String categoria;
  String ean;
  String peso;
  int longitud;
  int altura;
  int ancho;
  int volumen;
  int iva;
  String? fabricante;
  int cantidad = 0;
  String nombrecomercial;
  String? codigocliente;
  double? descuento;
  double? preciodescuento;
  double? precioinicial;

  factory Productos.fromJson(Map<String, dynamic> json) => Productos(
        codigo: json["codigo"] == null ? '' : json["codigo"],
        nombre: json["nombre"] == null ? '' : json["nombre"],
        precio: json["precio"] == null ? 0 : json["precio"],
        unidad: json["unidad"] == null ? '' : json["unidad"],
        linea: json["linea"] == null ? '' : json["linea"],
        marca: json["marca"] == null ? '' : json["marca"],
        categoria: json["categoria"] == null ? '' : json["categoria"],
        ean: json["ean"] == null ? '' : json["ean"],
        peso: json["peso"] == null ? '' : json["peso"],
        longitud: json["longitud"] == null ? 0 : json["longitud"],
        altura: json["altura"] == null ? 0 : json["altura"],
        ancho: json["ancho"] == null ? 0 : json["altura"],
        volumen: json["volumen"] == null ? 0 : json["volumen"],
        iva: json["iva"] == null ? 0 : json["iva"],
        fabricante: json["fabricante"] == null ? '' : json["fabricante"],
        cantidad: json["cantidad"] == null ? 0 : json["cantidad"],
        nombrecomercial: json["nombrecomercial"],
        codigocliente: json["codigocliente"],
        descuento: json["descuento"],
        preciodescuento: json["preciodescuento"],
        precioinicial: json["precioinicial"],
      );

  factory Productos.fromJson2(Map<dynamic, dynamic> json) => Productos(
        codigo: json["codigo"] == null ? '' : json["codigo"],
        nombre: json["nombre"] == null ? '' : json["nombre"],
        precio: json["precio"] == null ? 0 : json["precio"],
        unidad: json["unidad"] == null ? '' : json["unidad"],
        linea: json["linea"] == null ? '' : json["linea"],
        marca: json["marca"] == null ? '' : json["marca"],
        categoria: json["categoria"] == null ? '' : json["categoria"],
        ean: json["ean"] == null ? '' : json["ean"],
        peso: json["peso"] == null ? '' : json["peso"],
        longitud: json["longitud"] == null ? 0 : json["longitud"],
        altura: json["altura"] == null ? 0 : json["altura"],
        ancho: json["ancho"] == null ? 0 : json["altura"],
        volumen: json["volumen"] == null ? 0 : json["volumen"],
        iva: json["iva"] == null ? 0 : json["iva"],
        fabricante: json["fabricante"] == null ? '' : json["fabricante"],
        cantidad: json["cantidad"] == null ? 0 : json["cantidad"],
        nombrecomercial: json["nombrecomercial"],
        codigocliente: json["codigocliente"],
        descuento: json["descuento"],
        preciodescuento: json["preciodescuento"],
        precioinicial: json["precioinicial"],
      );

  Map<String, dynamic> toJson() => {
        "codigoSku": codigo,
        "nombre": nombre,
        "precio": precio,
        "unidad": unidad,
        "linea": linea,
        "marca": marca,
        "categoria": categoria,
        "ean": ean,
        "peso": peso,
        "longitud": longitud,
        "altura": altura,
        "ancho": ancho,
        "volumen": volumen,
        "iva": iva,
        "fabricante": fabricante,
        "cantidad": cantidad,
        "nombrecomercial": nombrecomercial,
        "codigocliente": codigocliente,
        "descuento": descuento,
        "preciodescuento": preciodescuento,
        "precioinicial": precioinicial,
      };
}
