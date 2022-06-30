import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

var providerDatos = new DatosListas();

class FiltroPrecios extends StatefulWidget {
  FiltroPrecios({Key? key}) : super(key: key);

  @override
  _FiltroPreciosState createState() => _FiltroPreciosState();
}

class _FiltroPreciosState extends State<FiltroPrecios> {
  ControllerProductos catalogSearchViewModel = Get.find();
  RangeValues values = RangeValues(0, 1000000);
  int valorRound = 3;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final providerDatos = Provider.of<DatosListas>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('', style: TextStyle(color: HexColor("#41398D"))),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: size.height * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(20.0),
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text("Mejora tu búsqueda",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: HexColor("#41398D")),
                        textAlign: TextAlign.left),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.close,
                        color: HexColor("#30C3A3"),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(5.0),
                child: Text("Ofertas y promociones",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: HexColor("#41398D")),
                    textAlign: TextAlign.left),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  GestureDetector(
                      onTap: () => {_cambiarValor(1)},
                      child: valorRound == 2
                          ? Icon(
                              Icons.brightness_1_outlined,
                              color: HexColor("#41398D"),
                            )
                          : valorRound == 3
                              ? Icon(
                                  Icons.brightness_1_outlined,
                                  color: HexColor("#41398D"),
                                )
                              : Icon(
                                  Icons.task_alt_outlined,
                                  color: HexColor("#30C3A3"),
                                )),
                  SizedBox(width: 10),
                  Text("Producto del día",
                      style: TextStyle(color: HexColor("#41398D")))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              // Row(
              //   children: [
              //     GestureDetector(
              //       onTap: () => {_cambiarValor(2)},
              //       child: valorRound == 1
              //           ? Icon(
              //               Icons.brightness_1_outlined,
              //               color: HexColor("#41398D"),
              //             )
              //           : valorRound == 3
              //               ? Icon(Icons.brightness_1_outlined,
              //                   color: HexColor("#41398D"))
              //               : Icon(
              //                   Icons.task_alt_outlined,
              //                   color: HexColor("#30C3A3"),
              //                 ),
              //     ),
              //     SizedBox(width: 10),
              //     Text("Producto más vendido",
              //         style: TextStyle(color: HexColor("#41398D")))
              //   ],
              // ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(5.0),
                child: Text("Rango de precios",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: HexColor("#41398D")),
                    textAlign: TextAlign.left),
              ),
              SizedBox(
                height: 40,
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.white,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15.0),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
                    thumbColor: Colors.red,
                    valueIndicatorColor: HexColor("#43398E"),
                    activeTickMarkColor: Colors.yellow,
                    overlayColor: Colors.yellow,
                    valueIndicatorTextStyle:
                        TextStyle(color: Colors.white, letterSpacing: 2.0)),
                child: RangeSlider(
                  values: values,
                  min: 0,
                  max: 1000000,
                  divisions: 4000,
                  activeColor: HexColor("#30C3A3"),
                  inactiveColor: HexColor("#9F9F9F"),
                  labels: RangeLabels(
                    values.start.round().toString(),
                    values.end.round().toString(),
                  ),
                  onChanged: (values) => setState(() => {this.values = values}),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  _cargarPrecios(values, providerDatos);
                },
                child: Container(
                  width: size.width * 0.9,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    color: HexColor("#30C3A3"),
                    //border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Filtrar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _cambiarValor(int i) {
    setState(() {
      valorRound = i;
    });
  }

  _cargarPrecios(RangeValues values, providerDatos) {
    catalogSearchViewModel.setPrecioMinimo(values.start);
    catalogSearchViewModel.setPrecioMaximo(values.end);
    catalogSearchViewModel.setIsFilter(true);
    // providerDatos.guardarPrecioMinimo(values.start);
    // providerDatos.guardarPrecioMaximo(values.end);
    Navigator.pop(context);
  }
}
