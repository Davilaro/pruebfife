import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

void verPoliticasCondiciones(BuildContext context, politicasDatosPdf) {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  void _aceptarPoliticas() {
    Navigator.pop(context);
  }

  print('hola res $politicasDatosPdf');

  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Column(
            children: [
              Container(
                height: Get.height * 0.8,
                width: Get.height * 0.8,
                child: PDFView(
                  pdfData: politicasDatosPdf,
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
