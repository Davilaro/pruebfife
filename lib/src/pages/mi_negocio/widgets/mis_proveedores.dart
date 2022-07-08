import 'package:emart/src/pages/mi_negocio/widgets/acordion.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:hexcolor/hexcolor.dart';

class MisProveedores extends StatelessWidget {
  final prefs = new Preferencias();

  @override
  Widget build(BuildContext context) {
    //UXCAM: Se define el nombre de la pantalla
    FlutterUxcam.tagScreenName('MySuppliersPage');

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis proveedores',
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
        color: ConstantesColores.color_fondo_gris,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ListView(children: [
          FutureBuilder(
              future: DBProvider.db.consultarProveedores(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  var proveedores = snapshot.data;
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 40, bottom: 20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Despliega las pestañas para ver la información de tus proveedores',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontSize: 13,
                                color: ConstantesColores.gris_textos,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      for (int i = 0; i < snapshot.data!.length; i++)
                        Container(
                          child: Acordion(
                            urlIcon: proveedores[i].icono,
                            title: Text(
                              proveedores[i].nombrecomercial.toString(),
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            isIconState: true,
                            estado: proveedores[i].estado,
                            contenido: Container(
                              padding: EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          proveedores[i].razonSocial,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: ConstantesColores
                                                  .gris_textos),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'Nit con el que me facturan: ${proveedores[i].nitCliente}',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: ConstantesColores.gris_textos,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Mi código de cliente: ${prefs.codCliente}',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: ConstantesColores.gris_textos,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                    ],
                  );
                }
                return CircularProgressIndicator();
              }),
        ]),
      ),
    );
  }
}
