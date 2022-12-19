import 'package:flutter/material.dart';

class TopText extends StatelessWidget {
  const TopText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 20,
        top: 14,
      ),
      alignment: Alignment.center,
      child: Text(
        "Tenemos un pedido sugerido para ti, para que no olvides ningún producto para tu negocio.",
        textAlign: TextAlign.start,
        style: TextStyle(
          height: 1.2,
          fontSize: 15,
          fontFamily: "RoundedMplus1c-Medium.ttf",
          color: Color(0xff707070),
        ),
      ),
    );
  }
}
