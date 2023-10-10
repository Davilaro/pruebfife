import 'package:emart/src/modelos/screen_arguments.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';


String codEmpresa = '';

class ListaEmpresasEmart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Se define el nombre de la pantalla para UXCAM
    FlutterUxcam.tagScreenName('ListCompaniesPage');
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pideky'),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ConstantesColores.color_fondo_gris,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0, // Espaciado vertical
          mainAxisSpacing:
              10.0, // espaciado entre ejes principales (horizontal)
          childAspectRatio: 0.7,
          padding: EdgeInsets.all(10),
          children: _getData(args.listaEmpresas, context)),
    );
  }

  List<Widget> _getData(List<dynamic> listaDatos, BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < listaDatos.length; i++) {
      list.add(
        GestureDetector(
          onTap: () => _pasarModuloSiguiente(
              listaDatos[i].codigoEmpresa,
              listaDatos[i].sucursales,
              listaDatos[i].numEmpresa,
              listaDatos[i].color,
              context),
          child: Card(
            shape: RoundedRectangleBorder(
                side: new BorderSide(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.circular(8.0)),
            child: Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              child: FadeInImage(
                image: NetworkImage(Constantes().urlImg +
                    '${listaDatos[i].codigoEmpresa}/${listaDatos[i].codigoEmpresa}.png'),
                placeholder: AssetImage('assets/image/jar-loading.gif'),
                fadeInDuration: Duration(milliseconds: 200),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      );
    }
    return list;
  }

  _pasarModuloSiguiente(String codEmpresa, List<dynamic> listaSucursales,
      int numEmpresa, String color, BuildContext context) {
    Navigator.pushNamed(
      context,
      'listaSucursale',
      arguments: ScreenArgumentsSucursales(
        listaSucursales,
        codEmpresa,
        numEmpresa,
        color,
      ),
    );
  }
}

class ScreenArgumentsSucursales {
  final List<dynamic> listaEmpresas;
  final String codEmpresa;
  final int numEmpresa;
  final String color;

  ScreenArgumentsSucursales(
      this.listaEmpresas, this.codEmpresa, this.numEmpresa, this.color);
}
