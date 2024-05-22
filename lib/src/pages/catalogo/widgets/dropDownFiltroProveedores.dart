import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropDownFiltroProveedores extends StatefulWidget {
  final List<String> listaItems;
  final String? hin;
  final Function(String?)? onChange;
  final String? value;
  final Color? color;
  final Color? textcolor;

  DropDownFiltroProveedores(
      {Key? key,
      required this.listaItems,
      required this.hin,
      required this.onChange,
      required this.value,
      this.color,
      this.textcolor})
      : super(key: key);

  @override
  State<DropDownFiltroProveedores> createState() =>
      _DropDownFiltroProveedoresState();
}

class _DropDownFiltroProveedoresState extends State<DropDownFiltroProveedores> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.4,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ConstantesColores.agua_marina,
            ),
            elevation: 8,
            padding: EdgeInsets.symmetric(horizontal: 14),
            maxHeight: 200,
          ),
          hint: Text(
            '    ${widget.hin}',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: widget.textcolor ?? Colors.white,
                fontWeight: FontWeight.bold),
          ),
          isExpanded: true,
          underline: Text(''),
          items: widget.listaItems
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color: widget.textcolor ?? Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ))
              .toList(),
          iconStyleData: IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down,
                color: ConstantesColores.azul_precio,
              ),
              iconSize: 30),
          value: widget.value,
          buttonStyleData: ButtonStyleData(
            padding: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: ConstantesColores.color_fondo_gris,
            ),
          ),
          onChanged: widget.onChange,
        ),
      ),
    );
  }
}
