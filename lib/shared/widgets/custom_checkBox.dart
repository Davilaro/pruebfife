import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  @override
  _CustomCheckBoxState createState() =>
      _CustomCheckBoxState();
}

class _CustomCheckBoxState
    extends State<CustomCheckBox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: _isChecked,
      onChanged: (newValue) {
        setState(() {
          _isChecked = newValue!;
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