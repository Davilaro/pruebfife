import 'dart:convert';

import 'package:emart/_pideky/domain/sucursal/model/sucursales.dart';

ListaEmpresas ListaEmpresasFromJson(String str) =>
    ListaEmpresas.fromJson(json.decode(str));

String ListaEmpresasToJson(ListaEmpresas data) => json.encode(data.toJson());

class ListaEmpresas {
  ListaEmpresas({
    required this.numEmpresa,
    required this.codigoEmpresa,
    required this.nombreEmpresa,
    required this.tipo,
    required this.url,
    required this.path,
    required this.imagen,
    required this.pedidoMinimo,
    required this.maxPedidos,
    required this.textoInicial,
    required this.textoFinal,
    required this.urlSync,
    required this.color,
    required this.horaLimite,
    required this.cantDecimales,
    required this.moneda,
    required this.impuesto,
    required this.labelCondiciones1,
    required this.urlCondiciones1,
    required this.labelCondiciones2,
    required this.urlCondiciones2,
    required this.sucursales,
  });

  int numEmpresa;
  String codigoEmpresa;
  String nombreEmpresa;
  String tipo;
  String url;
  String path;
  String imagen;
  int pedidoMinimo;
  int maxPedidos;
  String textoInicial;
  String textoFinal;
  String urlSync;
  String color;
  String horaLimite;
  int cantDecimales;
  String moneda;
  String impuesto;
  String labelCondiciones1;
  String urlCondiciones1;
  String labelCondiciones2;
  String urlCondiciones2;
  List<Sucursales> sucursales;

  factory ListaEmpresas.fromJson(Map<String, dynamic> json) => ListaEmpresas(
        numEmpresa: json["num_empresa"],
        codigoEmpresa: json["codigo_empresa"],
        nombreEmpresa: json["nombre_empresa"],
        tipo: json["tipo"],
        url: json["url"],
        path: json["path"],
        imagen: json["imagen"],
        pedidoMinimo: json["pedido_minimo"],
        maxPedidos: json["max_pedidos"],
        textoInicial: json["texto_inicial"],
        textoFinal: json["texto_final"],
        urlSync: json["url_sync"],
        color: json["color"],
        horaLimite: json["hora_limite"],
        cantDecimales: json["cant_decimales"],
        moneda: json["moneda"],
        impuesto: json["impuesto"],
        labelCondiciones1: json["label_condiciones1"],
        urlCondiciones1: json["url_condiciones1"],
        labelCondiciones2: json["label_condiciones2"],
        urlCondiciones2: json["url_condiciones2"],
        sucursales: List<Sucursales>.from(
            json["sucursales"].map((x) => Sucursales.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "num_empresa": numEmpresa,
        "codigo_empresa": codigoEmpresa,
        "nombre_empresa": nombreEmpresa,
        "tipo": tipo,
        "url": url,
        "path": path,
        "imagen": imagen,
        "pedido_minimo": pedidoMinimo,
        "max_pedidos": maxPedidos,
        "texto_inicial": textoInicial,
        "texto_final": textoFinal,
        "url_sync": urlSync,
        "color": color,
        "hora_limite": horaLimite,
        "cant_decimales": cantDecimales,
        "moneda": moneda,
        "impuesto": impuesto,
        "label_condiciones1": labelCondiciones1,
        "url_condiciones1": urlCondiciones1,
        "label_condiciones2": labelCondiciones2,
        "url_condiciones2": urlCondiciones2,
        "sucursales": List<dynamic>.from(sucursales.map((x) => x.toJson())),
      };
}
