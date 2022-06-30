import 'dart:convert';

ValidarPedido validarPedidoFromJson(String str) => ValidarPedido.fromJson(json.decode(str));

String validarPedidoToJson(ValidarPedido data) => json.encode(data.toJson());

class ValidarPedido {
    ValidarPedido({
        this.estado,
        this.mensaje,
    });

    String? estado;
    String? mensaje;

    factory ValidarPedido.fromJson(Map<String, dynamic> json) => ValidarPedido(
        estado: json["Estado"],
        mensaje: json["Mensaje"],
    );

    Map<String, dynamic> toJson() => {
        "Estado": estado,
        "Mensaje": mensaje,
    };
}