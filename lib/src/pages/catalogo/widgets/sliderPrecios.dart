import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SliderPrecios extends StatefulWidget {
  RangeValues values;
  final Function onChange;
  SliderPrecios({Key? key, required this.values, required this.onChange})
      : super(key: key);

  @override
  State<SliderPrecios> createState() => _SliderPreciosState();
}

class _SliderPreciosState extends State<SliderPrecios> {
  ControllerProductos catalogSearchViewModel = Get.find();
  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
          activeTrackColor: Colors.white,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15.0),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
          thumbColor: Colors.red,
          valueIndicatorColor: ConstantesColores.agua_marina,
          activeTickMarkColor: Colors.yellow,
          overlayColor: Colors.yellow,
          valueIndicatorTextStyle:
              TextStyle(color: Colors.white, letterSpacing: 2.0)),
      child: RangeSlider(
        values: widget.values,
        min: 0.0,
        max: 500000.0,
        divisions: 500000,
        activeColor: ConstantesColores.azul_precio,
        inactiveColor: ConstantesColores.gris_textos,
        labels: RangeLabels(
          widget.values.start.round().toString(),
          widget.values.end.round().toString(),
        ),
        onChanged: (values) => setState(() {
          widget.values = values;
          catalogSearchViewModel.setPrecioMinimo(widget.values.start);
          catalogSearchViewModel.setPrecioMaximo(widget.values.end);
          catalogSearchViewModel.setIsFilter(true);
        }),
      ),
    );
  }
}
