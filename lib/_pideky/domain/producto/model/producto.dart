import 'dart:convert';

Producto productosFromJson(String str) => Producto.fromJson(json.decode(str));

String productosToJson(Producto data) => json.encode(data.toJson());

class Producto {
  Producto(
      {required this.codigo,
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
      this.codigoFabricante,
      this.nitFabricante,
      this.cantidad = 0,
      required this.nombrecomercial,
      this.codigocliente,
      this.descuento,
      this.preciodescuento,
      this.precioinicial,
      this.activoprodnuevo,
      this.activopromocion,
      this.fechafinnuevo_1,
      this.fechafinpromocion_1});

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
  String? codigoFabricante;
  String? nitFabricante;
  int cantidad = 0;
  String nombrecomercial;
  String? codigocliente;
  double? descuento;
  double? preciodescuento;
  double? precioinicial;
  int? activopromocion;
  int? activoprodnuevo;
  String? fechafinpromocion_1;
  String? fechafinnuevo_1;

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
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
        codigoFabricante:
            json["codigoFabricante"] == null ? '' : json["codigoFabricante"],
        nitFabricante:
            json["nitFabricante"] == null ? '' : json["nitFabricante"],
        cantidad: json["cantidad"] == null ? 0 : json["cantidad"],
        nombrecomercial: json["nombrecomercial"],
        codigocliente: json["codigocliente"],
        descuento: json["descuento"],
        preciodescuento: json["preciodescuento"],
        precioinicial: json["precioinicial"],
        activoprodnuevo: json["activoprodnuevo"],
        activopromocion: json["activopromocion"],
        fechafinnuevo_1: json["fechafinnuevo_1"],
        fechafinpromocion_1: json["fechafinpromocion_1"],
      );

  factory Producto.fromJson2(Map<dynamic, dynamic> json) => Producto(
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
        codigoFabricante:
            json["codigoFabricante"] == null ? '' : json["codigoFabricante"],
        nitFabricante:
            json["nitFabricante"] == null ? '' : json["nitFabricante"],
        cantidad: json["cantidad"] == null ? 0 : json["cantidad"],
        nombrecomercial: json["nombrecomercial"],
        codigocliente: json["codigocliente"],
        descuento: json["descuento"],
        preciodescuento: json["preciodescuento"],
        precioinicial: json["precioinicial"],
        activopromocion:
            json["activopromocion"] == null ? 0 : json["activopromocion"],
        activoprodnuevo:
            json["activoprodnuevo"] == null ? 0 : json["activoprodnuevo"],
        fechafinnuevo_1:
            json["fechafinnuevo_1"] == null ? '' : json["fechafinnuevo_1"],
        fechafinpromocion_1: json["fechafinpromocion_1"] == null
            ? ''
            : json["fechafinpromocion_1"],
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
        "codigoFabricante": codigoFabricante,
        "nitFabricante": nitFabricante,
        "cantidad": cantidad,
        "nombrecomercial": nombrecomercial,
        "codigocliente": codigocliente,
        "descuento": descuento,
        "preciodescuento": preciodescuento,
        "precioinicial": precioinicial,
        "activopromocion": activopromocion,
        "activoprodnuevo": activoprodnuevo,
        "fechafinnuevo_1": fechafinnuevo_1,
        "fechafinpromocion_1": fechafinpromocion_1
      };
}
