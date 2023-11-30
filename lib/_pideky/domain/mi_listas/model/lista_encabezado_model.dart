// To parse this JSON data, do
//
//     final listaEncabezado = listaEncabezadoFromJson(jsonString);

import 'dart:convert';

ListaEncabezado listaEncabezadoFromJson(String str) => ListaEncabezado.fromJson(json.decode(str));

String listaEncabezadoToJson(ListaEncabezado data) => json.encode(data.toJson());

class ListaEncabezado {
    final int id;
    final String nombre;

    ListaEncabezado({
        required this.id,
        required this.nombre,
    });

    ListaEncabezado copyWith({
        int? id,
        String? nombre,
    }) => 
        ListaEncabezado(
            id: id ?? this.id,
            nombre: nombre ?? this.nombre,
        );

    factory ListaEncabezado.fromJson(Map<String, dynamic> json) => ListaEncabezado(
        id: json["id"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
    };
}
