import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/pages/catalogo/widgets/tab_categorias_opciones.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

final prefs = new Preferencias();

class CategoriasCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CarroModelo>(context);

    return FutureBuilder(
      initialData: [],
      future: DBProvider.db.consultarCategoriasDestacadas("", 5),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            scrollDirection: Axis.horizontal,
            children: _cargarDatos(context, snapshot.data, provider),
          );
        }
      },
    );
  }

  List<Widget> _cargarDatos(BuildContext context, List<dynamic> listaCategorias,
      CarroModelo provider) {
    final List<Widget> opciones = [];

    if (listaCategorias.length == 0) {
      return opciones..add(Text('No hay informacion para mostrar'));
    }

    listaCategorias.forEach((element) {
      final templete = Container(
          width: Get.width * 0.31,
          child: GestureDetector(
            onTap: () => {
              //FIREBASE: Llamamos el evento select_content
              TagueoFirebase().sendAnalityticSelectContent(
                  "Home",
                  element.descripcion,
                  '',
                  element.descripcion,
                  element.codigo,
                  'ViewCategoris'),
              //UXCam: Llamamos el evento seeCategory
              UxcamTagueo().seeCategory(element.descripcion),
              _onClickCatalogo(
                  element.codigo, context, provider, element.descripcion)
            },
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                height: Get.height * 0.1,
                width: Get.width * 0.5,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                alignment: Alignment.center,
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CachedNetworkImage(
                        imageUrl: element.ico,
                        height: Get.height * 0.08,
                        placeholder: (context, url) =>
                            Image.asset('assets/jar-loading.gif'),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/logo_login.png'),
                        fit: BoxFit.contain,
                      ),
                      // SvgPicture.network(
                      //   element.ico,
                      //   height: Get.height * 0.08,
                      //   placeholderBuilder: (context) => Container(
                      //     height: Get.height * 0.08,
                      //     child: CircularProgressIndicator(
                      //       valueColor:
                      //           AlwaysStoppedAnimation<Color>(Colors.white),
                      //     ),
                      //   ),
                      // ),
                      AutoSizeText(
                        '${element.descripcion}',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: HexColor("#41398D")),
                        textAlign: TextAlign.center,
                        minFontSize: 8,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ));

      opciones.add(templete);
    });

    return opciones;
  }

  _onClickCatalogo(String codigo, BuildContext context, CarroModelo provider,
      String nombre) async {
    final List<dynamic> listaSubCategorias =
        await DBProvider.db.consultarCategoriasSubCategorias(codigo);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TabOpcionesCategorias(
                  listaCategorias: listaSubCategorias,
                  nombreCategoria: nombre,
                )));
  }
}
