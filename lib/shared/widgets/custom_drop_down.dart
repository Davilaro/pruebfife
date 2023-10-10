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
          decoration: BoxDecoration(
            color: ConstantesColores.azul_precio,
            borderRadius: BorderRadius.circular(50),
          ),
          margin: EdgeInsets.symmetric(horizontal: 2),
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
            iconSize: 30,
            selectedItemBuilder: (context) => selectItem!.toList(),
            scrollbarThickness: 2,
            onChanged: onChanged,
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
            buttonHeight: 60,
            buttonPadding: const EdgeInsets.only(left: 20, right: 10),
            dropdownElevation: 8,
            dropdownMaxHeight: 200,
            dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
            underline: Container(
              color: Colors.transparent,
            ),
            itemHeight: 40,
            itemPadding: const EdgeInsets.symmetric(horizontal: 20),
          )),
    );
  }
}
