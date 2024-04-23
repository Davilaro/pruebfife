import 'package:auto_size_text/auto_size_text.dart';
import 'package:emart/_pideky/presentation/customers_prospection/view/customers_prospection_page.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/shared/widgets/acordion.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class MisProveedores extends StatelessWidget {
  final prefs = new Preferencias();
  final productViewModel = Get.find<ProductViewModel>();

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
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ConstantesColores.color_fondo_gris,
          statusBarIconBrightness: Brightness.dark,
        ),
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
                            title: Column(
                              children: [
                                Text(
                                  proveedores[i].nombrecomercial.toString(),
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            isIconState: true,
                            estado: proveedores[i].estado,
                            contenido: Container(
                              child: proveedores[i].estado == 'Activo'
                                  ? Column(
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
                                                      proveedores[i]
                                                          .razonSocial,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              ConstantesColores
                                                                  .gris_textos),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                'Nit con el que me facturan: ${proveedores[i].nitCliente}',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: ConstantesColores
                                                        .gris_textos,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              FutureBuilder(
                                                  future: validarCliente(
                                                      proveedores[i].empresa),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<dynamic>
                                                              snapshot) {
                                                    if (snapshot.hasData) {
                                                      return Text(
                                                        'Mi código de cliente: ${snapshot.data}',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                ConstantesColores
                                                                    .gris_textos,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      );
                                                    } else {
                                                      return SizedBox.shrink();
                                                    }
                                                  }),
                                            ],
                                          ),
                                        ),
                                        prefs.paisUsuario == 'CR'
                                            ? Container(
                                                width: Get.width * 1,
                                                margin:
                                                    EdgeInsets.only(top: 15),
                                                decoration: BoxDecoration(
                                                    color: ConstantesColores
                                                        .azul_aguamarina_botones,
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            bottom:
                                                                Radius.circular(
                                                                    5))),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 10),
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
                                    )
                                  : BotonAgregarCarrito(
                                      color: ConstantesColores
                                          .azul_aguamarina_botones,
                                      onTap: () {
                                        Get.to(
                                            () => CustomersProspectionPage());
                                      },
                                      width: Get.width * 0.85,
                                      borderRadio: 30,
                                      text:
                                          'Quiero ser cliente de este proveedor'),
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

  Future<String> validarCliente(empresa) async {
    String dataToShow = await DBProvider.db.consultarCodigoProveedores(empresa);
    return dataToShow != '' ? dataToShow : 'No disponible';
  }
}
