import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MisEstadisticas extends StatelessWidget {
  const MisEstadisticas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis estadisticas',
            style: TextStyle(
                color: ConstantesColores.azul_precio,
                fontWeight: FontWeight.bold)),
        elevation: 0,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          BotonActualizar(),
          AccionesBartCarrito(esCarrito: true),
        ],
      ),
      body: Container(
        color: ConstantesColores.color_fondo_gris,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(children: [
          Container(
            padding: EdgeInsets.only(top: 40, bottom: 20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'En esta sección enontrarás los prductos, marcas y subcategorias que más compras en Pideky.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 13,
                    color: ConstantesColores.gris_textos,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
