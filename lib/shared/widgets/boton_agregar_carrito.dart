import 'package:flutter/material.dart';

class BotonAgregarCarrito extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final double? height;
  final double? width;
  final double? marginTop;
  final Color color;
  final Color? colortext;
  final double borderRadio;
  const BotonAgregarCarrito(
      {Key? key,
      this.colortext = Colors.white,
      this.height,
      this.width,
      required this.color,
      required this.onTap,
      required this.text,
      this.borderRadio = 20,
      this.marginTop = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: marginTop!, bottom: 10),
      height: height ?? null,
      width: width ?? null,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(borderRadio)),
      child: MaterialButton(
        onPressed: onTap,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: colortext, fontWeight: FontWeight.bold, fontSize: 17),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
