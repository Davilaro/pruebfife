import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/src/modelos/productos.dart';
import 'package:emart/src/provider/servicios.dart';
import 'package:emart/src/widget/input_valores_catalogo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CatalogoPoductosCategorias extends StatelessWidget {
  final String codCliente;
  final String codTienda;
  final String codCategoria;
  final String numEmpresa;
  final int tipoPedido;
  final constrollerProductos = Get.find<ControllerProductos>();

  CatalogoPoductosCategorias(
      {Key? key,
      required this.codCliente,
      required this.codTienda,
      required this.codCategoria,
      required this.numEmpresa,
      required this.tipoPedido})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        initialData: [],
        future: Servicies()
            .getListaProductos(codTienda, codCliente, codCategoria, tipoPedido),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.0, // Espaciado vertical
                    mainAxisSpacing:
                        4.0, // espaciado entre ejes principales (horizontal)
                    childAspectRatio: 2 / 3.3,
                    children:
                        _cargarProductosLista(snapshot.data.result, context));
              }
          }
        },
      ),
    );
  }

  List<Widget> _cargarProductosLista(List<dynamic> data, BuildContext context) {
    final List<Widget> opciones = [];

    for (var element in data) {
      Productos productos = element;
      bool isProductoPromo = false;

      final widgetTemp = InputValoresCatalogo(
        element: productos,
        numEmpresa: numEmpresa,
        isCategoriaPromos: false,
        index: data.indexOf(element),
      );

      opciones.add(widgetTemp);
    }

    return opciones;
  }
}
