import 'package:emart/src/utils/util.dart';
import 'package:flutter/material.dart';

class CardTicket extends CustomPainter {
  final String color;
  CardTicket({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final formatColor = "0xff$color";

    // propiedades
    paint.color =  Color(toInt(formatColor));
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 3;

    final path = Path();

    // realizar el trazo
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.65);
    // se realiza la curbatura para el ticket
    path.quadraticBezierTo(
        size.width * 0.92, size.height * 0.5, size.width, size.height * 0.35);
    path.lineTo(size.width, 0.0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
