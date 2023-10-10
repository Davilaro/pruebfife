import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/widget/input_valores_catalogo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListaProductosCatalogo extends StatefulWidget {
  final String numEmpresa;
  final List<dynamic> data;
  final int cantidadFilas;
  final String location;

  ListaProductosCatalogo(
      {Key? key,
      required this.numEmpresa,
      required this.data,
      required this.cantidadFilas,
      required this.location})
      : super(key: key);

  @override
  State<ListaProductosCatalogo> createState() => _ListaProductosCatalogoState();
}

class _ListaProductosCatalogoState extends State<ListaProductosCatalogo> {
  ControllerProductos constrollerProductos = Get.find();
  var contador = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    constrollerProductos.getAgotados();

    if (widget.data.length > 0 && contador < 1) {
      //FIREBASE: Llamamos el evento view_item_list
      TagueoFirebase().sendAnalityticViewItemList(widget.data, widget.location);
      contador++;
    }
    return GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 4.0, // Espaciado vertical
        mainAxisSpacing: 4.0, // espaciado entre ejes principales (horizontal)
        childAspectRatio: 2 / 3.3, //entre mas cerca de cero
        children: _cargarProductosLista(widget.data, context));
  }

  _cargarProductosLista(List<dynamic> data, BuildContext context) {
    final List<Widget> opciones = [];

    for (var i = 0; i < data.length; i++) {
      Producto productos = data[i];
      final widgetTemp = InputValoresCatalogo(
        element: productos,
        isCategoriaPromos: false,
        index: i,
      );

      opciones.add(widgetTemp);
    }
    return opciones;
  }
}
