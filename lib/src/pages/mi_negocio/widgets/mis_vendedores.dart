import 'package:emart/src/pages/mi_negocio/widgets/acordion.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class MisVendedores extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //UXCAM: Se define el nombre de la pantalla
    FlutterUxcam.tagScreenName('MyVendorsPage');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mis vendedores',
          style: TextStyle(
              color: ConstantesColores.azul_precio,
              fontWeight: FontWeight.bold),
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
                                    j < listaVendedores[i]['vendedores'].length;
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
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '+57 ${listaVendedores[i]['vendedores'][j]['telefono']}',
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
    );
  }

  List cargarVendedores(data) {
    var listVendedores = [];
    for (var i = 0; i < data.length; i++) {
      List listTemporal = data;
      var res = [];
      var item = data[i];
      for (var j = 0; j < listTemporal.length; j++) {
        if (item.nombreEmpresa == listTemporal[j].nombreEmpresa) {
          res.add({
            "vendedor": listTemporal[j].nombre,
            "telefono": listTemporal[j].telefono
          });
        }
      }
      listVendedores.add({
        "nombreComercial": item?.nombreComercial,
        "icono": item?.icono,
        "vendedores": res
      });
    }
    return listVendedores;
  }

  _cargarNumeroTelefono(telefono) {
    UrlLauncher.launch("tel://$telefono");
  }
}
