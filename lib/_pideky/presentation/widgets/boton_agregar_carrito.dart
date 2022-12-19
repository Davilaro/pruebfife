import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';

class BotonAgregarCarrito extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final Color color;
  final Color? colortext;
  final VoidCallback onTap;
  const BotonAgregarCarrito({
    Key? key,
    this.colortext = Colors.white,
    required this.height,
    required this.width,
    required this.color,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 10),
      height: height,
      width: width,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: MaterialButton(
        onPressed: onTap,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: colortext, fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
      ),
    );
  }
}
