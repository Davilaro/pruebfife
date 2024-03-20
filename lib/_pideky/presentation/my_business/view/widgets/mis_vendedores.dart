import 'package:emart/shared/widgets/acordion.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class MisVendedores extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //UXCAM: Se define el nombre de la pantalla
    FlutterUxcam.tagScreenName('MyVendorsPage');

    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      appBar: AppBar(
        title: Text(
          'Mis vendedores',
          style: TextStyle(
              color: ConstantesColores.azul_precio,
              fontWeight: FontWeight.bold),
        ),
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: FutureBuilder(
              future: DBProvider.db.cargarVendedores(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  var listaVendedores = cargarVendedores(snapshot.data);
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 40, bottom: 20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Despliega las pestañas para ver la información de tus vendedores',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontSize: 13,
                                color: ConstantesColores.gris_textos,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      for (int i = 0; i < listaVendedores.length; i++)
                        Container(
                          child: Acordion(
                            urlIcon: listaVendedores[i]['icono'],
                            title: Text(
                              'Vendedores ${listaVendedores[i]['nombreComercial'].toString()}',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            contenido: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  for (int j = 0;
                                      j <
                                          listaVendedores[i]['vendedores']
                                              .length;
                                      j++)
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: GestureDetector(
                                        onTap: () => _cargarNumeroTelefono(
                                            listaVendedores[i]['vendedores'][j]
                                                ['telefono']),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${listaVendedores[i]['vendedores'][j]['vendedor']}',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: ConstantesColores
                                                        .gris_textos,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${listaVendedores[i]['vendedores'][j]['indicativo']} ${listaVendedores[i]['vendedores'][j]['telefono']}',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: ConstantesColores
                                                      .gris_textos,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
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
        ),
      ),
    );
  }

  List cargarVendedores(data) {
    List<Map<String, dynamic>> listVendedores = [];
    final Map<String, dynamic> mapFilter = {};
    for (var i = 0; i < data.length; i++) {
      List listTemporal = data;
      var res = [];
      var item = data[i];
      for (var j = 0; j < listTemporal.length; j++) {
        if (item.nombreEmpresa == listTemporal[j].nombreEmpresa) {
          res.add({
            "vendedor": listTemporal[j].nombre,
            "telefono": listTemporal[j].telefono,
            "indicativo": listTemporal[j].indicativo
          });
        }
      }
      listVendedores.add({
        "nombreComercial": item?.nombreComercial,
        "icono": item?.icono,
        "vendedores": res
      });
      print("primer for");
    }

    // este codigo de la linea 157 a la 163 se usa para filtrar los vendedores repetidos y que solo los muestre una vez
    for (Map<String, dynamic> myMap in listVendedores) {
      mapFilter[myMap['nombreComercial']] = myMap;
    }
    final List<Map<String, dynamic>> listFilter = mapFilter.keys
        .map((key) => mapFilter[key] as Map<String, dynamic>)
        .toList();

    return listFilter;
  }

  _cargarNumeroTelefono(telefono) {
    UrlLauncher.launch("tel://$telefono");
  }
}
