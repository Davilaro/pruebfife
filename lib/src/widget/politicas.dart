import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/utils/colores.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Politicas extends StatefulWidget {
  Politicas({Key? key}) : super(key: key);

  @override
  _PoliticasState createState() => _PoliticasState();
}

class _PoliticasState extends State<Politicas> {
  var urlPoliticas = '';

  @override
  void initState() {
    super.initState();
    cargarArchivo();
  }

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _verPoliticasCondiciones(context),
      child: Column(
        children: [
          Text(
            'Ver políticas de tratamiento de datos',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: HexColor(Colores().color_azul_letra),
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }

  void _verPoliticasCondiciones(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Column(
              children: [
                Container(
                    height: Get.height * 0.8,
                    width: Get.height * 0.8,
                    child:  SfPdfViewer.network(
                    urlPoliticas,
                    key: _pdfViewerKey,
                  ),
                    ),
                GestureDetector(
                  onTap: () {
                    _aceptarPoliticas();
                  },
                  child: Container(
                    width: Get.width * 0.9,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      color: HexColor("#30C3A3"),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Aceptar',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  cargarArchivo() async {
    try {
      urlPoliticas =
          await DBProvider.db.consultarDocumentoLegal('Autorización');
      setState(() {});
    } catch (e) {
      print('Error al cagar archivos $e');
    }
  }

  void _aceptarPoliticas() {
    Navigator.pop(context);
  }
}
