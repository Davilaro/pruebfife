import 'package:flutter/material.dart';



class BuscadorTxtProductos extends StatelessWidget {

  final TextEditingController _controllerUser = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: _controllerUser,
        style: TextStyle(color: Colors.black, fontSize: 15 ),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          fillColor: Colors.grey,
          hintText: 'NIT sin dígito de verificación',
          hintStyle: TextStyle( color: Colors.grey),
          labelText: 'NIT sin dígito de verificación',
          labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: border,
          border: border, 
        ),
      ),
    );
  }

  final border = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(
      color: Colors.grey,
    )
  );

}