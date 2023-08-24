import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';

class CheckBoxRememberCredentials extends StatefulWidget {
  @override
  _CheckBoxRememberCredentialsState createState() =>
      _CheckBoxRememberCredentialsState();
}

class _CheckBoxRememberCredentialsState
    extends State<CheckBoxRememberCredentials> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Recuérdame la próxima vez',
          style: TextStyle(
            color: ConstantesColores.gris_sku, // Color de letra gris claro
          ),
        ),
        Checkbox(
          value: _isChecked,
          onChanged: (newValue) {
            setState(() {
              _isChecked = newValue!;
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          side: BorderSide(
            color: Colors.grey[400]!,
            width: 1.0,
          ),
          splashRadius: 1,
          fillColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.black.withOpacity(0.2); // Sombra en la parte inferior cuando está en hover
            }
            return Colors.white; // Cambia el color del relleno cuando está sin seleccionar
          }),
          overlayColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return Colors.black.withOpacity(0.2); // Sombra en la parte inferior cuando está en hover
              }
              return Colors.black38; // Sin efecto de overlay
            },
          ),
          checkColor: ConstantesColores.azul_precio, // Cambia el color del chulito cuando está seleccionado
        ),
      ],
    );
  }
}