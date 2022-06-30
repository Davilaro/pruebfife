import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/src/pages/catalogo/widgets/catalogo.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

final prefs = new Preferencias();

class AccesosRapidos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CarroModelo>(context);

    return FutureBuilder(
      initialData: [],
      future: DBProvider.db.consultarAccesosRapidos(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 3 / 3,
              crossAxisSpacing: 1.0,
              mainAxisSpacing: 1.0,
              children:
                  _cargarDatos(context, snapshot.data, provider).toList());
        }
      },
    );
  }

  List<Widget> _cargarDatos(BuildContext context, List<dynamic> listaProductos,
      CarroModelo provider) {
    final List<Widget> opciones = [];

    if (listaProductos.length == 0) {
      return opciones..add(Text('No hay informacion para mostrar'));
    }

    listaProductos.forEach((element) {
      final templete = GestureDetector(
        onTap: () => {
          //FIREBASE: Llamamos el evento quick_access
          TagueoFirebase().sendAnalityticSelectQuickAccess(
              element.descripcion, element.codigo),
          _onClickCatalogo(
              element.codigo, context, provider, element.descripcion)
        },
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            height: Get.height * 4,
            width: Get.width * 1,
            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
            alignment: Alignment.center,
            color: Colors.white,
            child: CachedNetworkImage(
              imageUrl: element.ico,
              placeholder: (context, url) =>
                  Image.asset('assets/jar-loading.gif'),
              errorWidget: (context, url, error) =>
                  Image.asset('assets/logo_login.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      );

      opciones.add(templete);
    });

    return opciones;
  }

  _onClickCatalogo(String codigo, BuildContext context, CarroModelo provider,
      String nombre) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CatalogoPoductos(
                  codCliente: prefs.codCliente,
                  codTienda: prefs.codTienda,
                  codCategoria: codigo,
                  numEmpresa: 'nutresa',
                  tipoCategoria: 3,
                  nombreCategoria: nombre,
                )));
  }
}
