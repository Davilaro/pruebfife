import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/_pideky/domain/producto/service/producto_service.dart';
import 'package:emart/_pideky/infrastructure/productos/producto_repository_sqlite.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:emart/src/widget/input_lista_recomendado.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

final prefs = new Preferencias();

class Recomendados extends StatelessWidget {
  ProductoService productService = ProductoService(ProductoRepositorySqlite());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: SvgPicture.asset('assets/image/app_bar.svg', fit: BoxFit.fill),
          elevation: 0,
          actions: <Widget>[
            BotonActualizar(),
            AccionesBartCarrito(esCarrito: false),
          ],
        ),
        body: FutureBuilder(
            initialData: [],
            future: productService.consultarSugerido(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(children: _cargarDatos(context, snapshot.data));
            }));
  }

  List<Widget> _cargarDatos(
      BuildContext context, List<dynamic> listaProductos) {
    final List<Widget> opciones = [];

    if (listaProductos.length == 0) {
      return opciones..add(Text('No hay informacion para mostrar'));
    }

    listaProductos.forEach((element) {
      Producto productos = element;

      final template = CarritoDisenoListaRLista(
          numTienda: prefs.numEmpresa, productos: productos);
      opciones.add(template);
    });

    return opciones;
  }
}
