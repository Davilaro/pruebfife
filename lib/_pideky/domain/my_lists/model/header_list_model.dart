// To parse this JSON data, do
//
//     final listaEncabezado = listaEncabezadoFromJson(jsonString);

import 'dart:convert';

HeaderList listaEncabezadoFromJson(String str) => HeaderList.fromJson(json.decode(str));

String listaEncabezadoToJson(HeaderList data) => json.encode(data.toJson());

class HeaderList {
    final int id;
    final String nombre;

    HeaderList({
        required this.id,
        required this.nombre,
    });

    HeaderList copyWith({
        int? id,
        String? nombre,
    }) => 
        HeaderList(
            id: id ?? this.id,
            nombre: nombre ?? this.nombre,
        );

    factory HeaderList.fromJson(Map<String, dynamic> json) => HeaderList(
        id: json["id"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
    };
}
