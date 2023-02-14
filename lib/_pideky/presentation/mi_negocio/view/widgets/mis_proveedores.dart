import 'package:auto_size_text/auto_size_text.dart';
import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';
import 'package:emart/shared/widgets/acordion.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class MisProveedores extends StatelessWidget {
  final prefs = new Preferencias();
  final productViewModel = Get.find<ProductoViewModel>();

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
          BotonActualizar(),
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
                      for (int i = 0; i < proveedores!.length; i++)
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
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              color:
                                                  ConstantesColores.gris_textos,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Mi código de cliente: ${validarCliente(proveedores[i].empresa)}',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color:
                                                  ConstantesColores.gris_textos,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  prefs.paisUsuario == 'CR'
                                      ? Container(
                                          width: Get.width * 1,
                                          margin: EdgeInsets.only(top: 15),
                                          decoration: BoxDecoration(
                                              color: ConstantesColores
                                                  .azul_aguamarina_botones,
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      bottom:
                                                          Radius.circular(5))),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: AutoSizeText(
                                            'Recuerda que puedes realizar el pedido: ${productViewModel.getListaDiasSemana(proveedores[i].empresa)}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                            paddingContenido: prefs.paisUsuario == 'CR'
                                ? EdgeInsets.zero
                                : EdgeInsets.only(bottom: 15),
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

  String validarCliente(empresa) {
    if (empresa == 'NUTRESA') {
      return prefs.codigonutresa.toString();
    }
    if (empresa == 'ZENU') {
      return prefs.codigozenu.toString();
    }
    if (empresa == 'MEALS') {
      return prefs.codigomeals.toString();
    }
    if (empresa == 'POZUELO') {
      return prefs.codigopozuelo.toString();
    }
    if (empresa == 'ALPINA') {
      return prefs.codigoalpina.toString();
    }

    return '';
  }
}
