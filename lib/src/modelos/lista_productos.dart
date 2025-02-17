import 'dart:convert';

import 'package:emart/_pideky/domain/product/model/product_model.dart';

ListaProductos listaProductosFromJson(String str) =>
    ListaProductos.fromJson(json.decode(str));

String listaProductosToJson(ListaProductos data) => json.encode(data.toJson());

class ListaProductos {
  ListaProductos({
    required this.total,
    required this.pages,
    required this.next,
    required this.prev,
    required this.now,
    required this.result,
  });

  int total;
  double pages;
  int next;
  int prev;
  int now;
  List<Product> result;

  factory ListaProductos.fromJson(Map<String, dynamic> json) => ListaProductos(
        total: json["total"],
        pages: json["pages"],
        next: json["next"],
        prev: json["prev"],
        now: json["now"],
        result: List<Product>.from(
            json["result"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "pages": pages,
        "next": next,
        "prev": prev,
        "now": now,
        "result": List<dynamic>.from(result.map((x) => x)),
      };
}
