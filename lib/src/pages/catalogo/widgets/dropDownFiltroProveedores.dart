import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class DropDownFiltroProveedores extends StatefulWidget {
  final String titulo;
  final List<String> listaItems;
  final String? hin;
  final Function(String?)? onChange;
  final String? value;
  final Color? color;
  final Color? textcolor;

  DropDownFiltroProveedores(
      {Key? key,
      required this.titulo,
      required this.listaItems,
      required this.hin,
      required this.onChange,
      required this.value,
      this.color,
      this.textcolor
      })
      : super(key: key);

  @override
  State<DropDownFiltroProveedores> createState() =>
      _DropDownFiltroProveedoresState();
}

class _DropDownFiltroProveedoresState extends State<DropDownFiltroProveedores> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.titulo,
            style: TextStyle(color: HexColor("#41398D")),
          ),
          DropdownButton2(
            buttonWidth: 200,
            iconDisabledColor: widget.textcolor ?? Colors.white,
            iconEnabledColor: widget.textcolor ?? Colors.white,
            hint: Text(
              '    ${widget.hin}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style:
                  TextStyle(color: widget.textcolor ?? Colors.white, fontWeight: FontWeight.bold),
            ),
            buttonPadding: const EdgeInsets.only(left: 14, right: 14),
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
                            color: widget.textcolor ?? Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ))
                .toList(),
            value: widget.value,
            buttonDecoration: BoxDecoration(
                color: widget.color ?? ConstantesColores.azul_precio,
                borderRadius: BorderRadius.circular(30)),
            dropdownDecoration: BoxDecoration(
                color: ConstantesColores.agua_marina,
                borderRadius: BorderRadius.circular(20)),
            onChanged: widget.onChange,
          ),
        ],
      ),
    );
  }
}
