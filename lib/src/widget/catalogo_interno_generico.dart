import 'package:emart/src/pages/catalogo/widgets/filtros_categoria_proveedores/filtro_proveedor.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/lista_productos_para_catalogo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'dounser.dart';
import 'filtro_precios.dart';

var providerDatos = new DatosListas();

class CatalogInternoGenerico extends StatefulWidget {
  final String codCategoria;
  final String numEmpresa;
  final int tipoCategoria;
  final String nombreCategoria;

  const CatalogInternoGenerico({
    Key? key,
    required this.codCategoria,
    required this.numEmpresa,
    required this.tipoCategoria,
    required this.nombreCategoria,
  }) : super(key: key);

  @override
  State<CatalogInternoGenerico> createState() => _CatalogInternoGenericoState();
}

class _CatalogInternoGenericoState extends State<CatalogInternoGenerico> {
  final TextEditingController _controllerUser = TextEditingController();
  final prefs = new Preferencias();

  final Debouncer onSearchDebouncer =
      new Debouncer(delay: new Duration(milliseconds: 500));

  @override
  Widget build(BuildContext context) {
    providerDatos = Provider.of<DatosListas>(context, listen: true);

    return Column(
      children: [
        Container(
            height: Get.height * 0.1,
            width: Get.width * 1,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _campoTexto(context, onSearchDebouncer),
                  GestureDetector(
                    onTap: () => {_irFiltro()},
                    child: Container(
                      margin: EdgeInsets.only(right: 20, bottom: 10),
                      child: GestureDetector(
                        child: SvgPicture.asset('assets/filtro_btn.svg'),
                      ),
                    ),
                  )
                ])),
        Expanded(
          flex: 2,
          child: Container(
            height: Get.height * 0.8,
            width: Get.width * 1,
            //padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
            child: FutureBuilder(
                // initialData: [],
                //SE VA DESCARGAR POR DB
                future: DBProvider.db.cargarProductos(
                    widget.codCategoria,
                    widget.tipoCategoria,
                    _controllerUser.text,
                    providerDatos.getPrecioMinimo,
                    providerDatos.getPrecioMaximo,
                    ""),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListaProductosCatalogo(
                        data: snapshot.data,
                        numEmpresa: widget.numEmpresa,
                        cantidadFilas: 2,
                        location: widget.nombreCategoria);
                  }
                }),
          ),
        ),
      ],
    );
  }

  _campoTexto(BuildContext context, Debouncer onSearchDebouncer) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 12, 10),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: HexColor("#E4E3EC"),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
          controller: _controllerUser,
          style: TextStyle(color: HexColor("#41398D"), fontSize: 13),
          decoration: InputDecoration(
            fillColor: HexColor("#41398D"),
            hintText: 'Encuentra tus productos',
            hintStyle: TextStyle(
              color: HexColor("#41398D"),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Icon(
                Icons.search,
                color: HexColor("#41398D"),
              ),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.fromLTRB(10.0, 15, 10.0, 0),
          ),
          onChanged: (val) => onSearchDebouncer.debounce(() {
                if (val.length > 3) {
                  //FIREBASE: Llamamos el evento search
                  TagueoFirebase().sendAnalityticsSearch(val);
                  //UXCam: Llamamos el evento search
                  UxcamTagueo().search(val);
                }
                setState(() {});
              })),
    );
  }

  _irFiltro() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FiltroProveedor(
              codCategoria: widget.codCategoria,
              nombreCategoria: widget.nombreCategoria,
              urlImagen: "")),
    );
  }
}
