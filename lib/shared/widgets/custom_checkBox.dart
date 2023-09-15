import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  @override
  _CustomCheckBoxState createState() =>
      _CustomCheckBoxState();
}

class _CustomCheckBoxState
    extends State<CustomCheckBox> {
  bool _isChecked = false;
  final prefs = Preferencias();

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: prefs.rememberMe,
      onChanged: (newValue) {
        print("new value $newValue");
        setState(() {
          prefs.rememberMe = _isChecked;
        });
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      fillColor: MaterialStateProperty.all(Colors.white),
      side: BorderSide(
        color: Colors.grey[400]!,
        
        width: 1.0,
      ),
      splashRadius: 1,
     
      
      checkColor: ConstantesColores.azul_precio, 
    );
  }
}