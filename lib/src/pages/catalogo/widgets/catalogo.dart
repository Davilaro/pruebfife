import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:emart/src/widget/catalogo_interno_generico.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:hexcolor/hexcolor.dart';

class CatalogoPoductos extends StatefulWidget {
  final String codCliente;
  final String codTienda;
  final String codCategoria;
  final String numEmpresa;
  final int tipoCategoria;
  final String nombreCategoria;

  const CatalogoPoductos(
      {Key? key,
      required this.codCliente,
      required this.codTienda,
      required this.codCategoria,
      required this.numEmpresa,
      required this.tipoCategoria,
      required this.nombreCategoria})
      : super(key: key);

  @override
  State<CatalogoPoductos> createState() => _CatalogoPoductosState();
}

class _CatalogoPoductosState extends State<CatalogoPoductos> {
  @override
  Widget build(BuildContext context) {
    //UXCAM: Se define el nombre de la pantalla
    FlutterUxcam.tagScreenName('${widget.nombreCategoria}Page');

    return Scaffold(
        backgroundColor: ConstantesColores.color_fondo_gris,
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
            onPressed: () => Navigator.of(context).pop(),
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ConstantesColores.color_fondo_gris,
            statusBarIconBrightness: Brightness.dark,
          ),
          title: Text(
            '${widget.nombreCategoria}',
            style: TextStyle(color: HexColor("#41398D")),
          ),
          elevation: 0,
          actions: <Widget>[
            BotonActualizar(),
            AccionesBartCarrito(esCarrito: false),
          ],
        ),
        body: CatalogInternoGenerico(
          codCategoria: widget.codCategoria,
          numEmpresa: 'nutresa',
          tipoCategoria: 3,
          nombreCategoria: widget.nombreCategoria,
        ));
  }
}
