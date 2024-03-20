import 'package:emart/_pideky/presentation/cart/widgets/private_alerts.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

Widget botonGrandeConfigurar(
    size, BuildContext context, BuildContext context2) {
  return GestureDetector(
    onTap: () => {
      dialogEnviarPedido(size, context, context2),
    },
    child: Container(
      width: size.width * 0.9,
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: HexColor("#30C3A3"),
        borderRadius: BorderRadius.circular(20),
      ),
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Confirma tu pedido',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}
