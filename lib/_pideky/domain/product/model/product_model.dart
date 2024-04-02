import 'dart:convert';

Product productosFromJson(String str) => Product.fromJson(json.decode(str));

String productosToJson(Product data) => json.encode(data.toJson());

class Product {
  Product(
      {required this.codigo,
      required this.nombre,
      required this.precio,
      // required this.unidad,
      // required this.linea,
      required this.marca,
      required this.categoria,
      // required this.ean,
      // required this.peso,
      // required this.longitud,
      // required this.altura,
      // required this.ancho,
      // required this.volumen,
      required this.iva,
      this.fabricante,
      this.codigoFabricante,
      this.nitFabricante,
      this.cantidad = 0,
      required this.nombrecomercial,
      this.codigocliente,
      this.descuento,
      this.ordenMarca,
      this.ordenSubcategoria,
      this.preciodescuento,
      this.precioinicial,
      this.activoprodnuevo,
      this.activopromocion,
      this.fechafinnuevo_1,
      required this.bloqueoCartera,
      this.isOferta,
      this.precioBase,
      this.precioConDescuento,
      this.combo,
      this.negocio,
      this.fechafinpromocion_1});

  String codigo;
  String nombre;
  String? negocio;
  double precio;
  double? precioBase;
  // String unidad;
  // String linea;
  String marca;
  String categoria;
  int bloqueoCartera;
  int? combo;
  int? isOferta;
  // String ean;
  // String peso;
  // int longitud;
  // int altura;
  // int ancho;
  // int volumen;
  int iva;
  String? fabricante;
  String? codigoFabricante;
  String? nitFabricante;
  int cantidad = 0;
  String nombrecomercial;
  String? codigocliente;
  double? descuento;
  double? preciodescuento;
  double? precioConDescuento;
  double? precioinicial;
  int? activopromocion;
  int? activoprodnuevo;
  String? fechafinpromocion_1;
  String? fechafinnuevo_1;
  int? ordenMarca;
  int? ordenSubcategoria;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      codigo: json["codigo"] == null ? '' : json["codigo"],
      nombre: json["nombre"] == null ? '' : json["nombre"],
      precio: json["precio"] == null ? 0 : json["precio"],
      // unidad: json["unidad"] == null ? '' : json["unidad"],
      // linea: json["linea"] == null ? '' : json["linea"],
      marca: json["marca"] == null ? '' : json["marca"],
      categoria: json["categoria"] == null ? '' : json["categoria"],
      // ean: json["ean"] == null ? '' : json["ean"],
      // peso: json["peso"] == null ? '' : json["peso"],
      // longitud: json["longitud"] == null ? 0 : json["longitud"],
      // altura: json["altura"] == null ? 0 : json["altura"],
      // ancho: json["ancho"] == null ? 0 : json["altura"],
      // volumen: json["volumen"] == null ? 0 : json["volumen"],
      iva: json["iva"] == null ? 0 : json["iva"],
      fabricante: json["fabricante"] == null ? '' : json["fabricante"],
      codigoFabricante:
          json["codigoFabricante"] == null ? '' : json["codigoFabricante"],
      nitFabricante: json["nitFabricante"] == null ? '' : json["nitFabricante"],
      cantidad: json["cantidad"] == null ? 0 : json["cantidad"],
      nombrecomercial:
          json["nombrecomercial"] == null ? '' : json["nombrecomercial"],
      codigocliente: json["codigocliente"] == null ? '' : json["codigocliente"],
      descuento: json["descuento"] == null ? 0.0 : json["descuento"],
      preciodescuento:
          json["preciodescuento"] == null ? 0.0 : json["preciodescuento"],
      precioinicial:
          json["precioinicial"] == null ? 0.0 : json["precioinicial"],
      activoprodnuevo:
          json["activoprodnuevo"] == null ? 0 : json["activoprodnuevo"],
      activopromocion:
          json["activopromocion"] == null ? 0 : json["activopromocion"],
      fechafinnuevo_1:
          json["fechafinnuevo_1"] == null ? '' : json["fechafinnuevo_1"],
      fechafinpromocion_1: json["fechafinpromocion_1"] == null
          ? ''
          : json["fechafinpromocion_1"],
      bloqueoCartera:
          json["bloqueoCartera"] == null ? 0 : json["bloqueoCartera"],
      ordenMarca: json["ordenMarca"] == null ? 0 : json["ordenMarca"],
      ordenSubcategoria:
          json["ordenSubcategoria"] == null ? 0 : json["ordenSubcategoria"],
      precioBase: json["precioBase"] == null ? 0.0 : json["precioBase"],
      isOferta: json["isOferta"] == null ? 0 : json["isOferta"],
      negocio: json["negocio"] == null ? '' : json["negocio"],
      combo: json["combo"] == null ? 0 : json["combo"],
      precioConDescuento: json["precioConDescuento"] == null
          ? 0.0
          : json['precioConDescuento']);

  factory Product.fromJson2(Map<dynamic, dynamic> json) => Product(
      codigo: json["codigo"] == null ? '' : json["codigo"],
      nombre: json["nombre"] == null ? '' : json["nombre"],
      precio: json["precio"] == null ? 0 : json["precio"],
      // unidad: json["unidad"] == null ? '' : json["unidad"],
      // linea: json["linea"] == null ? '' : json["linea"],
      marca: json["marca"] == null ? '' : json["marca"],
      categoria: json["categoria"] == null ? '' : json["categoria"],
      // ean: json["ean"] == null ? '' : json["ean"],
      // peso: json["peso"] == null ? '' : json["peso"],
      // longitud: json["longitud"] == null ? 0 : json["longitud"],
      // altura: json["altura"] == null ? 0 : json["altura"],
      // ancho: json["ancho"] == null ? 0 : json["altura"],
      // volumen: json["volumen"] == null ? 0 : json["volumen"],
      iva: json["iva"] == null ? 0 : json["iva"],
      fabricante: json["fabricante"] == null ? '' : json["fabricante"],
      codigoFabricante:
          json["codigoFabricante"] == null ? '' : json["codigoFabricante"],
      nitFabricante: json["nitFabricante"] == null ? '' : json["nitFabricante"],
      cantidad: json["cantidad"] == null ? 0 : json["cantidad"],
      nombrecomercial:
          json["nombrecomercial"] == null ? '' : json["nombrecomercial"],
      codigocliente: json["codigocliente"] == null ? '' : json["codigocliente"],
      descuento: json["descuento"] == null ? 0 : json["descuento"],
      preciodescuento:
          json["preciodescuento"] == null ? 0 : json["preciodescuento"],
      precioinicial: json["precioinicial"] == null ? 0 : json["precioinicial"],
      activopromocion:
          json["activopromocion"] == null ? 0 : json["activopromocion"],
      activoprodnuevo:
          json["activoprodnuevo"] == null ? 0 : json["activoprodnuevo"],
      fechafinnuevo_1:
          json["fechafinnuevo_1"] == null ? '' : json["fechafinnuevo_1"],
      fechafinpromocion_1: json["fechafinpromocion_1"] == null
          ? ''
          : json["fechafinpromocion_1"],
      bloqueoCartera:
          json["bloqueoCartera"] == null ? 0 : json["bloqueoCartera"],
      ordenMarca: json["ordenMarca"] == null ? 0 : json["ordenMarca"],
      ordenSubcategoria:
          json["ordenSubcategoria"] == null ? 0 : json["ordenSubcategoria"],
      precioBase: json["precioBase"] == null ? 0 : json["precioBase"],
      isOferta: json["isOferta"] == null ? 0 : json["isOferta"],
      negocio: json["negocio"] == null ? '' : json["negocio"],
      combo: json["combo"] == null ? 0 : json["combo"],
      precioConDescuento: json["precioConDescuento"] == null
          ? 0.0
          : json['precioConDescuento']);

  Map<String, dynamic> toJson() => {
        "codigoSku": codigo,
        "nombre": nombre,
        "precio": precio,
        // "unidad": unidad,
        // "linea": linea,
        "marca": marca,
        "categoria": categoria,
        // "ean": ean,
        // "peso": peso,
        // "longitud": longitud,
        // "altura": altura,
        // "ancho": ancho,
        // "volumen": volumen,
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
        "fechafinpromocion_1": fechafinpromocion_1,
        'bloqueoCartera': bloqueoCartera,
        "ordenMarca": ordenMarca,
        "ordenSubcategoria": ordenSubcategoria,
      };
}
