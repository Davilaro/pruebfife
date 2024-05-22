// ignore_for_file: must_be_immutable

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  List<DropdownMenuItem<String>> lista = [];
  List<Widget>? selectItem = [];
  Text? hint;
  String? value = '';
  Function(String?)? onChanged;
  CustomDropDown(
      {required this.lista,
      this.hint,
      this.value,
      required this.onChanged,
      this.selectItem});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 2),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              hint: hint ??
                  Text(
                    'Seleccionar',
                    style: TextStyle(
                        fontSize: 15,
                        color: ConstantesColores.azul_precio,
                        fontWeight: FontWeight.bold),
                  ),
              value: value,
              items: lista,
              buttonStyleData: ButtonStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: ConstantesColores.azul_precio,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
              iconStyleData: IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: ConstantesColores.azul_aguamarina_botones,
                  ),
                  iconSize: 30),
              selectedItemBuilder: (context) => selectItem!.toList(),
              onChanged: onChanged,
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                elevation: 8,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                maxHeight: 200,
              ),
              menuItemStyleData: MenuItemStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 20), height: 40),
            ),
          )),
    );
  }
}
