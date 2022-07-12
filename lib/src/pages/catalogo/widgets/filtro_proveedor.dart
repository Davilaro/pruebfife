import 'dart:convert';

import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/src/modelos/categorias.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

var providerDatos = new DatosListas();

class FiltroProveedor extends StatefulWidget {
  String codCategoria;
  FiltroProveedor({Key? key, required this.codCategoria}) : super(key: key);

  @override
  _FiltroProveedorState createState() => _FiltroProveedorState();
}

class _FiltroProveedorState extends State<FiltroProveedor> {
  ControllerProductos catalogSearchViewModel = Get.find();
  RangeValues values = RangeValues(0, 1000000);
  int valorRound = 3;
  String? dropdownValueCategoria;
  RxList<String> listCategorias = ['Todos'].obs;
  RxList<String> listSubCategorias = ['Todos'].obs;
  RxList<String> listMarcas = ['Todos'].obs;

  @override
  void initState() {
    // TODO: implement initState
    cargarCategorias();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final providerDatos = Provider.of<DatosListas>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Proveedor',
            style: TextStyle(
                color: ConstantesColores.azul_precio,
                fontWeight: FontWeight.bold)),
        elevation: 0,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          AccionesBartCarrito(esCarrito: true),
        ],
      ),
      body: Container(
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
          child: SingleChildScrollView(
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
                    iconLimpiarFiltro()
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  child: Column(
                    children: [
                      // Filtro de categorias
                      Obx(() => _dropDown(
                          titulo: 'Categoría',
                          hin: 'Todos',
                          listaItems: listCategorias.value,
                          value: dropdownValueCategoria,
                          onChange: (String? value) {
                            setState(() {
                              dropdownValueCategoria = value!;
                            });
                          })),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 40),
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () => {_cambiarValor(1)},
                                child: valorRound == 2
                                    ? Icon(
                                        Icons.brightness_1_outlined,
                                        color: ConstantesColores.azul_precio,
                                      )
                                    : valorRound == 3
                                        ? Icon(
                                            Icons.brightness_1_outlined,
                                            color:
                                                ConstantesColores.azul_precio,
                                          )
                                        : Icon(
                                            Icons.task_alt_outlined,
                                            color:
                                                ConstantesColores.agua_marina,
                                          )),
                            SizedBox(width: 10),
                            Text("Promociones",
                                style: TextStyle(
                                    color: ConstantesColores.azul_precio))
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => {_cambiarValor(2)},
                            child: valorRound == 1
                                ? Icon(
                                    Icons.brightness_1_outlined,
                                    color: ConstantesColores.azul_precio,
                                  )
                                : valorRound == 3
                                    ? Icon(Icons.brightness_1_outlined,
                                        color: ConstantesColores.azul_precio)
                                    : Icon(
                                        Icons.task_alt_outlined,
                                        color: ConstantesColores.agua_marina,
                                      ),
                          ),
                          SizedBox(width: 10),
                          Text("Imperdibles",
                              style: TextStyle(
                                  color: ConstantesColores.azul_precio))
                        ],
                      ),
                    ],
                  ),
                ),
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
                          color: ConstantesColores.azul_precio),
                      textAlign: TextAlign.left),
                ),
                SizedBox(
                  height: 20,
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 15.0),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 30.0),
                      thumbColor: Colors.red,
                      valueIndicatorColor: ConstantesColores.agua_marina,
                      activeTickMarkColor: Colors.yellow,
                      overlayColor: Colors.yellow,
                      valueIndicatorTextStyle:
                          TextStyle(color: Colors.white, letterSpacing: 2.0)),
                  child: RangeSlider(
                    values: values,
                    min: 0,
                    max: 1000000,
                    divisions: 2000,
                    activeColor: ConstantesColores.agua_marina,
                    inactiveColor: ConstantesColores.gris_textos,
                    labels: RangeLabels(
                      values.start.round().toString(),
                      values.end.round().toString(),
                    ),
                    onChanged: (values) =>
                        setState(() => {this.values = values}),
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
                      color: ConstantesColores.agua_marina,
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
      ),
    );
  }

  _cambiarValor(int i) {
    setState(() {
      valorRound = i;
    });
  }

  _dropDown(
      {required String titulo,
      required List<String> listaItems,
      required String? hin,
      required Function(String?)? onChange,
      String? value}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo),
          CustomDropdownButton2(
            hint: hin!,
            iconEnabledColor: ConstantesColores.azul_precio,
            dropdownItems: listaItems,
            value: value,
            iconSize: 25,
            icon: Icon(Icons.arrow_drop_down_outlined),
            buttonWidth: Get.width * 0.5,
            dropdownWidth: Get.width * 0.5,
            buttonDecoration: BoxDecoration(
                color: HexColor('#ecebf3'),
                borderRadius: BorderRadius.circular(30)),
            dropdownDecoration: BoxDecoration(color: HexColor('#ecebf3')),
            onChanged: onChange,
          ),
        ],
      ),
    );
  }

  cargarCategorias() async {
    //validar por el provedor
    var resQuery = await DBProvider.db.consultarCategorias('', 0);
    for (var i = 0; i < resQuery.length; i++) {
      listCategorias.add(resQuery[i].descripcion);
    }
  }

  cargarMarca(String categoria) async {
    var resQuery = await DBProvider.db.consultarMarcas('');
    for (var i = 0; i < resQuery.length; i++) {
      listMarcas.add(resQuery[i].titulo);
    }
  }

  cargarSubCategorias(String categoria) async {
    var resQuery = await DBProvider.db
        .consultarCategoriasSubCategorias(widget.codCategoria);
    for (var i = 0; i < resQuery.length; i++) {
      listSubCategorias.add(resQuery[i].descripcion);
    }
  }

  limpiarFiltro() {
    dropdownValueCategoria = "Todos";
    valorRound = 3;
    values = RangeValues(0, 1000000);

    // catalogSearchViewModel.setFechaFinal('-1');
    // catalogSearchViewModel.setFechaInicial('-1');
    // _selectedDate = null;
    // _selectedDate2 = null;
  }

  Widget iconLimpiarFiltro() {
    return OutlineButton(
      borderSide: BorderSide(style: BorderStyle.none),
      onPressed: () {
        setState(() {
          limpiarFiltro();
        });
      },
      child: Row(
        children: [
          Icon(
            Icons.cleaning_services_outlined,
            size: 30,
            color: HexColor("#43398E"),
          ),
          Text(
            'Limpiar Filtro',
            maxLines: 2,
          )
        ],
      ),
    );
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
