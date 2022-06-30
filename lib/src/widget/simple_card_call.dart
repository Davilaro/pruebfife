import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class SimpleCardCall extends StatefulWidget {
  final String texto;
  final String telefono;

  SimpleCardCall({
    Key? key,
    required this.texto,
    required this.telefono,
  }) : super(key: key);

  @override
  _SimpleCardCallState createState() => _SimpleCardCallState();
}

class _SimpleCardCallState extends State<SimpleCardCall> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => {_cargarNumeroTelefono(widget.telefono)},
      child: Container(
        margin: EdgeInsets.all(2),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: HexColor("#EEEEEE"),
                ),
                child: Column(
                  children: [
                    Table(
                      columnWidths: {
                        0: FlexColumnWidth(5),
                        1: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                widget.texto,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: HexColor("#43398E"),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            alignment: Alignment.center,
                          ),
                        ])
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _cargarNumeroTelefono(telefono) {
    UrlLauncher.launch("tel://$telefono");
  }
}
