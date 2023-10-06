import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../src/preferences/cont_colores.dart';

class PassworRequirementsText extends StatelessWidget {
  const PassworRequirementsText();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tu contraseña debe:',
              // textAlign: TextAlign.start,
              style: TextStyle(
                  color: HexColor("#41398D"),
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700)),
          SizedBox(height: 20),
          Requirements(
            textWidget: Text(
              'Tener letras y números',
              style: TextStyle(
                color: ConstantesColores.gris_sku,
                fontSize: 16,
              ),
            ),
          ),

          SizedBox(height: 20),

          Requirements(
            textWidget: Text(
              'No tener caracteres especiales(#*+&\$)',
              style: TextStyle(
                color: ConstantesColores.gris_sku,
                fontSize: 16,
              ),
            ),
          ),

          SizedBox(height: 20),

          Requirements(
            textWidget: Text(
              'Tener una letra mayúscula',
              style: TextStyle(
                color: ConstantesColores.gris_sku,
                fontSize: 16,
              ),
            ),
          ),

          SizedBox(height: 20),

          Requirements(
            textWidget: Text(
              'Tener mínimo 8 caracteres',
              style: TextStyle(
                color: ConstantesColores.gris_sku,
                fontSize: 16,
              ),
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class Requirements extends StatelessWidget {
  final Widget textWidget;

  const Requirements({
    Key? key,
    required this.textWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: HexColor("#41398D"),
              width: 2.0,
            ),
            color: Colors.white,
          ),
          child: Icon(
            Icons.check,
            color: HexColor("#41398D"),
            size: 13,
          ),
        ),
        SizedBox(width: 15),
        textWidget
        // Text(
        //   'Tener letras y números',
        //   style: TextStyle(
        //     color: Colors.black,
        //     fontSize: 16,
        //   ),
        // ),
      ],
    );
  }
}
